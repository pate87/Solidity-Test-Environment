// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC20/ERC20.sol";

contract usdt is ERC20 ("USDTTest", "USDTTest"){


    function mintTwenty() public{
        _mint(msg.sender, 20);
    }

}