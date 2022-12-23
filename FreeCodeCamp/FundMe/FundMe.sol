// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.7;

/*
// Get funds from user
// withdraw funds
// set minimum funding value
*/

contract FundMe {

    // Get funds from user
    // To make a function payable, marking the function as payable is necessary 
    function fund() public payable {
        // Want to be able to set a minimum fund amount
        // 1. How to send tokens to this contract? 
        require(msg.value > 1e18, "Didn't send enough!");
        // What is reverting? - Undo any action before, and send remaining gas back

    }

}


// 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
// 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db