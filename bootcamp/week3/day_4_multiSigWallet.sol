// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

contract multiSigLesson {

    // list of owners
    address[] public owners;

    // number of approvals required - Hard coded
    uint public approvalsNeeded = 2;

    // mapping to look whether the address is an owner or not
    // mapping is cheaper than array to loop through
    mapping(address => bool) ownerList;

    // mapping into mapping to look for vote on voteOnTransaction()
    // index is looking for the address > address looks for transaction 
    mapping(uint => mapping(address => bool)) public alreadyVoted;

    receive() external payable{}

    modifier OnlyOwner {
        require(ownerList[msg.sender] == true, "Your're not an owner of this wallet");
        _;
    }

    constructor() {
        owners.push(msg.sender);
        ownerList[msg.sender] = true;

        owners.push(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2);
        ownerList[0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2] = true;
    }

    // creating a new variable that holds the information
    struct Transaction {
        address sendingTo;
        uint value;
        bool alreadyExecuted;
        uint approvals;
    }

    // List of transactions 
    Transaction[] public transactions;

    // ability receive funds
    // ceate a new transaction and push transaction into transactions array 
    function proposeTransaction(address to, uint amount) public OnlyOwner {
        transactions.push(Transaction({
            sendingTo: to,
            value: amount + (10**18),
            alreadyExecuted: false,
            approvals: 0
        }));
    }

    // vote on that propsal
    function voteOnTransaction(uint index) public OnlyOwner {
        require(alreadyVoted[index][msg.sender] == false, "You've already voted");
        transactions[index].approvals += 1;
        alreadyVoted[index][msg.sender] = true;
    }

    // execute transaction if has enough votes - send tokens from one to another wallet
    function executeTransaction(uint index) public OnlyOwner {
        // check how many approvals 
        require(transactions[index].approvals >= approvalsNeeded, "Not enough approvals");
        // check whether already executed 
        require(transactions[index].alreadyExecuted == false, "Already voted");
        address payable toSend = payable (transactions[index].sendingTo);
        // to send the tokens to another address using call() to specify the gas 
        (bool tryToSend, ) = toSend.call{value: transactions[index].value, gas: 5000}("");
        // check whether the wallet has enough tokens to send the transaction and pay the gas fees
        require(tryToSend, "You don't have enough tokens");
        // update state of alreadyExecuted to check the require statement after second use
        transactions[index].alreadyExecuted = true;
    }
}

/*
// list of owners
// number of approvals required
// ability receive funds
// ability propose a transaction
// vote on that propsal
// retract a vote
// execute transaction
*/