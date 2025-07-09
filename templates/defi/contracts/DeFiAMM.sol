// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract DeFiAMM {
    mapping(address => uint256) public liquidity;
    event Swap(address indexed user, uint256 amountIn, uint256 amountOut);

    function provide(uint256 amount) public {
        liquidity[msg.sender] += amount;
    }

    function swap(uint256 amountIn) public {
        uint256 amountOut = amountIn * 99 / 100;
        emit Swap(msg.sender, amountIn, amountOut);
    }
}