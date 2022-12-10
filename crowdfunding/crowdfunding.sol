// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract crowdfunding_ {

    // Initialaize empty state variables 
    uint private fundGoal;
    uint256 public minContribution;
    // uint public donatedValue;
    uint private goalReached;
    uint public costumerValue = 50;
    // address public recipient;
    address private owner;

    // Fill the state variables at deployment 
    constructor(address _owner, uint _fundGoal, uint _minContribution) {
        fundGoal = _fundGoal;
        goalReached = _fundGoal;
        minContribution = _minContribution;
        owner = _owner;
    }

    struct Costumer {
        address costumerAddress;
        uint costumerValue;
        bool donated;
    }

    event newFounder (uint costumerId, address costumerAddress, uint amountSpend, bool donated);
    
    mapping(address => bool) public isFounder;
    Costumer[] public costumers;
    mapping(address => uint) public costumerBalance;

    function donate(address _founderAddress, uint _value) public payable {
        require(_founderAddress != owner, "You're the owner!");
        require(_value >= minContribution, "Minimum value is 1 Eth!");
        // costumer = Costumer(_founderAddress, _value, true);
        costumerBalance[_founderAddress] += _value;
        isFounder[_founderAddress] = true;
        fundGoal = fundGoal - _value;
        // donatedValue = _value;
        costumers.push(Costumer(_founderAddress, _value, true));
        uint id = costumers.length - 1;
        emit newFounder (id, _founderAddress, _value, true);
    }

    function getFundGoal() public view returns(string memory) {
        if(fundGoal == 0) {
            return "Goal reched";
        } else {
            return "Goal not reached";
        }
    }
   
    function getFundGoalNumber() public view returns(uint) {
        if(fundGoal == 0) {
            return 0;
        } else {
            return fundGoal;
        }
    }

    function requestFund(address receiver, uint _amount) public payable {
        // if(msg.sender == costumers[isFounder]) {
            // if(fundGoal != 0 && fundGoal < goalReached && _amount <= donatedValue) {
            if(fundGoal != 0 && fundGoal < goalReached) {
                fundGoal = fundGoal + _amount;
                costumerValue = costumerValue + _amount;
                costumerBalance[receiver] += _amount;
                // donatedValue -= _amount;
                // donatedValue -= _amount;
            }
        // }
    } 

    function getUsersCount() public view returns(uint) {
        return costumers.length;
    }  

}