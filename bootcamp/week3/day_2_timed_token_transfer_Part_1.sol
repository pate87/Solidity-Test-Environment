// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract timed {

    uint public launchTime = block.timestamp + (1 hours / 60);
    bool public canMint = false;

    function getTime() public view returns(uint) {
        return block.timestamp;
    }

    function mintTokens() public {
        if(launchTime < block.timestamp) {
            canMint = true;
        } else {

        }
    }
}