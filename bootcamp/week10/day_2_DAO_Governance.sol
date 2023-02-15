// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./day_3_DAO_Membership_ERC20.sol";

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
    

    // The proposals array is an array of ProposalData objects, and each index in the array doubles as a proposal ID.
    ProposalData[] private proposals;

    // - Minimum number of votes required to pass a proposal - for testing assign 5
    // uint256 private quorum = 5;

    // - Double mapping of address to uint256 to bool to track if an address has already voted for a proposal
    // Member address => Proposal ID => True if member has voted
    mapping(address => mapping(uint256 => bool)) public memberHasVoted;

    // Create instance of MembershipERC20 we can interact with
    MembershipERC20 private iMembership;

    // - Timelock duration for proposal review period (assign to 1 minutes for testing proposes)
    uint256 reviewPeriod = 1 minutes;
    // - Timelock duration for proposal voting period (assign to 1 minutes for testing proposes)
    uint256 votingPeriod = 1 minutes;

    // - Size of each ETH grant (assign 1 ETH for Testing)
    uint256 public grantAmount;

    // - Balance of ETH available for a new proposal
    uint256 public availableETH;

    // 1000000000006000000
    // Add inputs for reviewPeriod, votingPeriod, and grantAmount, and Membership contract address
    constructor(address _iMembership, uint256 _reviewperiod, uint256 _votingPeriod, uint256 _grantAmount) payable {
        availableETH = msg.value;
        grantAmount = 5000;

        reviewPeriod = _reviewperiod;
        votingPeriod = _votingPeriod;
        grantAmount = _grantAmount * 1e18; 

        iMembership = MembershipERC20(_iMembership);
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
        // Add property for number of members who voted
        uint256 memberVoteCount;
        // - A ProposalStatus enum marking the statee of the proposal
        // Creates temp struct var propState from the actual ProposalState
        ProposalState propState;
        // - A ProposalType enum so execute() knows which function to call
        // Creates temp struct var propType from the actual ProposalType
        ProposalType propType;
        // - The grant recipient's address
        address recipient;
        // - The ETH allocated to the grant
        uint256 ethGrant;
        // - The new ETH amount to be allocated to each grant proposal
        uint256 newETHGrant;
        string description;
    }
    // Implement the OpenZeppelin Governor contract state()
    /*  The state function returns the current state of a proposal based on the propID passed as a parameter. 
        The function uses the ProposalData object stored in the proposals array with the same propID to determine the state.
    */
    function state(uint256 propID) public view returns(ProposalState) {
        
        // Sets up a local var - proposal from global var ProposalData
        // Using storage saves gas against memory 
        // storage links directly to the global var whereas memory creates a temp copy of the global var
        // Also we copy everything from the @proposals array with the attached ID and enter it in the new local var proposal
        ProposalData storage proposal = proposals[propID];
        // proposal is now an object which has all the information from the @ProposalData and the @proposal array ID

        // Create a new var poropState and asign the proposal object and the @ProposalState to it
        ProposalState propState = proposal.propState;

        // Checks in which state the proposal is currently if it's NOT Unassigned as it is by default
        if (propState != ProposalState.Unassigned) {
            // Return the current state of the ProposalState and set it to the propState 
            return propState;
        }

        // The code doesn't have a canceled field or any logic for canceling the propose yet
        // if (proposal.canceled) {
        //     return ProposalState.Canceled;
        // }

        uint256 voteBegins = proposal.voteBegins;

        // Proposals that don't exist will have a 0 voting begin date
        if (voteBegins == 0) {
            
            revert("Invalid ID");

        }

        /*
            Updated code instead using if we use require 
        */
        // require(voteBegins < 0, "Invalid ID");

        // If the voting begin date is in the future, then voting has not begun yet
        // The actually contract is using block.number which is properly more acurate however because of thesting purposes this contract uses block.timestamp
        // block.timestamp may not be accurate because it can be manipulated by miners.
        if (voteBegins >= block.timestamp) {
            // Sets the ProposalState to Pending
            return ProposalState.Pending;
        }

        /*
            Updated code instead using if we use require 
        */
        // require(voteBegins < block.timestamp || voteBegins == 0, "Voting has not begun yet");
        // // Sets the ProposalState to Pending
        // ProposalState.Pending;

        uint256 voteEnds = proposal.voteEnds;

        // If the voting end date is in the future, then voting is still active
        // The actually contract is using block.number which is properly more acurate however because of thesting purposes this contract uses block.timestamp
        // block.timestamp may not be accurate because it can be manipulated by miners.
        if (voteEnds >= block.timestamp) {
            // Sets the ProposalState to Active
            return ProposalState.Active;
        }

        /*
            Updated code instead using if we use require 
        */
        // require(voteEnds < block.timestamp || voteEnds == 0, "Voting is still active");
        // // Sets the ProposalState to Active
        // ProposalState.Active;

        // If none of the above is true, then voting is over and this Proposal is queued for execution
        // Sets the ProposalState to Queued and calls the @execute()
        return ProposalState.Queued;
    }

    // Function to check whether the quorum is reached
    // Instead of counting votes submitted, count number of DAO members who voted
    function _quorumReached(uint256 propID) private view returns(bool quorumReached) {

        // Sets up a local var - proposal from global var ProposalData
        // Using storage saves gas against memory 
        // storage links directly to the global var whereas memory creates a temp copy of the global var
        // Also we copy everything from the @proposals array with the attached ID and enter it in the new local var proposal
        ProposalData storage proposal = proposals[propID];

        // quorumReached is taking the sum from votesFor + votesAgainst and compare it with the actual quroum - for testing @quorum > 5
        // For testing purposes - quorumReached = (votesFor + votesAgainst ›= quorum);
        // Use getQuorum() instead of quorum
        // Instead of counting votes submitted, count number of Dao members who voted - memberVoteCount
        quorumReached = (proposal.memberVoteCount >= getQuorum());
    }

    // Create onlyMembers modifier to check if caller is a DAO member
    modifier onlyMembers() {
        /*
            Alternatively: 
            You can use memberVotingPower to check for membership status
        */
        require(iMembership.balanceOf(msg.sender) > 0, "Caller not a DAO member");
        _;
    }

    // Function to check whether the ProposalState was Succeeded or Defeated
    function _votesSucceeded(uint256 votesFor, uint256 votesAgainst) private pure returns(bool voteSucceeded) {
        voteSucceeded = votesFor > votesAgainst; // 50% + 1 majority
        /**
            ALTERNATIVE SYSTEMS
            2/3 Supermajority:
            voteSucceeded = votesFor >= votesAgainst * 2;

            3/5 Majority
            voteSucceeded = votesFor * 2 >= votesAgainst * 3;

            X/Y Majority
            voteSucceeded = votesFor * (X - Y) >= votesAgainst * X;
        */

    }

    // Counting the votes 
    function _tallyVotes(uint256 propID) private view returns(ProposalState) {

        // Sets up a local var - proposal from global var ProposalData
        // Using storage saves gas against memory 
        // storage links directly to the global var whereas memory creates a temp copy of the global var
        // Also we copy everything from the @proposals array with the attached ID and enter it in the new local var proposal
        ProposalData storage proposal = proposals[propID];

        // Sets up a local var - for later caunting usage with the help of the linked temp var - proposal
        uint256 votesFor = proposal.votesFor;
        uint256 votesAgainst = proposal.votesAgainst;

        // Sets up a local var from _quorumReached() which checks whether the votes are raeached the minimum quotes needed
        // For testing purposes -  bool quorumReached = _quorumReached(votesFor, votesAgainst);
        bool quorumReached = _quorumReached(propID);

        // Checks whether quorum was NOT reached during the time of voting
        if(!quorumReached) {
            // If the time is over but no votes has been send to the proposal, then the proposal is Expired - return Expired
            return ProposalState.Expired;
        }
        // Checks with the global votesSucceeded() whether the proposal was succesfull - return Succeeded
        else if (_votesSucceeded(votesFor, votesAgainst)) {
            return ProposalState.Succeeded;
        } 
        // If a proposale wasn't succesfull, then the proposal is Defeated - return Defeated
        else {
            return ProposalState.Defeated;
        }
    }

    //*** PROPOSE ***//

    // Internal function to send the information to the @proposals array, so we can later call the ID with the atached information from this function
    function _submitProposal(
        ProposalType propType,
        address recipient,
        uint256 amount,
        uint256 newGrantAmount,
        string memory description
    ) private {
        uint256 votingBeginDate = block.timestamp + reviewPeriod;
        // Copy all the struct variables and set it into a new copy with the arguments
        // This time we need a memory because the other var doesn't exist yet
        ProposalData memory newProposal = ProposalData ({
            voteBegins: votingBeginDate,
            voteEnds: votingBeginDate + votingPeriod,
            votesFor: 0,
            votesAgainst: 0,
            memberVoteCount: 0,
            propState: ProposalState.Unassigned,
            propType: propType, // ProposalType.IssueGrant
            recipient: recipient,
            ethGrant: amount,
            newETHGrant: newGrantAmount,
            description: description
        });

        // Push the newPropsal to the array @proposals and give each proposal an ID to call it in the array
        proposals.push(newProposal);
    }

    // Submits a new grant request
    function submitNewGrant(address recipient, string memory description) public onlyMembers {

        // To save gas fees we create a temp local var from our global var
        uint256 _grantAmount = grantAmount;
        
        // Check whether glob var @availableETH >= _grantAmount
        require(availableETH >= _grantAmount, "Insufficient ETH");

        // Calculates the new @availableETH 
        availableETH -= _grantAmount;

        // - Calls the @_submitProposal():
        // - the new grantAmount becomes 0 because we calculate it in the @changeAmountOfProposal()
        _submitProposal(ProposalType.IssueGrant, recipient, _grantAmount, 0, description);
    }

    // Submiths a new grant amount change request
    function changeAmountOfProposal(uint256 newGrantAmount, string memory description) public onlyMembers {
        require(newGrantAmount > 0, "Invalid amount");
     
        // - Calls the @_submitProposal(): and call it with 0 input argument besides of the the @newGrantAmount
        // The other arguments are changed in the @submitNewGrant()
        _submitProposal(ProposalType.ModifyGrantSize, address(0), 0, newGrantAmount, description);
     
    }

    //** VOTE **//

    // Modifier to check whether the proposal is active and whether the member hasn't voted yet
    modifier voteChecks(uint256 propID) {
        // Check the current @ProposalState
        require(state(propID) == ProposalState.Active, "Proposal Inactive");
        // Calls the global mapping @memberHasVoted
        require(memberHasVoted[msg.sender][propID] == false, "Member already voted");
        _;
    }

    // Submits a vote For or Against to Proposal propID
    function _submitVote(uint256 propID, bool votedFor) private {
        
        // Sets up a local var - proposal from global var ProposalData
        // Using storage saves gas against memory 
        // storage links directly to the global var whereas memory creates a temp copy of the global var
        // Also we copy everything from the @proposals array with the attached ID and enter it in the new local var proposal
        ProposalData storage proposal = proposals[propID];

        // Call Membership.votingPower to determine number of votes to apply to Proposal
        // Calls the memberVotingPower() from the iMembership and store it in a local var
        uint256 votingPower = iMembership.memberVotingPower(msg.sender);

        // Conditional statement to check whether the vote was For or Against the proposal  
        if(votedFor) {
            
            // Only for testing purposes - proposal.votesFor++;
            proposal.votesFor += votingPower;
        } else {
            // Only for testing purposes - proposal.votesAgainst++;
            proposal.votesAgainst += votingPower;
        }

        // Sets the mepping @memberHasVoted to true
        memberHasVoted[msg.sender][propID] = true;

        // Increase the number of @memberVoteCount at ProposalData struct
        proposal.memberVoteCount++;
    }

    // Sets voteFor propID
    function voteFor(uint256 propID) public onlyMembers voteChecks(propID) {
        _submitVote(propID, true);
    }
    
    // Sets voteAgainst propID
    function voteAgainst(uint256 propID) public onlyMembers voteChecks(propID) {
        _submitVote(propID, false);
    }
    
    //*** EXECUTE ***//

    // @notice Executes a Proposal when it is in the Queued state
    // The execute() is only doable if the voting has stopped
    function execute(uint256 propID) public onlyMembers {

        // Sets up a local var - proposal from global var ProposalData
        // Using storage saves gas against memory 
        // storage links directly to the global var whereas memory creates a temp copy of the global var
        // Also we copy everything from the @proposals array with the attached ID and enter it in the new local var proposal
        ProposalData storage proposal = proposals[propID];

        // Sets up a local var - propState from global var ProposalState
        ProposalState propState = state(propID);

        // Checks whether the proposal state is ready to execute
        // The execut() should only be callable if the proposal @ProposalState is Queued to check this we use the require statement
        require(propState == ProposalState.Queued, "Proposal not queued for execution");

        // Call @_tallyVotes() to check what the actual state of @ProposalState is and set it to a local var
        propState = _tallyVotes(propID);

        // Extracting the propType variable from proposal object and assigning it to a local variable propType
        ProposalType propType = proposal.propType;


        if(propState == ProposalState.Succeeded) {
            if(propType == ProposalType.IssueGrant) {
                // ISSUE GRANT
                _issueGrant(propID);
            } else if(propType == ProposalType.ModifyGrantSize) {
                // MODIFY GRANT SIZE
                _modifyGrantSize(propID);
            } 
        } else {
            // If the proposal not Succeeded 
            if(propType == ProposalType.IssueGrant) {
                // We send our ETH back into the tresury so the tresury is not going down - defent Reentrancy Attack
                availableETH += proposal.ethGrant;
            }
        }
            
        // SET PROPOSAL STATE
        _setState(propID);

    }

    function _issueGrant(uint256 propID) private {

        // Sets up a local var - proposal from global var ProposalData
        // Using storage saves gas against memory 
        // storage links directly to the global var whereas memory creates a temp copy of the global var
        // Also we copy everything from the @proposals array with the attached ID and enter it in the new local var proposal
        ProposalData storage proposal = proposals[propID]; 

        // Sends the amount from proposal.ethGrant to recepient
        // Because the function is private we don't need to check for Reentrancy Attack
        (bool success, ) = proposal.recipient.call{value: proposal.ethGrant}("");

        // If the transfer failed recicle the ethGrant and add it to availableETH
        if(!success) {
            availableETH += proposal.ethGrant;
        }
    }

    function _modifyGrantSize(uint256 propID) private {

        // Sets up a local var - proposal from global var ProposalData
        // Using storage saves gas against memory
        /* 
            This is the same as wrinting 
            grantAmount = proposal[propID].newETHGrant 
        */ 
        // storage links directly to the global var whereas memory creates a temp copy of the global var
        // Also we copy everything from the @proposals array with the attached ID and enter it in the new local var proposal
        ProposalData storage proposal = proposals[propID]; 
        
        // Updates the grantAmount from the newETHGrant
        grantAmount = proposal.newETHGrant; 

    }

    // Internal function
    function _setState(uint propID) private {
            
        // Sets up a local var - proposal from global var ProposalData
        // Using storage saves gas against memory 
        // storage links directly to the global var whereas memory creates a temp copy of the global var
        // Also we copy everything from the @proposals array with the attached ID and enter it in the new local var proposal
        ProposalData storage proposal = proposals[propID]; 
        
        // Create a local var and link it to the ProposalData struct votesFor votesAgainst
        uint256 votesFor = proposal.votesFor;
        uint256 votesAgainst = proposal.votesAgainst;
        
        //*** This code is equal to the @_tallyVotes() expect we asign the proposal state and not returning them  ***//

        // Sets up a local var from _quorumReached() which checks whether the votes are raeached the minimum quotes needed
        // only for Testing - bool quorumReached = _quorumReached(votesFor, votesAgainst);
        bool quorumReached = _quorumReached(propID);
        
        // Checks whether quorum was NOT reached during the time of voting
        if(!quorumReached) {
            // If the time is over but no votes has been send to the proposal, then the proposal is Expired - asign Expired
            proposal.propState = ProposalState.Expired;
        }
        // Checks with the global votesSucceeded() whether the proposal was succesfull - asign Succeeded
        else if (_votesSucceeded(votesFor, votesAgainst)) {
            proposal.propState = ProposalState.Succeeded;
        } 
        // If a proposale wasn't succesfull, then the proposal is Defeated - asign Defeated
        else {
            proposal.propState = ProposalState.Defeated;
        }

    }

    //*** GETTER FUNCTIONS ****//

    // Get the length length of the array @proposals - instead of creating a state var which cost gas we use this function
    function getTotalProposals() public view returns(uint256 totalProposals) {
        totalProposals = proposals.length;
    }

    /*
        The getProposal function returns the information about a proposal
        based on the propID passed as a parameter. 
        The function creates a new local ProposalData object with the information from the proposals array
        and sets the state of the proposal based on the result of calling the state function.
    */
    function getProposal(uint256 propID) public view returns(ProposalData memory proposal) {
        
        // Creates a new local ProposalData object with the information from the proposals array
        proposal = proposals[propID];

        // @propState is the var from @ProposalData struct
        // calling the state function
        proposal.propState = state(propID);

        // Show the @ProposalState ID number which gets returned from the state()
        return proposal;

    }

    //*** TEST FUNCTIONS ***//

    function getTimestamp() public view returns(uint256 timestamp) {
        return block.timestamp;
    }

    function getReviewTimeRemaining(uint256 propID) public view returns(uint256 timeRemaining) {

        // Sets up a local var - proposal from global var ProposalData
        // Using storage saves gas against memory 
        // storage links directly to the global var whereas memory creates a temp copy of the global var
        // Also we copy everything from the @proposals array with the attached ID and enter it in the new local var proposal
        ProposalData storage proposal = proposals[propID]; 

        if(state(propID) == ProposalState.Pending) {
            // Calculates the remaining time 
            return proposal.voteBegins - getTimestamp();
        } else {
            return 0;
        }
    }

    function getVoteTimeRemaining(uint256 propID) public view returns(uint256 timeRemaining) {

        // Sets up a local var - proposal from global var ProposalData
        // Using storage saves gas against memory 
        // storage links directly to the global var whereas memory creates a temp copy of the global var
        // Also we copy everything from the @proposals array with the attached ID and enter it in the new local var proposal
        ProposalData storage proposal = proposals[propID]; 

        if(state(propID) == ProposalState.Active) {
            // Calculates the remaining time 
            return proposal.voteEnds - getTimestamp();
        } else {
            return 0;
        }
    }

    function getQuorum() public view returns(uint256) {
        // Only for testing - return quorum;

        // Call Membership contract to get total DAO members, and apply formula to determine quorum
        // Calls the totalMembers() from iMembership and calcualte 50% for necessary votes
        return (iMembership.totalMembers() * 50) / 100;
    }

    receive() external payable {
        availableETH += msg.value;
    }

}