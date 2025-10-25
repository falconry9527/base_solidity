// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract testStruct {
    
    // struct
    struct CustomType {
        bool myBool;
        uint256 myInt;
    }
    
    CustomType ct = CustomType({myBool: true, myInt: 2});

    function getStruct() public view returns (bool, uint256) {
        return (ct.myBool, ct.myInt);
    }

}