// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CatErc20 is ERC20 {
    // 在 Sepolia 测试网上发行 ERC20 代币
    constructor(uint256 initialSupply) ERC20("MyToken", "MTK") {
        // 给开发者初始化代币
        _mint(msg.sender, initialSupply);
    }

    // 给 _address 转账
    function send(address _address) public payable{
        address payable recipient = payable(_address);
        bool success = recipient.send(msg.value); // 转移 1 ETH，返回成功与否
        require(success, "Transfer failed.");
    }

    event Deposit(address indexed sender, uint amount);
    event Withdraw(address indexed receiver, uint amount);

    // 给合约存款
    function deposit() external payable {
        emit Deposit(msg.sender, msg.value);
    }
    
    // 从合约取款
    function withdraw(uint amount) external {
        payable(msg.sender).transfer(amount);
        emit Withdraw(msg.sender, amount);
    }
    





}