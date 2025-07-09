// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract QTX {
    string public name = "Quantora Token";
    string public symbol = "QTX";
    uint8 public decimals = 18;
    uint256 public totalSupply = 1e9 * 1e18;
    mapping(address => uint256) public balanceOf;
    event Transfer(address indexed from, address indexed to, uint256 value);
    constructor() { balanceOf[msg.sender] = totalSupply; }
    function transfer(address to, uint256 value) public returns (bool) {
        require(balanceOf[msg.sender] >= value, "Insufficient");
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }
}