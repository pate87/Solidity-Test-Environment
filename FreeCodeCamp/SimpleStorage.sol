// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.7;

contract SimpleStorage {

    uint favoriteNumber;

    mapping(string => uint256) public nameToFavoriteNumber;

    struct People {
        uint256 favoriteNumber;
        string name;
    }

    People[] public people;

    function addPerson(uint256 _favoriteNumber, string memory _name) public {
        people.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }

    function getPerson(uint x) public view returns(uint256, string memory) {
        return (people[x].favoriteNumber, people[x].name);
    }
}