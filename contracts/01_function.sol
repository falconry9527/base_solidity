// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract testFunction {

    uint public data;

    // view: 声明不修改状态的函数，可读取状态变量。
    function getData() public view returns (uint) {
        return data;
    }

    // pure: 既不读取也不修改状态，仅依赖于函数参数。
    function add(uint a, uint b) public pure returns (uint) {
        return a + b;
    }


}
