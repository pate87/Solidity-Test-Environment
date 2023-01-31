// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract PSToken {

    address public owner;
    uint public totalSupply;
    uint public currentSupply;
    uint public burnedTokens;
    string public constant name = "Patrick Basic Token";
    string public constant symbol = "PBST";
    uint constant decimals = 18;

    mapping(address => uint) public balances;

    event Sent(address indexed from, address indexed to, uint amount);

    constructor(uint _totalSupply) {
        totalSupply = _totalSupply;
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "You're not the owner");
        _;
    }

    function mint(address to, uint amount) public onlyOwner {
        require(totalSupply >= currentSupply, "All tokens already minted");
        require(to != address(0), "ERC20: mint to the zero address");
        
        balances[to] += amount;
        currentSupply += amount;
    }

    function transfer(address to, uint amount) public {
        require(amount <= balances[msg.sender], "Not enough tokens");
        require(to != address(0), "No mint to the zero address");
        require(amount <= currentSupply);
        
        balances[msg.sender] -= amount;
        balances[to] += amount;
        
        burn(amount);
        
        emit Sent(msg.sender, to, amount);
    }

    function remainingSupply() public view returns(uint) {
        return totalSupply - currentSupply;
    }

    function burn(uint amount) private {
        totalSupply -= amount / 1000 * 1;
        currentSupply -= amount / 1000 * 1;
        burnedTokens += amount / 1000 * 1;
    }

    function halfing() public {
        uint startTime = block.timestamp;
        uint endTime = 60 + startTime;

        if(endTime <= 0) {
            totalSupply = totalSupply / 2;
            currentSupply = currentSupply / 2;
            burnedTokens = burnedTokens / 2;
        }
    }
}