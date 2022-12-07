// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract homeWorkWeek1 {

    // Exercise 1
    function addTwoNumbers() public pure returns(uint8) {
        return 60 + 40;
    }

    // Exercise 2
    function myName() public pure returns(string memory) {
        return "Patrick";
    }

    // Exercise 3
    function isCockie(string memory _language) public pure returns (string memory) {
        if(keccak256(abi.encodePacked('cockie')) == keccak256(abi.encodePacked(_language))) {
            return"yum";
        } else {
            return "yuck";
        }
    }

    // Exercise 4
    function addToTen(uint8 a, uint8 b) public pure returns(string memory) {
        uint8 number = a + b;
        if(number == 10) {
            return "Party";
        }
        return '';
    }

    // Exercise 5
    function doubleNumber (uint8 loops) public pure returns (uint) {
        uint total = 1;

        for(uint i = 0; i < loops; i++) {
            total = total * 2;
        }
        return total;
    }
}