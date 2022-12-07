// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract enumTest {
    
    enum FreshJuiceSize { small, medium, large }
    FreshJuiceSize choice;

    // Optional default function
    FreshJuiceSize constant defaultChoice = FreshJuiceSize.medium;

    function setLarge () public {
        choice = FreshJuiceSize.large;
    }
    function setMedium () public {
        choice = FreshJuiceSize.medium;
    }
    function setSmall () public {
        choice = FreshJuiceSize.small;
    }

    // How to get all sizes in one function?
    // function setChoice (change) public {
    //     return choice = change;
    //     if (small) { 
    //         return choice = FreshJuiceSize.small;
    //     }
    // }

    function getChoice() public view returns (FreshJuiceSize) {
        return choice;
    }

    function getDefaultChoice() public pure returns (uint) {
        return uint (defaultChoice);
    }
}

