// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Governance {
    // - ProposalState enum - tracking different states a proposal may have:
    enum ProposalState{
        // - Unassigned (default state)
        Unassigned, // 0
        // - Pending (set when proposal is submitted)
        Pending, // 1
        // - Active (set when first vote is cast)
        Active, // 2
        // - Queued (set when proposal is ready for execution)
        Queued, // 3
        // - Defeated (set when enough votes are cast against)
        Defeated, // 4
        // - Succeeded (set when enough votes are cast for)
        Succeeded, // 5
        // - Expired (set if proposal is still active when execute() is called)
        Expired // 6
    }
    
    // - ProposalType enum tracking which function should be called by execute()
    enum ProposalType{
        // - IssueGrant
        IssueGrant,
        // - ModifyGrantSize
        ModifyGrantSize
    }
    
    // - ProposalData struct for general proposal data that contains:
    struct ProposalData {
        // - A timestamp when voting begins
        uint voteBegins;
        // - A timestamp when voting ends
        uint voteEnds;
        // - A counter for voties
        uint256 votesFor;
        // - A counter against votes
        uint256 votesAgainst;
        // - A ProposalStatus enum marking the statee of the proposal
        ProposalState propState;
        // - A ProposalType enum so execute() knows which function to call
        ProposalType propType;
        // - The grant recepient's address
        address recepient;
        // - The ETH allocated to the grant
        uint256 ethGrant;
        // - The new ETH amount to be allocated to each grant proposal
        uint256 newETHGrant;
    }

    // - ProposalData array (Each index of the array doubles as a proposal ID) - Creates an array from the struct object and set it into an array index ID
    ProposalData[] private proposals;

    // - Minimum number of votes required to pass a proposal (assign 5)
    uint256 private quorum = 5;

    // - Double mapping of address to uint256 to bool to track if an address has already voted for a proposal
    // Member address => Proposal ID => True if member has voted
    mapping(address => mapping(uint256 => bool)) public memberHasVoted;

    // - Timelock duration for proposal review period (assign to 30 seconds for testing proposes)
    uint256 reviewPeriod = 30 seconds;
    // - Timelock duration for proposal voting period (assign to 1 minutes for testing proposes)
    uint256 votingPeriod = 1 minutes;

    // - Size of each ETH grant (assign 1 ETH)
    uint256 grantAmount = 1 ether;

    // - Balance of ETH available for a new proposal
    uint256 public availableETH;

    constructor() payable {
        availableETH = msg.value;
    }

    // Implement the OpenZeppelin Governor contract state()
    function state(uint256 propID) public view returns(ProposalState) {
        
        // Using storage saves gas against memory 
        ProposalData storage proposal = proposals[propID];

        // Creating a temp local var propState from the global var ProposalState
        ProposalState propState = proposal.propState;

        // Unassigned are any Proposals that have not been executed yet
        // Checks in which state the proposal is currently if it's NOT Unassigned as default
        if (propState != ProposalState.Unassigned) {
            // Show the current state of the ProposalState
            return propState;
        }

        // This contract havn't a Canceled state yet
        // if (proposal.canceled) {
        //     return ProposalState.Canceled;
        // }

        uint256 voteBegins = proposal.voteBegins;

        // Proposals that don't exist will have a 0 voting begin date
        if (voteBegins == 0) {
            revert("Invalid ID");
        }

        // If the voting begin date is in the future, then voting has not begun yet
        // The actually contract is using block.number which is propperly more acurate however because of thesting porposes this contract uses block.timestamp
        // The block.timestamp can be controled from other users - this is only for testing
        if (voteBegins >= block.timestamp) {
            return ProposalState.Pending;
        }

        uint256 voteEnds = proposal.voteEnds;

        // If the voting end date is in the future, then voting is still active
        // The actually contract is using block.number which is propperly more acurate however because of thesting porposes this contract uses block.timestamp
        // The block.timestamp can be controled from other users - this is only for testing
        if (voteEnds >= block.timestamp) {
            return ProposalState.Active;
        }

        // If none of the above is true, then voting is over and this Proposal is queued for execution
        return ProposalState.Queued;
    }

    
}