// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import "hardhat/console.sol";  // Hardhat

contract testReference {

    // ArrArray
    function testArr() public pure {
        uint256[] memory tempArray = new uint256[](3); // 内存中创建长度为3的动态数组
        tempArray[0] = 10;
        for (uint256 i = 0; i < tempArray.length; i++) {
            tempArray[i] = i * 2; // 初始化数组
        }
        for (uint256 i = 0; i < tempArray.length; i++) {
            tempArray[i] = i * 2; // 初始化数组
        }
    }

    // mapping
    function testMapping() public view {
        mapping(address => uint256) memory balances;
        uint256 balance = balances[msg.sender];
    }
    // struct
    function testStruct() public view {
        uint256 balance = balances[msg.sender];
    }
    }

    struct CustomType {
        bool myBool;
        uint256 myInt;
    }
    CustomType ct = CustomType({myBool: true, myInt: 2});

   // string 
    // function to return string length
    function getStringLength() public view returns (uint256) {
        string myString = "Hello, Solidity!";
        return bytes(myString).length;
    }


}
