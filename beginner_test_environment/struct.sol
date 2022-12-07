// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract structTest {

    struct Book {
        string title;
        string author;
        uint book_id;
    }

    Book book;

    function setBook() public {
        book = Book('Learn Solidity', 'TP', 1);
    }

    function getBook() public view returns (string memory, string memory, uint) {
        return (book.title, book.author, book.book_id);
    }
}

contract bootcampStructTest {

    struct car {
        uint whells;
        uint windows;
        string model;
    }

    // This is like a function call view 
    car public myCar1 = car(2,4,"Renault");
    car public myCar2 = car(3,1,"Honda");
    car public myCar3 = car(4,2,"Ford");
    car public myCar4 = car(4,3,"Skodda");

    // Not neccessarry function call 
    // function getCar() public view returns(car memory) { 
    //     return myCar1;
    // }
}