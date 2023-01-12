// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC20/ERC20.sol";

contract usdc is ERC20 ("USDCTest", "USDCTest"){


    function mintTwenty() public{
        _mint(msg.sender, 20 * 10**18);
    }

}