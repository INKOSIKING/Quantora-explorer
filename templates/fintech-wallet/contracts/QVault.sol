// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract QVault {
    mapping(address => uint256) public balances;
    event Deposit(address indexed user, uint256 value);
    event Withdraw(address indexed user, uint256 value);

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }
    function withdraw(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdraw(msg.sender, amount);
    }
}