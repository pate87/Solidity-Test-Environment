// https://blog.logrocket.com/create-deploy-erc-20-token-ethereum-blockchain/
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Rocket_Tocken {

    // The attribute indexed is used at events to give them a special data structur called "topics" and allow the posibiliy to search for events 
    event Transfer (address indexed from, address indexed to, uint amount);
    event Approval (address indexed owner, address indexed spender, uint amount);

    // constant or immutable. In both cases, the variables cannot be modified after the contract has been constructed. Constant variables, the value has to be fixed at compile-time 
    string public constant name = "Rocket Token";
    string public constant symbol = "RT";
    uint public decimals = 18;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    uint256 totalSupply;

    constructor(uint256 _totalSupply) {
        totalSupply = _totalSupply;
        balances[msg.sender] = totalSupply;
    }

    // Get the balance of an address 
    function getBalance(address from) public view returns(uint) {
        return balances[from];
    }

    // modifier onlyOwner {
    //     require(balances[msg.sender] == true, "You're not the owner");
    //     _;
    // }

    // Transfer tokens to account
    function transfer(address to, uint amount) public returns(bool) {
        require(amount <= balances[msg.sender], "Not enough tokens");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    // Approve token transfer
    function approve(address to, uint amount) public returns(bool) {
        allowed[msg.sender][to] = amount;
        emit Approval(msg.sender, to, amount);
        return true;
    }

    // Get the allowance status of an account
    function allowance(address owner, address from) public view returns(uint) {
        return allowed[owner][from];
    }

    function transferFrom(address from, address to, uint amount) public returns(bool) {
        require(amount <= balances[from], "You're not the owner");
        require(amount <= allowed[from][msg.sender]);
        balances[from] -= amount;
        allowed[from][msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer (from, to, amount);
        return true;
    }
}