// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Airdrop is ERC20 ("Airdrop", "AT") {

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "You're not the owner");
        _;
    }

    function mint(address[] memory _address, uint amount) public onlyOwner {
        
        for(uint i = 0; i < _address.length; i++) {
            _mint(_address[i], amount * 10**18);
        }
        
    }
    
}