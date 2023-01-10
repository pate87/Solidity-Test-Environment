// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract ToDo {

    address owner;
    uint public totalTasks = 0;
    mapping(uint => Task) public taskList;

    struct Task {
        uint id;
        string taskName;
        bool completedYet;
        uint completedTime;
    }

    mapping(address => bool) public isOwner;

    function setOwner(address ownerAddress) public returns(bool) {
        return isOwner[ownerAddress] = true;
    }

    function createTask(string memory _task) public {
        require(isOwner[msg.sender] == true, "You're not the owner");
        taskList[totalTasks] = Task(totalTasks, _task, false, 0);
        totalTasks += 1;
    }

    function toggleTask(uint index) public {
        require(isOwner[msg.sender] == true, "You're not the owner");
        if(!taskList[index].completedYet) {
            taskList[index].completedTime = block.timestamp;
        } else {
            taskList[index].completedTime = 0;
        }
        taskList[index].completedYet = !taskList[index].completedYet;
    } 
}