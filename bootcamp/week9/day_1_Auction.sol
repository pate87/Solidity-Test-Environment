// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract auction {

    address payable public seller;
    uint public timeToEnd;
    bool public running;
    address public highestBidder;
    uint public highestBid;

    constructor() {
        seller = payable(msg.sender);
    }

    function startAuction() public {
        require(!running);
        require(msg.sender == seller, "You're not the owner");
        running = true;
        timeToEnd = block.timestamp + 1 minutes; // Set 1 minutes to testing
    }

    function bid() payable public {
        require(running);
        require(msg.value > highestBid, "You're not the highest bidder");

        // check wether (person a bids 1 ETH) < (Person b bids 2 ETH) and person b bedomes the new highestBidder
        // If (current highestBidder) < (new highestBidder ) prviewes highestBidder gets his bid (tockens) back 
        payable(highestBidder).transfer(highestBid);
        // Smart contracts, by default, cannot accept ether 
        highestBidder = msg.sender;
        highestBid = msg.value;
    }

    function win() public {
        require(running);
        require(block.timestamp >= timeToEnd);

        running = false;
        seller.transfer(highestBid);
    }
}