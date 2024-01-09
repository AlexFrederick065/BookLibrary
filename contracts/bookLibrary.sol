// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract bookLibrary {
    address librarian;
    constructor() {
        librarian = msg.sender;
    }
    enum Categories {Romantic,SciFi, Ficition}
    struct Book{
        string name;
        string author;
        Categories bookCategory;
        uint quantity;
    }

    mapping(uint256 => Book) bookMap;
    mapping(address => mapping(uint256 => bool)) bookBorrowed;
    mapping(address => Book) bookOwned;


    modifier onlyLibrarian(){
        require(librarian == msg.sender, "Only Librarian is allowed for this action");
        _;
    }

    function storeBook (uint256 _id,string memory _name, string memory _author, Categories _categories, uint _quantity) public onlyLibrarian() {
        bookMap[_id] = Book(_name,_author,_categories,_quantity);
    }

    function getBook(uint256 _bookId) public view returns(Book memory){
        //Check If Exists or not
        require((bytes(bookMap[_bookId].name).length > 0), "Book Does Not Exists");

        return bookMap[_bookId];
    }

    function alotBook(uint256 _bookId, address _bookOwnerAddress) public onlyLibrarian {
        //Check If Exists or not
        require((bytes(bookMap[_bookId].name).length > 0), "Book Does Not Exists");

        //Check if book is already borrowed
        require(!bookBorrowed[_bookOwnerAddress][_bookId],"Already Booked");

        //Check if Book is available or not
        require(bookMap[_bookId].quantity > 0, "Book Not Available");
        //If not booked then alot
        bookOwned[_bookOwnerAddress] = bookMap[_bookId];
        bookBorrowed[_bookOwnerAddress][_bookId] = true;
        bookMap[_bookId].quantity -= 1;
    }

    function returnBook(uint256 _bookId, address _bookOwnerAddress) public {
        //Check If Exists or not
        require((bytes(bookMap[_bookId].name).length > 0), "Book Does Not Exists");
        
        //Check if book is already booked
        require(bookBorrowed[_bookOwnerAddress][_bookId],"No Book Borrowed");

        bookBorrowed[_bookOwnerAddress][_bookId] = false;
        delete(bookOwned[_bookOwnerAddress]);
        bookMap[_bookId].quantity += 1;
    }

}