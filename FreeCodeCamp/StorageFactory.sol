// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.7;

import "./SimpleStorage.sol";

contract StorageFactory {

    // Creates a list of storages 
    SimpleStorage[] public simpleStorageArray;

    // This function deploys another contract from the import
    function createSimpleStorageContract() public {
        // The new keyword shows Solidity that it needs to deploy a new contract 
        SimpleStorage simpleStorage = new SimpleStorage();
        // Add new created simpleStorage to the simpleStorageArray 
        simpleStorageArray.push(simpleStorage);
    }

    function sfStore(uint256 _index, uint256 _number) public {
        // SimpleStorage simpleStorage = simpleStorageArray[_index];
        simpleStorageArray[_index].addPerson(_number, "This is my favorite store number");
        // simpleStorage.addPerson(_number, "This is my favorite store number");
    }

    
    function getStorageFactory(uint256 _index) public view returns(uint256) {
        // SimpleStorage simpleStorage = simpleStorageArray[_index];
        // return simpleStorage.retrieve();
        return simpleStorageArray[_index].retrieve();
    }
}