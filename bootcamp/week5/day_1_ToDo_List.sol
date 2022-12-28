// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract ToDo {

    uint public totalTasks = 0;
    mapping(uint => Task) public taskList;

    struct Task {
        uint id;
        string taskName;
        bool completedYet;
        uint completedTime;
    }

    function createTask(string memory _task) public {
        taskList[totalTasks] = Task(totalTasks, _task, false, 0);
        totalTasks += 1;
    }

    function toggleTask(uint index) public {
        if(!taskList[index].completedYet) {
            taskList[index].completedTime = block.timestamp;
        } else {
            taskList[index].completedTime = 0;
        }
        taskList[index].completedYet = !taskList[index].completedYet;
    } 
}