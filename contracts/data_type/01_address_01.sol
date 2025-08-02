// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract adressBase {
    // 转账过程中 recipient 都是接受方 
    // 装出方是调用改函数的人: msg.sender
    function transfer(address _address) public payable {
        address payable recipient = payable(_address);
        recipient.transfer(msg.value); //
    }
    function send(address _address) public payable{
        address payable recipient = payable(_address);
        bool success = recipient.send(msg.value); // 转移 1 ETH，返回成功与否
        require(success, "Transfer failed.");
    }

    function callFunction(address _address) public payable{
        address payable recipient = payable(_address);
        (bool success, ) = recipient.call{value: 1 ether}(""); // 使用 call 转移 1 ETH
        require(success, "Transfer failed.");
    }
}
