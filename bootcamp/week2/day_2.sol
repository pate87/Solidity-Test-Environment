// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract dayOne {
    
    // Exercise 1
    function getInfo() public view returns (address, uint) {
        return (msg.sender, block.number);
    }

    // Exercise 2
    bool public test = false;
    uint private value = 100;

    modifier onlyOwner () {
        require (test == true, "You're not the owner!");
        _;
    }

    function isOwner () public returns (bool) {
        return test = true;
    }

    function getValue () public view onlyOwner returns (uint) {
        return value;
    }
}

// Exercise 3
contract testConstructorF {

    string private _creator;
    
    constructor (string memory name) {
        _creator = name;
    }

    function getCreator() public view returns (string memory) {
       return _creator;
    }
}