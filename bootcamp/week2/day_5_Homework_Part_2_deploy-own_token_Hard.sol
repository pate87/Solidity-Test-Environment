// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract OwnToken {

    address private owner;
    uint public totalSuply = 0;
    string public name = "Patrick Token Hard Coded";
    string public symbol = "PST";

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "You're not the owner");
        _;
    }

    mapping(address => uint) balances;

    function getBalance(address _address) public view returns(uint) {
        return balances[_address];
    }

    function mint(uint amaunt) public onlyOwner {
        balances[msg.sender] += amaunt;
        totalSuply += amaunt;
    }

    function transfer(address to, uint amaunt) public {
        require(balances[msg.sender] >= amaunt, "You've not enough tokens");
        require(to != address(0), "Can't send to 0 address");
        balances[to] += amaunt;
        balances[msg.sender] -= amaunt;
    }
}