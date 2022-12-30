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

    // Pay each family member based on their wallet address 
    function transfer() private mustBeDeceased {
        for(uint i = 0; i <= familyWallets.length; i++) {
            // transfering the funds from contract address to reciever address 
            familyWallets[i].transfer(walletsOfFamily[familyWallets[i]]);
        }
    }
}