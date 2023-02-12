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