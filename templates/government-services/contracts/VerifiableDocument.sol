// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VerifiableDocument {
    mapping(uint => bytes32) public docHashes;
    function register(uint docId, bytes32 hash) public {
        docHashes[docId] = hash;
    }
    function verify(uint docId, bytes32 hash) public view returns (bool) {
        return docHashes[docId] == hash;
    }
}