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
        uint vote_begins;
        // - A timestamp when voting ends
        uint vote_ends;
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
        uint256 allocated_amount;
    }

    // - ProposalData array (Each index of the array doubles as a proposal ID) - Creates an array from the struct object and set it into an array index ID
    ProposalData[] private proposal;

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
    
}