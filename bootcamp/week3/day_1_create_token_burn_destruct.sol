// SPDX-License-Identifier:MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract token is ERC20 ("WBCTEST", "WBCT") {

    mapping (address => uint) public balances;

    address public owner;

    constructor() payable {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(owner == msg.sender, "You're not the owner!");
        _;
    }

    function mintNewTokens(uint amount) public onlyOwner {
        _mint(msg.sender, amount);
    }

    function burnAndAdd(uint amount) public {
        _burn(msg.sender, amount);
        balances[msg.sender] += amount;
    }

    function burned(address _address) public view returns(uint) {
        return balances[_address];
    }

    function win() public {
        if(balances[msg.sender] >= 5) {
            // takes the contract off the blockchain 
            // sends the amaunt to an address 
            selfdestruct(payable(msg.sender));
        } else {
            revert("You didn't have enough points to win");
        }
    }
}