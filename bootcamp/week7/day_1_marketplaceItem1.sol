// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract marketplaceItem1 {

    AggregatorV3Interface internal priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);

    mapping (address => bool) public alreadyBought;
    uint public price = 10 * 10**18;
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

    function getCurrentPriceOfETH() public view returns(int) {
        (/*data1*/, int priceOfUSD, /*data2*/, /*data3*/, /*data4*/) = priceFeed.latestRoundData();
        return priceOfUSD / 10**8;
    }

    function getPriceOfETH() public view returns(int) {
        return int(price) / getCurrentPriceOfETH();
    }
    // 0.007510326699211416

    function payInEth() public payable returns(bool) {
        require(msg.value == uint(getPriceOfETH()), "Wrong amount of ETH!");
        // move the ETH to the owner's account 
        (bool sent, /*data*/) = owner.call{value: msg.value}("");
        require(sent == true, "Failed to send ETH");
        alreadyBought[msg.sender] = true;
        return alreadyBought[msg.sender];
    }

    function changeOwner(address newOwner) public {
        require(msg.sender == owner, "You're not the owner");
        owner = newOwner;
    }

    function changePrice(uint newPrice) public {
        require(msg.sender == owner, "You're not the owner");
        price = newPrice;
    }
}