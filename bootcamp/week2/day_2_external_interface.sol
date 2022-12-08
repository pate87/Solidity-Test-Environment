// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

interface IconctractB {
        function getOwner() external view returns(address);
    }

contract D {

    address private contractAddress;

    constructor(address _contractAddress) {
        contractAddress = _contractAddress;
    }

    function getOwner () public view returns (address) {
        IconctractB B = IconctractB(contractAddress);
        return B.getOwner();
    }
}