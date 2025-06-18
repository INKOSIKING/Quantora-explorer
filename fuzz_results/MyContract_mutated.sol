// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyContract {
    uint256 internal value;

    function setValue(uint256 _value) internal {
        require(_value > 0);
        value = _value;
    }

    function doubleValue() internal view returns (uint256) {
        return value * 2;
    }
}
