// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract EnumExample {
    // 定义枚举类型
    enum Status { 
        Pending,    // 0
        Approved,   // 1
        Rejected,   // 2
        Cancelled   // 3
    }
    
    // 声明枚举变量
    Status public currentStatus;
    
    // 设置状态
    function setStatus(Status _status) public {
        currentStatus = _status;
    }
    
    // 获取状态
    function getStatus() public view returns (Status) {
        return currentStatus;
    }
    
    // 重置为初始状态
    function resetStatus() public {
        delete currentStatus;  // 重置为第一个值(Pending)
    }
}
