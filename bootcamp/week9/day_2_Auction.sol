// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract auction {

    address payable public seller;
    uint public timeToEnd;
    bool public running;
    address public highestBidder;
    uint public highestBid;

    // Mapps the token amounts with the address
    mapping (address => uint) public deposits;

    constructor() {
        seller = payable(msg.sender);
    }

    // To get the Reentrancy Attack to work is this function getBalances() also necessary 
    function getBalance() public view returns(uint) {
        // Shows the caller how much tokens are in the auction contract to take them out 
        return deposits[msg.sender];
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

        // Increase token amount for new address 
        deposits[msg.sender] += msg.value;
        
        // Adds the new address to the highestBidder
        highestBidder = msg.sender;
        // Adds the new amount to the highestBid
        highestBid = msg.value;
    }

    // To debug the first error (day 1) - Denial of Service (DoS) Attack - and to transfer tokens more safely to another smart contract is another function takeOut() necessary
    // However now is a new error created - Reentrancy Attack - the possibility to drain down the auction contract
    // Reentrancy Attack - HUGE ERROR ON A LOT OF CONTRACTS AND THE REASON OF STOLEN TOKENS FROM CONTRACTS
    // The order of the function takeOut matters 
    function takeOut() public {
        // Check whether the caller is'n the highestBidder 
        require(msg.sender != highestBidder);
        // Check wether the caller of the takeOut() has deposit some tokens in the auction contract
        require(deposits[msg.sender] != 0);
        
        // With the .call method we can create a temp var to check later wether the amount can be refunded
        (bool tryToSend, ) = msg.sender.call{value: deposits[msg.sender]}("");
        // Here starts the error 
        // After calling the .call method the fallback() from the Hack contract gets called every time until the auction contract has lost all the tokens
       
        // check whether the amount has refunded - after attack happened
        require(tryToSend);
        // Deposits of the address gets reset to 0 because the amount is resent to the previeous highestBidder 
        deposits[msg.sender] = 0;
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