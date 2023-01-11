// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract marketplaceItem1 {

    mapping (address => bool) public alreadyBought;
    uint public price = 10;
    address public owner = payable(msg.sender);

    IERC20 public usdcTestToken = IERC20(0xd9145CCE52D386f254917e481eB44e9943F39138);
    IERC20 public usdtTestToken = IERC20(0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8);

    function payInUSDC() public returns(bool){
        require(alreadyBought[msg.sender] == false, "You already bought this item");
        usdcTestToken.transferFrom(msg.sender, owner, price);
        alreadyBought[msg.sender] = true;
        return alreadyBought[msg.sender];
    }

    function payInUSDT() public returns(bool){
        require(alreadyBought[msg.sender] == false, "You already bought this item");
        usdtTestToken.transferFrom(msg.sender, owner, price);
        alreadyBought[msg.sender] = true;
        return alreadyBought[msg.sender];
    }
}