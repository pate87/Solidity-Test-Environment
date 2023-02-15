/*
    Today we will explore how to use blockchain assets to track DAO membership and voting power.

    This contract creates governance tokens for use by the Governance contract to establish membership and voting power for the DAO members.
    
    We will demonstrate using ERC20, ERC721, and ERC1155 contracts for establishing DAO membership, providing a well-rounded idea of how to use blockchain assets 
    to form Decentralized Autonomous Organizations.

    Recall that membership in a DAO is often established by owning a blockchain asset, which the Governance contract can check for in a user's wallet. 
    Token-based models use transferable tokens, while participation and reputation systems use non-transferable tokens or points systems to track user participation 
    and reputation.

    Our Membership contract will include:
        - totalMembers variable for tracking total number of DAO members
            - Called by Governance. _quorumReached
        - memberVotingPower function for returning number of votes assigned for each holder
            - Called by Governance._submitVote
            - Demonstrate both one-vote-per-token and quadratic voting

    We will need to make a few modifications to the Governance contract as well:
        - We will need to add a memberCount property to the Proposaldata struct to track how many members voted on the proposal.
        - We will improve our constructor to take inputs for state variables _quorumReached must refer to the total number of DAO members
        - We will create an onlyMembers modifier to check if a caller is a DAO member
            - We will implement the new modifier on all member-only functions
        - We will have _submitVote call Membership.memberVotingPower to determine how many votes to apply

    We will discuss:
        - Implementing a burn voting model
        - Universal function call syntax used by Governor
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.8.1/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract MembershipERC20 is ERC20("DAOToekn", "DAO") {

    // Track total members in DAO
    uint256 public totalMembers = 0;
    // ERC20, ERC721, and ERC1155 all have a _beforeTokenTransfer hook that is called before balances are updated
        
        // - When a user with a zero balance receives tokens
    // When does totalMembers change?
        // - When a user sends their entire balance
   
    // When does totalMembers NOT change?
        // - When sender is transferring partial balance
        // - When receiver has a non-zero balance
        // - When sender is a contract
        // - When receiver is a contract

    // Checks if an address belongs to a contract
    // Does not work for contracts in construction - Be careful how you use this!
    /*
        This function can be a vulnerable function:
        - If you create a mint function that is publicly accessable and everyone or anything can call it and 
        somebody creates a HACK contract that calls the mint function in a constractor first,
        its gonna fool the tokenTransfer (isContract()) function because the contract hasn't any code yet 
        but after the transaction is over the HACK contrackt works just fine and can work with our contract.
    */
    /*
        MORE DETAILS

        Specifically; you need to be careful with using isContract for privileged functions and features. 
        In our case, we are using it to prevent counting contracts towards the quorum, so it's mostly safe to use.

        However, it could theoretically be fooled, if someone can predict which address a contract will deploy to 
        and have the contract use transferFrom() to transfer itself tokens during construction after approving it.
    */
    function isContract (address account) internal view returns (bool) {
        return account.code.length > 0;
    }

    // Import from OpenZeppelin ERC20, ERC721: - _beforeTokenTransfer Hook that is called BEFORE any transfer of tokens.
        // When does totalMembers change?
            // - When a user with a zero balance receives tokens
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        // Copy of the _beforeTokenTransfer Hook logic
        /*
            DETAILS BETWEEN USING LOCAL AND GLOBAL VAR

            The reason to use a local var is because of gas efficientcy: 
                - read from glob var totalmembers cost 200 gas 
                - modify the glob var totalMembers cost 5000 gas 
                - the local var memberCount only read from the glob var totalMembers
                - memberCount can be modified without using gas
        */
        uint256 memberCount = totalMembers;
        /*
            DETAILS USING TWO SAME VAR's

            There is a possibility that memberCount and initialCount can be different and becauee of gas effeciently we want only update the glob var if necessary.
            Because if both var's are still the same we don't want to apply to totalMembers because it would be a waste of gas
        */
        uint256 initialCount = memberCount;

        // Someone left
        // - When a user sends their entire balance AND
        // - When sender is NOT a contract OR sender is NOT the 0 address
        if(
            balanceOf(from) == amount &&
            /*
                BOOL LOGIC - DeMorgan's Law:

                !(P | | Q) == (!P 88 !Q)
                P = isContract (from) - Q = from == address (0)

                BOTH EXPRESSIONS ARE EXACT THE SAME
                !(isContract(from) || from == address(0))
                !isContract(from) && !from != address(0))
            */
            !(isContract(from) || from == address(0))
        ) memberCount--;

        // Someone joined
        // - When a user with a zero balance receives tokens AND
        // - When sender is NOT a contract
        if(
            balanceOf(to) == 0 &&
            !(isContract(to) || to == address(0))
        ) memberCount++;

        // Nobody left or joined
        // Checks wether the amount of members changed if not we don't update 
        if(memberCount == initialCount) return;

        // Updates the glob var totalMembers - 5000 gas
        totalMembers = memberCount;

    }

    // Voting Power: Several models to choose from
    function memberVotingPower(address account) public view returns(uint256 votingPower) {
        
        /*
            MODEL 1 - simplest
            
            Returns the number of votes an account can cast - - Uses one-vote-per-token
            In this model: 1 wei = 1 vote

            vontingPower = balanceOf(account);
        */

        /* 
            MODEL 2 - a bit better but still the same as MODEL 1
            
            One-vote-per-person: Member gets one vote if they have at least X token 
        
            EXEMPLE: if(balanceOf(account) >= minimumTokenBalance) votingPower = 1;
           
            uint minimumTokenBalance; // 100 token = 1 votingPower
            votingPower = balanceOf(account) / minimumTokenBalance;
        */

        /*
            MODEL 3

            One-vote-per-X-tokens: Member's token balance divided by some factor is their voting power
            This is basically the exact same thing as one-vote-per-token, mathematically speaking

            uint256 voteReductionFactor;
            votingPower = balanceOf(account) / voteReductionFactor;
        */

        /*
            MODEL 4 - QUADRATIC VOTING

            Quadratic voting requires using a square root function, which doesn't exist natively in Solidity.
            Babylonian method - - Uniswap version
        */

        // Calls the sqr()
        /*
            IMPORTANT FOR ERC20

            It's necessary to devid the decimals to calculate with only whole ETH - / 10 ** decimals()
        */
        votingPower = sqrt(balanceOf(account) / 10 ** decimals()); // sqrt(1e18) = 1e9 sqrt(1) = 1
    }

    // Calculating the sqrt for memberVotingPower()
    function sqrt(uint y) internal pure returns(uint z) {
        
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            } 
        } else if (y != 0) {
            z = 1;
        }
    }

    /*
        INPUTS FOR TESTING

        AMOUNTS: [1, 25, 100, 2500, 3000]
        MEMBERS: ["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4", "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db", "0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB", "0x617F2E2fD72FD9D5503197092aC168c91465E7f2"]
    */
    constructor(uint256[] memory amounts, address[] memory members) {
        super; // 
        // Loops through the amounts and members
        for(uint i = 0; i < members.length; i++) {
            // Calls the _mint() and decimals() from the OpenZeppelin ERC20 contract and multiply it
            _mint(members[i], amounts[i] * 10 ** decimals());
        }
    }

}