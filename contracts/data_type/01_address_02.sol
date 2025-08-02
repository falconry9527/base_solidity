// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract SimpleWhitelist {
    // 白名单机制
    mapping(address => bool) public whitelist;

    function addToWhitelist(address _address) public {
        whitelist[_address] = true;
    }

    function isWhitelisted(address _address) public view returns (bool) {
        return whitelist[_address];
    }

    // 授权支付合约
    function pay(address payable recipient) public payable {
        require(whitelist[recipient], "Recipient is not whitelisted.");
        recipient.transfer(msg.value);
    }
}
