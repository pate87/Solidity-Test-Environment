// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract tokenEasy is ERC20("Easy Token", "ET") {

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "You're not the owner");
        _;
    }

    function mintToken(uint amaunt) public onlyOwner {
        _mint(msg.sender, amaunt);
    } 
}