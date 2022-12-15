// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OwnTokenEasy is ERC20("Patrick Token Import OpenZeppelin", "PSTO") {

    address private owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "You're not the owner");
        _;
    }

    mapping(address => uint) balances;

    // function getBalance(address _address) public view {
    //     balanceOf(_address);
    // }

    function mintToken(uint amount) public onlyOwner {
        _mint(0x3CdBff65DaC67cDb6E5c4F05c4DB8FE05C20e4D8, amount);
    }

    
}