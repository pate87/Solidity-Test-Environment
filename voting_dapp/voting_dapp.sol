// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract voting_dapp {

    address private owner;

    string public purpose;

    struct Voter {
        bool authorized;
        bool voted;
    }

    uint totalVotes;
    uint teamA;
    uint teamB;
    uint teamC;

    mapping(address => Voter) info;

    constructor(string memory _name) {
        purpose = _name;
        owner = msg.sender;
    }

    modifier ownerOn() {
        require(msg.sender == owner);
        _;
    }

    function authorize(address _person) ownerOn public {
        info[_person].authorized = true;
    } 

    function teamAF(address _address) public returns(string memory) {
        require(!info[_address].voted, "Aleady voted");
        require(info[_address].authorized, "You have no right for vote");
        info[_address].voted = true;
        teamA++;
        totalVotes++;
        return "Thanks for voting";
    }

    function teamBF(address _address) public returns(string memory) {
        require(!info[_address].voted, "Aleady voted");
        require(info[_address].authorized, "You have no right for vote");
        info[_address].voted = true;
        teamB++;
        totalVotes++;
        return "Thanks for voting";
    }

    function teamCF(address _address) public returns(string memory) {
        require(!info[_address].voted, "Aleady voted");
        require(info[_address].authorized, "You have no right for vote");
        info[_address].voted = true;
        teamC++;
        totalVotes++;
        return "Thanks for voting";
    }

    function totalVotesF() public view returns(uint) {
        return totalVotes;
    }

    function resultOfVoting() public view returns(string memory) {
        if(teamA > teamB && teamA > teamC) {
            return "Team A won!";
        }
        else if(teamB > teamA && teamB > teamC) {
            return "Team B won!";
        }
        else if(teamC > teamA && teamC > teamB) {
            return "Team C won!";
        }
        else if (teamA == teamC && teamC == teamB && teamB == teamA) {
            return "No one won! DRAW!";
        }
        return "";
    }
}