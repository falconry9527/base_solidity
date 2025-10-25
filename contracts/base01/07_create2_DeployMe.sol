// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeployMe {
    uint256 public value;
    address public owner;

    constructor(uint256 _value, address _owner) {
        value = _value;
        owner = _owner;
    }
}
