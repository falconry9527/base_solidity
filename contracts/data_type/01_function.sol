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

    // receive 函数 是专门为接收以太币而设计的，只在没有附加任何调用数据的情况下触发。其功能相对简单，
    // 只处理纯以太币转账
     event Received(address sender, uint amount);
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    // fallback 函数 则更通用，可以处理任意不存在的函数调用。
    // 如果没有 receive 函数，而合约接收以太币，它也会处理以太币的接收。
     event FallbackCalled(address sender, uint amount);
    // 当调用不存在的函数时触发
    fallback() external payable {
        emit FallbackCalled(msg.sender, msg.value);
    }

}
