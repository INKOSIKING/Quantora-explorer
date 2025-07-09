// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract NFT {
    struct Token { uint id; string uri; address owner; }
    mapping(uint => Token) public tokens;
    uint nextId = 1;
    function mint(string memory uri) public {
        tokens[nextId] = Token(nextId, uri, msg.sender);
        nextId++;
    }
    function transfer(uint id, address to) public {
        require(tokens[id].owner == msg.sender, "Not owner");
        tokens[id].owner = to;
    }
}