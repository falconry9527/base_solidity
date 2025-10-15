// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 被调用合约
contract Token {
    uint256 public balance;

    function deposit(uint256 amount) external {
        balance += amount;
    }
}

// 调用合约
contract Caller {
    function callDeposit(address tokenAddress, uint256 amount) external returns (bool) {
        // 1️⃣ 函数选择器（前4字节）
        bytes4 selector = bytes4(keccak256("deposit(uint256)"));

        // 2️⃣ 构造 calldata = 函数选择器 + 编码参数
        bytes memory data = abi.encodeWithSelector(selector, amount);

        // 3️⃣ 发起低层调用
        (bool success, ) = tokenAddress.call(data);
        require(success, "Call failed");

        return success;
    }
}
