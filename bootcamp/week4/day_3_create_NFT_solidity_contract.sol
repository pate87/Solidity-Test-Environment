// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract simpleNFT is ERC721, Ownable {

    uint public totalSupply;
    uint public maxSupply;
    string public baseURL;

    constructor(string memory URL, uint _maxSupply) ERC721("TestNFTPatrick", "PTNFT") {
        maxSupply = _maxSupply;
        baseURL = URL;
    }

    // This function is inherit from IERC721.sol and returns the URI
    // Needs to have the same structure as the inherit function - internal and no public 
    function _baseURI() internal view override returns(string memory) {
        return baseURL;
    }

    // The is a copy of _safeMint from IERC721.sol but not inherit 
    // The onlyOwner is inherit from Ownable.sol 
    function safeMint(address to) public onlyOwner {
        require(maxSupply > totalSupply, "Already Minted Maximal Tokens");
        // tokenId is necessary to call the inherit function _mint from IERC721.sol later 
        uint tokenId = totalSupply;
        totalSupply += 1;
        // inherit the function _mint from IERC721.sol 
        _mint(to, tokenId);
    }


}