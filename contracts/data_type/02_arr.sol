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

    // mapping
    mapping(address => uint256) public balances;
    function testMapping() public view {
        uint256 balance = balances[msg.sender];
    }

    // struct
    struct CustomType {
        bool myBool;
        uint256 myInt;
    }
    CustomType ct = CustomType({myBool: true, myInt: 2});

    function testStruct() public view {
        uint256 balance = balances[msg.sender];
    }

    // string
    // function to return string length
    function getStringLength() public pure returns (uint256) {
        string memory myString = "Hello, Solidity!";
        return bytes(myString).length;
    }
}
