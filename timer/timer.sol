// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract timer {

    uint private _start;
    uint private _end;

    function start() public returns (uint) {
        return _start = block.timestamp;
    }

    function end(uint timeLeft) public returns (uint) {
        return _end = timeLeft + _start;
    }
   
    function remainingTime() public  view returns (uint) {
        return _end - block.timestamp;
    }
}