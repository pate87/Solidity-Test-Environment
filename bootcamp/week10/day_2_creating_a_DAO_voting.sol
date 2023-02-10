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
        
        // Sets up a local var - proposal from global var ProposalData
        // Using storage saves gas against memory 
        // storage links directly to the global var whereas memory creates a temp copy of the global var
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

    // Function to check whether the quorum is reached
    function _quorumReached(uint256 votesFor, uint256 voteAgainst) private view returns(bool quorumReached) {
        // quorumReached is taking the sum from votesFor + votesAgainst and compare it with the actual (global number var) quroum - which must be > 5
        quorumReached = (votesFor + voteAgainst >= quorum);
    }

    // Function to check whether the ProposalState was Succeeded or Defeated
    function _votesSucceeded(uint256 votesFor, uint256 voteAgainst) private pure returns(bool voteSucceeded) {
        voteSucceeded = votesFor > voteAgainst; // 50% + 1 majority
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
        ProposalData storage proposal = proposals[propID];

        // Sets up a local var - for later caunting usage with the help of the linked temp var - proposal
        uint256 votesFor = proposal.votesFor;
        uint256 voteAgainst = proposal.votesAgainst;

        // Sets up a local var from the global _quorumReached() which checks whether the votes are raeached the minimum quotes needed
        bool quorumReached = _quorumReached(votesFor, voteAgainst);

        // Checks whether quorum was NOT reached during the time of voting
        if(!quorumReached) {
            // If the time is over but no votes has been send to the proposal, then the proposal is Expired
            return ProposalState.Expired;
        }
        // Checks with the global votesSucceeded() whether the proposal was succesfull
        else if (_votesSucceeded(votesFor, voteAgainst)) {
            return ProposalState.Succeeded;
        } 
        // If a proposale wasn't succesfull, then the proposal is Defeated
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
        uint256 newGrantAmount
    ) private {
        uint256 votingBeginDate = block.timestamp + reviewPeriod;
        // Copy all the struct variables and set it into a new copy with the arguments
        // This time we need a memory because the other var doesn't exist yet
        ProposalData memory newProposal = ProposalData ({
            voteBegins: votingBeginDate,
            voteEnds: votingBeginDate + votingPeriod,
            votesFor: 0,
            votesAgainst: 0,
            propState: ProposalState.Unassigned,
            propType: propType, // ProposalType.IssueGrant
            recepient: recipient,
            ethGrant: amount,
            newETHGrant: newGrantAmount
        });

        // Push the newPropsal to the array @proposals and give each proposal an ID to call it in the array
        proposals.push(newProposal);
    }

    // Submits a new grant request
    function submitNewGrant(address recipient) public {

        // To save gas fees we create a temp local var from our global var
        uint256 _grantAmount = grantAmount;
        
        // Check whether glob var @availableETH >= _grantAmount
        require(availableETH >= _grantAmount, "Insuficient ETH");

        // Calculates the new @availableETH 
        availableETH -= _grantAmount;

        // - Calls the @_submitProposal():
        // - the new grantAmount becomes 0 because we calculate it in the @submitNewAmountChange()
        _submitProposal(ProposalType.IssueGrant, recipient, _grantAmount, 0);
    }

    // Submiths a new grant amount change request
    function submitNewAmountChange(uint256 newGrantAmount) public {
        require(newGrantAmount > 0, "Invalid amount");

        // - Calls the @_submitProposal(): and call it with 0 input argument besides of the the @newGrantAmount
        // The other arguments are changed in the @submitNewGrant()
        _submitProposal(ProposalType.IssueGrant, address(0), 0, newGrantAmount);
    }

    //** VOTE **//

    // Modifier to check whether the proposal is active and whether the member hasn't voted yet
    modifier voteChecks(uint256 propID) {
        // Check the @ProposalState
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
        ProposalData storage proposal = proposals[propID];

        // Conditional statement to check whether the vote was For or Against the proposal  
        if(votedFor) {
            proposal.votesFor++;
        } else {
            proposal.votesAgainst++;
        }

        // Sets the mepping @memberHasVoted to true
        memberHasVoted[msg.sender][propID] == true;
    }

    // Sets voteFor propID
    function voteFor(uint256 propID) public voteChecks(propID) {
        _submitVote(propID, true);
    }
    
    // Sets votesAgainst propID
    function votesAgainst(uint256 propID) public voteChecks(propID) {
        _submitVote(propID, false);
    }
    
    
    
}