// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.7;

import "./SimpleStorage.sol";

contract ExtraStorage is SimpleStorage {

    // The override function works also without having the other function as virtual, however there is a compiler error 
    function store(uint256 _favoriteNumber) public override {
        favoriteNumber = _favoriteNumber + 5;
    }
}