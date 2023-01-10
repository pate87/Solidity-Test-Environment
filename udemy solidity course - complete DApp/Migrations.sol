// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Migrations {
    address public owner;
    uint public last_completed_migrations;

    constructor () {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(owner == msg.sender, "You're not the owner");
        _;
    }

    function set_completed(uint completed) public onlyOwner {
        last_completed_migrations = completed;
    }

    function upgrade(address new_address) public onlyOwner {
        Migrations upgraded = Migrations(new_address);
        upgraded.set_completed(last_completed_migrations);
    }
}