// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Escrow {
    enum Status { Pending, Released, Refunded }
    struct Deal { address buyer; address seller; uint256 amount; Status status; }
    mapping(uint => Deal) public deals;
    uint public nextId;
    function create(address seller) public payable {
        deals[nextId] = Deal(msg.sender, seller, msg.value, Status.Pending);
        nextId++;
    }
    function release(uint id) public {
        require(deals[id].buyer == msg.sender, "Only buyer");
        require(deals[id].status == Status.Pending, "Not pending");
        deals[id].status = Status.Released;
        payable(deals[id].seller).transfer(deals[id].amount);
    }
    function refund(uint id) public {
        require(deals[id].seller == msg.sender, "Only seller");
        require(deals[id].status == Status.Pending, "Not pending");
        deals[id].status = Status.Refunded;
        payable(deals[id].buyer).transfer(deals[id].amount);
    }
}