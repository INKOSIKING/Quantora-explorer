// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FoodCoupon {
    mapping(address => uint) public balances;
    function issue(address user, uint amount) public {
        balances[user] += amount;
    }
    function use(uint amount) public {
        require(balances[msg.sender] >= amount, "Not enough coupons");
        balances[msg.sender] -= amount;
    }
}