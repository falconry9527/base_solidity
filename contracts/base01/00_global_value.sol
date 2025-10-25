// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract testGolobalValue {
    // 获取当前区块号和时间戳
    function getBlockDetails() public view returns (uint, uint) {
        return (block.number, block.timestamp);
    }

    // 获取调用者地址和发送的 ETH 数量
    function getMessageDetails() public payable returns (address, uint) {
        return (msg.sender, msg.value);
    }
    // 获取当前合约的地址和余额
    function getContractDetails() public view returns (address, uint) {
        return (address(this), address(this).balance);
    }

    // 身份验证
    address public owner;
    constructor() { owner = msg.sender; }
    function isOwner() public view returns (bool) {
        return msg.sender == owner;
    }
    
}
