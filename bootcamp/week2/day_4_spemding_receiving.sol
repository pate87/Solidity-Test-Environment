// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract vault {

    address payable creator;

    constructor () payable {
        creator = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == creator, "You're not allowed to withdraw tokens");
        _;
    }
    receive() external payable{}

    function depositMoney() public payable returns(uint) {
        return msg.value;
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    // Refund Gas 
    // 2300 gas only
    // Not recommended for huge amounts 
    function takeOutWithTransfer(uint amount) public onlyOwner {
        address payable mine = payable(msg.sender);
        mine.transfer(amount * (10**18));
    } 

    // Doesn't refund Gas and continue even if it failed 
    // 2300 gas only 
    // Not recommended for huge amounts 
    function takeOutWithSend(uint amount) public onlyOwner returns(bool) {
        address payable mine = payable(msg.sender);
        bool tryToSend = mine.send(amount * (10**18));
        return tryToSend;
    }

    // Most used function call because it's possible to set the amount of gas on the function 
    function takeOutWithCall(uint amount) public onlyOwner returns(bool, bytes memory) {
        address payable mine = payable(msg.sender);
        (bool tryToSend, bytes memory data) = mine.call{value: amount * (10**18), gas: 5000  }("");
        return (tryToSend, data);
    }
}