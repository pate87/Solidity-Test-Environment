// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract read {

    bool public subscribed = true;
    uint public age = 32;
    string public name = "Patrick";

    function doubleAge() public view returns(uint) {
        return age * 2;
    }

    function addExclamation() public view returns(string memory) {
        return string.concat(name, "!");
    }

    function setSubscribtion() public {
        subscribed = !subscribed;
    }

    function setAge(uint newAge) public {
        age = newAge;
    }

    function setName(string memory newName) public {
        name = newName;
    }



}