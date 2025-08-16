// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract adressBase {
    // 转出方是调用改函数的人: msg.sender
    // ETH 转账的三种方式 ： transfer
    // payable ： eth 原生代币需要 payable，erc20 和 erc721不需要 payable
    function transfer(address payable recipient, uint256 value) public payable {
        recipient.transfer(value);
    }

    // ETH 转账的三种方式 ： send
    function send(address payable recipient) public payable {
        bool success = recipient.send(msg.value); // 转移 1 ETH，返回成功与否
        require(success, "Transfer failed.");
    }

    // ETH 转账的三种方式 ： call
    function callFunction(address  payable recipient) public payable {
        (bool success, ) = recipient.call{value: 1 ether}(""); // 使用 call 转移 1 ETH
        require(success, "Transfer failed.");
    }

    // ERC20 转账 ： 方式一 transferFrom
    function transfer(
        address ercAdress,
        address from,
        address to,
        uint256 value
    ) internal {
        // IERC20(token).transfer(to, value);
        IERC20(ercAdress).transferFrom(from, to, value);
    }

    // ERC20 转账 ： 方式一 transferFrom - 使用 call 调用
    // metaNodeSwap  ：./libraries/TransferHelper.sol
    function safeTransfer(address ercAdress, address to, uint256 value) internal {
        (bool success, bytes memory data) = ercAdress.call(
            abi.encodeWithSelector(IERC20.transfer.selector, to, value)
        );
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),"TF"
        );
    }

    // IERC721 (NFT) 转账
    function transferNFT(
        address nftAdress,
        uint256 tokenId,
        address from,
        address to
    ) internal {
        // IERC721(nftAdress).transferFrom(from, to, tokenId);
        IERC721(nftAdress).safeTransferFrom(from, to, tokenId);
    }

    //  支付工具类：
    //  asySwapContract ./libraries/LibTransferSafeUpgradeable.sol

}
