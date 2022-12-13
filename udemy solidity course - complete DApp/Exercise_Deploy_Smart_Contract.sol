// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract simpleStorage {

    uint public value;

    function setValue(uint amount) public {
        value = amount;
    }

    function getValue() public view returns(uint) {
        return value * 5;
    }
}

contract names {

    string public name;

    function setName(string memory _name) public {
        name = _name;
    }

    function getName() public view returns(string memory) {
        return name;
    }
}