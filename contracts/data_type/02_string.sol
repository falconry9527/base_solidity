// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract testString {
    function getStringLength(string memory str) public returns (uint256) {
        return bytes(str).length;
    }
}