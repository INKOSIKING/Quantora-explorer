// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyContract {
    uint public value;

    function setValue(uint _value) public {
        require(_value > 0);
        value = _value;
    }

    function doubleValue() public view returns (uint) {
        return value * 2;
    }
}
