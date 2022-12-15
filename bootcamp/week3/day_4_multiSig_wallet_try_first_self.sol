// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract multiSigWallet {

    address public owner;

    // number of of approval required
    uint public approval;

    constructor(uint number) {
        approval = number;
        owner = msg.sender;
    } 

    // list of owners
    struct People {
        address _address;
        bool vote;
    }

    People[] public people;

    function addPerson(address _address) public {
        require(msg.sender == owner, "You're not the owner");
        require(people.length < approval, "Too many addresses");
        // for(uint i  = 0; i < people.length; i++) {
            people.push(People(_address, true));
        // }
        // require(people <= approval);
        // people.push(People(_address, true));
    }


    function getPerson(uint id) public view returns(address, bool) {
        return (people[id]._address, people[id].vote);
    }
 
/****
// list of owners
// number of of approval required
// ability receive funds
// ability propose a transaction 
// vote on that proposal
// retract a vote
// execute transaction
*/

}

// ["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4", "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db", "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2"]