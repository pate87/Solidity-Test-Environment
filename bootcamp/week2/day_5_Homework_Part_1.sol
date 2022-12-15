// SPDX-License-Identifier: MIT

// Sign my contract by using the "signMe" function. 

// Here is the address on Polygon POS: 0x3cdbff65dac67cdb6e5c4f05c4db8fe05c20e4d8

// You have to give it who is signing as the first argument (an address).

// You have to give it the signature (the message) as the second argument (a string).

// It returns a string. 

// Hint: Since you don't have the code, use an interface

pragma solidity ^0.8.13;

interface Itoken {
    function signMe(address signer, string memory signature) external returns(string memory);
}

contract signContract {

    function sign() public {
        Itoken signToken = Itoken(0x3CdBff65DaC67cDb6E5c4F05c4DB8FE05C20e4D8);
        signToken.signMe(msg.sender, "Hello thanks for this course");
    }
}