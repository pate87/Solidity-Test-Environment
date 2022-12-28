// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract NumberToString {

    // Insert [16,1,20,18,9,3,11] to get my name 

    // first test string with letter to debug the function loop
    // string memory word = "A";
    string word = "";

    constructor() {
        counter[1] = "A";
        counter[2] = "B";
        counter[3] = "C";
        counter[4] = "D";
        counter[5] = "E";
        counter[6] = "F";
        counter[7] = "G";
        counter[8] = "H";
        counter[9] = "I";
        counter[10] = "J";
        counter[11] = "K";
        counter[12] = "L";
        counter[13] = "M";
        counter[14] = "N";
        counter[15] = "O";
        counter[16] = "P";
        counter[17] = "Q";
        counter[18] = "R";
        counter[19] = "S";
        counter[20] = "T";
        counter[21] = "U";
        counter[22] = "V";
        counter[23] = "W";
        counter[24] = "X";
        counter[25] = "Y";
        counter[26] = "Z";
    }

    mapping(uint => string) public counter;
    
    event test1(uint a);
    event test2(string a);

    function numberToString(uint[] memory number) public returns(string memory) {

        for(uint i = 0; i < number.length; i++) {
            // emit test1(i);
            string memory letter = counter[number[i]];
            word = string.concat(word, letter);
            emit test2(word);
        }

        return word;
    }

    function getWord() public view returns(string memory) {
        return word;
    }

}