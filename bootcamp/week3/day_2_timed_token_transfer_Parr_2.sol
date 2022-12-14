// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract timedToken is ERC20("TimedTest", "TT") {

    uint public totalPerDayToSpend = 5;

    mapping(address => uint) public lastTimeSpent;
    mapping(address => uint) public alreadySpent;

    mapping(address => bool) public exclusion;

    function timedTransfer(address to, uint amount) public {
        // check not to mint more tokens than awailable 
        require(amount < totalPerDayToSpend, "You can't spent that much in one day");
        // If they are in the exclusion list the time isn't necessarry anymore 
        if(exclusion[msg.sender] == true) {
            _transfer(msg.sender, to, amount);
        } else {
            if(block.timestamp - lastTimeSpent[msg.sender] >= 1 minutes) {
                // transfer our tokens
                // check when the sender tryed last time to mint tokens
                lastTimeSpent[msg.sender] = block.timestamp;
                // check how many tokens sender already spent 
                alreadySpent[msg.sender] = amount;
                // call function _transfer from ERC20 
                _transfer(msg.sender, to, amount);
            } else {
                // check how many they've already spent today 
                if(alreadySpent[msg.sender] + amount >= totalPerDayToSpend) {
                    // can't spent because they've over their time allowance 
                    revert("You've already all tokens");
                } else {
                    // can spent 
                    // check when the sender tryed last time to mint tokens
                    lastTimeSpent[msg.sender] = block.timestamp;
                    // check how many tokens sender already spent 
                    alreadySpent[msg.sender] += amount;
                    // call function _transfer from ERC20 
                    _transfer(msg.sender, to, amount);
                }
            }
        }
    }

    // function is necessarry to mint ourself tokens without this function the _transfer function won't work
    function mintToken() public {
        // call function _mint from ERC20 
        _mint(msg.sender, 5); 
    }

    // function to toggle exclusion; no time stamp necessarry
    function toggleExclusion(address account) public {
        exclusion[account] = !exclusion[account];
    }
}

// 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2