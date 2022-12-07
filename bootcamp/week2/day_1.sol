// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

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