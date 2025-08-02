// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";  // Hardhat

contract testValue {
    // int
    function testInt() public {
        int256 x = 4;
        int256 y = 4;
        int256 z = x + y;
        console.log("int256 z = x + y: ", z);
    }
}
