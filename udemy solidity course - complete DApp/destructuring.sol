// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract DestructuringFunctions {

    uint public changeValue;
    string public tom = 'Hello';

    function f() public pure returns(uint, bool, string memory) {
        return (3, true, 'Goodbye');
    }

    function g() public {
        (changeValue, ,tom) = f();
    }
}