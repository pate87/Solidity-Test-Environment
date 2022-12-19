// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract dbank {

    // Create address array 
    address[] public bankaddress;

    // mapping address accounts - mapping creats a table
    // mapping is cheaper to iterate through instead of arrays 
    mapping(address => uint) accounts;
  
    
    function addBankAddress(address _address, uint amount) public {
        // push address to bankaddress array 
        bankaddress.push(_address);
        // adds amount to accounts mapping 
        accounts[_address] += amount;
    }

    function getBankAddresssArrayLength() public view returns(uint) {
        return bankaddress.length;
    }

    function getAccountsFundMapping(address _address) public view returns(uint) {
        return accounts[_address];
    }
}

contract dbank_With_Struct {

    // creates a new variable 
    struct Account {
        address _address;
        uint amount;
    }

    // Create new array 
    Account[] costumersAccounts;

    // mapping address accounts - mapping creats a table
    // mapping is cheaper to iterate through instead of arrays 
    mapping(address => uint) accounts;

    function addCostumerAccount(address _address, uint amount) public {
        // push address to bankaddress array 
        costumersAccounts.push(Account(_address, amount));
        // adds amount to accounts mapping 
        accounts[_address] += amount;
    }

    // get costumersAccounts array info
    function getAccounts(uint id) public view returns(address, uint) {
        return(costumersAccounts[id]._address, costumersAccounts[id].amount);
    }

    function getAccountsArrayLength() public view returns(uint) {
        return costumersAccounts.length;
    }
}