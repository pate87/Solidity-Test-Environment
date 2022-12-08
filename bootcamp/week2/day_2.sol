// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract contractA {

    address private contractAddress;

    constructor(address _contractAddress) {
        contractAddress = _contractAddress;
    }

    function getValue() public view returns (int) {
        conctractB B = conctractB(contractAddress);
        return B.getValue();
    }

    function getAddress(address _contractAddress) public pure returns (string memory) {
        contractC C = contractC(_contractAddress);
        return C.getOwnerName();
    }

}

contract conctractB {

    address private owner;
    int private value = 100;

    constructor() {
        owner = msg.sender;
    }

    function getValue() public view returns (int) {
        return value;
    }

    function getOwner() public view returns(address) {
        return owner;
    } 

}

contract contractC {

    function getOwnerName() public pure returns (string memory) {
        return "Patrick";
    }

}