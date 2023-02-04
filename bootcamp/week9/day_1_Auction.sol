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
        // Check whether the auction is running or not 
        require(!running);
        // Check whether the caller the function startAuction is the owner of the contract auction 
        require(msg.sender == seller, "You're not the owner");
        // Starts the auction 
        running = true;
        // Sets a timer till the auction ends 
        timeToEnd = block.timestamp + 1 minutes; // Set 1 minutes to testing
    }

    function bid() payable public {
        // Check whether the auction is running or not 
        require(running);
        // Check wether the new bid is higher than the old highestBid 
        require(msg.value > highestBid, "You're not the highest bidder");

        // After checking wether (current highestBidder) < (new highestBidder ) prviewes highestBidder
        // payable(highestBidder).transfer(highestBid) - sends the tokens back to the prviewes highestBidder - This opens the door for the Denial of Service (DoS) Attack
        // Denial of Service (DoS) Attacks - are quite common to not get your tokens out of the contract or service which provided the contract
        payable(highestBidder).transfer(highestBid);
        // Smart contracts, by default, cannot accept ether 

        // Adds the new address to the highestBidder
        highestBidder = msg.sender;
        // Adds the new amount to the highestBid
        highestBid = msg.value;
    }

    function win() public {
        // Check whether the auction is running or not 
        require(running);
        // Check whether the timer till the auction ends is not 0 and the auction is still running
        require(block.timestamp >= timeToEnd);

        // Ends the auction 
        running = false;

        // transfer the amount from the highestBidder to seller 
        seller.transfer(highestBid);
    }
}