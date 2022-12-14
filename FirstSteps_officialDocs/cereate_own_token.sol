// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract coin {

    address private owner;

    constructor() {
        owner = msg.sender;
    }

    mapping (address => uint) public balances;

    event Sent(address from, address to, uint amount);

    function mint(address receiver, uint amount) public {
        require(msg.sender == owner, "You're not the owner!");
        balances[receiver] += amount;
    } 

    error InsufficientBalance(uint requested, uint available);

    function send(address receiver, uint amount) public {
        if(amount > balances[msg.sender]) {
            revert InsufficientBalance({
                requested: amount,
                available: balances[msg.sender]
            });
        }
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
}