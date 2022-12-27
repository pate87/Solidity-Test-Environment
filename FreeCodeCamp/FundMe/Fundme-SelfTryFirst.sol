// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.7;

/*
// Get funds from user
// withdraw funds
// set minimum funding value
*/

contract FundMe {

    uint minimumFundsValue;
    address[] public funderArray;
    address owner;
    uint public totalFunds;

    constructor(uint _minimumFundsValue) {
        owner = msg.sender;
        // set minimum funding value
        minimumFundsValue = _minimumFundsValue;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "You're not the owner");
        _;
    }

    mapping(address => uint) public fundsAmountOfAddress;

    // Get funds from user
    function fund(address payable funder, uint amount) public onlyOwner {
        funderArray.push(funder);
        fundsAmountOfAddress[funder] += amount;
        totalFunds += amount;
    }

    // withdraw funds
    function withdraw(address to, uint amount) public onlyOwner {
        require(totalFunds >= minimumFundsValue, "The minimum funds arent achived yet");
        require(amount <= fundsAmountOfAddress[to], "You've not enough funds");
        fundsAmountOfAddress[to] -= amount;
        totalFunds -= amount;
    }
}


// 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
// 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db