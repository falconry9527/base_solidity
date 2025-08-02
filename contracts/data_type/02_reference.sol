// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract testReference {
    // ArrArray
    function testArr() public pure  () {
        uint256[] memory tempArray = new uint256[](3); // 内存中创建长度为3的动态数组
        tempArray[0] = 10;
        return tempArray;
    }
    // mapping
    function testMapping() public pure  () {
        mapping(address => uint256) public balances;
        uint256 balance = balances[msg.sender];
    }
    
    // struct
    function testStruct() public pure returns (uint256[] memory) {
        mapping(address => uint256) public balances;
        uint256 balance = balances[msg.sender];
    }

    struct CustomType {
        bool myBool;
        uint256 myInt;
    }
    CustomType ct = CustomType({myBool: true, myInt: 2});

   // string 
    // function to return string length
    function getStringLength() public view returns (uint256) {
        string public myString = "Hello, Solidity!";
        return bytes(myString).length;
    }


}
