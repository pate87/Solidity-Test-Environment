// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ChatToken is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    uint public price = 10**18;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("Chat NFT", "CHAT") {}

    // keep of total Message 
    uint public totalMessages = 0;

    struct message {
        uint id;
        address sendFrom;
        uint nftId;
        string sentMessage;
        uint timestamp;
    }

    message[] public Messages;

    // add Message 
    function addMessage(string memory messageToSend, uint nftId) public returns(bool) {
        // Check whether they own an NFT 
        require(ownerOf(nftId) == msg.sender, "You don't own the NFT");
        // Add the message 
        Messages.push(message(totalMessages, msg.sender, nftId, messageToSend, block.timestamp));
        totalMessages++;
        return true; 
    }

    // get Message 
    function getMessage(uint index) public view returns(message memory) {
        return Messages[index];
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://";
    }

    function safeMint() public payable {
        require(msg.value == price, "Not the right amount of tokens");
        // Calling owner function from Ownable.sol turning it into a payable address and setting it to a local variable
        address payable owner = payable(owner());
        // Send tokens to wallet - local variable owner is used to send the tokens to the wallet address of the creater of the contract
        (bool tryToSend, ) = owner.call{value: msg.value}("");
        require(tryToSend == true, "Error in sending funds");
        uint256 tokenId = _tokenIdCounter.current();
        require(tokenId <= 10000, "No more NFT's can be minted");
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}