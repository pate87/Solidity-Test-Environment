// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract elbow {

    uint public age = 23;

    function bend() public pure virtual returns(string memory) {
        return "bending";
    }
}

contract leftArm is elbow {
    function getAge() public view returns(uint) {
        return age;
    }

    function raise() public pure virtual returns(string memory) {
        return string.concat("left arm is ", bend()); 
    }
}

contract rightArm is elbow {

    function raise() public pure virtual returns(string memory) {
        return string.concat("right arm is ", bend());
    }
}

contract person is rightArm, leftArm {

    // function highFive() public pure returns(string memory) {
    //     return raise();
    // }

    function raise() public pure override(leftArm, rightArm) returns(string memory) {
        return string.concat("both armes are ", bend());
    }

    function raiseLeftArm () public pure returns(string memory) {
        return leftArm.raise();
    }
}

contract knee is elbow {

    function kick() public pure returns(string memory) {
        return "kicking ";
    }
}

contract alian is rightArm, knee {

    function fly() public pure returns (string memory) {
        return string.concat(kick(), raise());
    }

    function bend() public pure override returns(string memory) {
        return "exfloating";
    }
}