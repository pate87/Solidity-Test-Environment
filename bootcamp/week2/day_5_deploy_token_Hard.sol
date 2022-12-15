// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract tokenHard {

    mapping(address => uint) public balances;
    string public name = "WhiteBoardCrypto Token";
    string public symbol = "WBC";
    uint public totalSuply = 0;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "You're not the owner");
        _;
    }

    function getBalance(address _address) public view returns(uint) {
        return balances[_address];
    }

    function addTokens(uint amount) public onlyOwner {
        balances[msg.sender] += amount;
        totalSuply += amount;
    }

    function transfer(address to, uint amount) public returns(bool) {
        require(balances[msg.sender] >= amount, "You've not enough tokens to send");
        require(to != address(0), "Can't send to 0 address");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        return true;
    }

}