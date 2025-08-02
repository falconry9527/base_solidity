const { ethers } = require("ethers");

const provider = new ethers.providers.JsonRpcProvider
("https://sepolia.infura.io/v3/bdb2ede84fe04e41a6fc9b2c9506d8c7");

// 合约地址
const contractAddress = "0x7dbd17BDA972cB189d6887F5BD454f6A2823FE14";

const abi = [
  "event Deposit(address indexed sender, uint256 amount)"
];

// 创建合约实例
const contract = new ethers.Contract(contractAddress, abi, provider);

// 监听事件
contract.on("Deposit", (sender, amount, event) => {
  console.log("📥 Deposit Event Detected:");
  console.log("Sender:", sender);
  console.log("Amount (wei):", amount.toString());
  console.log("Tx Hash:", event.transactionHash);
});

