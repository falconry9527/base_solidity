// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract testArray {
    // ArrArray
    function testArr() public pure returns (uint256[] memory) {
        uint256[] memory tempArray = new uint256[](3); // 内存中创建长度为3的动态数组
        for (uint256 i = 0; i < tempArray.length; i++) {
            tempArray[i] = i * 2; // 初始化数组
        }
        return tempArray;
    }

}
