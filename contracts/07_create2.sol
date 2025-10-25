// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./07_create2_DeployMe.sol";

contract Factory {
    event Deployed(address addr, uint256 salt);

    // 使用 CREATE2 部署子合约
    function deploy(uint256 _value, address _owner, uint256 _salt) public returns (address) {
        // 拼接 bytecode 并 encode 两个参数
        bytes memory bytecode = type(DeployMe).creationCode;
        bytecode = abi.encodePacked(bytecode, abi.encode(_value, _owner));

        address addr;
        assembly {
            addr := create2(0, add(bytecode, 0x20), mload(bytecode), _salt)
            if iszero(extcodesize(addr)) { revert(0, 0) }
        }

        emit Deployed(addr, _salt);
        return addr;
    }

    // 部署前预测地址
    function getAddress(uint256 _value, address _owner, uint256 _salt) public view returns (address) {
        bytes memory bytecode = type(DeployMe).creationCode;
        bytecode = abi.encodePacked(bytecode, abi.encode(_value, _owner));

        bytes32 hash = keccak256(
            abi.encodePacked(
                bytes1(0xff),
                address(this),
                _salt,
                keccak256(bytecode)
            )
        );
        return address(uint160(uint256(hash)));
    }
}
