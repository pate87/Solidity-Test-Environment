// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Will {
    address owner;
    uint fortune;
    bool deceased;

    constructor() payable {
        owner = msg.sender;
        fortune = msg.value;
        deceased = false;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "You're not the owner");
        _;
    }

    modifier mustBeDeceased {
        require(deceased == true, "Is still alive");
        _;
    }

    address payable[] familyWallets;

    mapping(address => uint) walletsOfFamily;

    function setFamilyWallets(address payable wallet, uint amount) public {
        familyWallets.push(wallet);
        walletsOfFamily[wallet] = amount;
    }
}