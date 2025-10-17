// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Dedupe {
    mapping(address => bool) seen;

    // 1. 使用mapping 进行去重
    function dedupe(address[] memory users) public returns (address[] memory) {
        address[] memory res = new address[](users.length);
        uint count = 0;
        for (uint i = 0; i < users.length; i++) {
            if (!seen[users[i]]) {
                seen[users[i]] = true;
                res[count] = users[i];
                count++;
            }
        }
        // 修正数组长度
        assembly {
            mstore(res, count)
        }
        return res;
    }

    function dedupeTemp(
        address[] memory users
    ) public pure returns (address[] memory) {
        address[] memory res = new address[](users.length);
        uint count = 0;
        for (uint i = 0; i < users.length; i++) {
            bool exists = false;
            for (uint j = 0; j < count; j++) {
                if (res[j] == users[i]) {
                    exists = true;
                    break;
                }
            }
            if (!exists) {
                res[count] = users[i];
                count++;
            }
        }
        assembly {
            mstore(res, count)
        }
        return res;
    }

    // 2. 二分查找
    function binarySearch(
        uint[] memory arr,
        uint target
    ) public pure returns (uint) {
        uint low = 0;
        uint high = arr.length;
        while (low < high) {
            uint mid = (low + high) / 2;
            if (arr[mid] < target) {
                low = mid + 1;
            } else {
                high = mid;
            }
        }
        return low;
    }

    // 3.累积利息/奖励
    function accrued(
        uint principal,
        uint rate,
        uint deltaTime
    ) public pure returns (uint) {
        return (principal * (1e18 + rate * deltaTime)) / 1e18;
    }

    // 4. AMM输出计算 : 给定 xToken/yToken 数量和 swap 数量，计算输出
    function getAmountOut(
        uint xReserve, // xToken 储备量
        uint yReserve, // yToken 储备量
        uint xAmount // 输入的 xToken 数量
    ) public pure returns (uint) {
        uint xAfter = xReserve + xAmount;
        uint yAfter = (xReserve * yReserve) / xAfter;
        // 返回输出的 yToken 数量
        return yReserve - yAfter;
    }

    // 5. Merkle Proof
    function verify(
        bytes32 root,
        bytes32 leaf,
        bytes32[] memory proof
    ) public pure returns (bool) {
        bytes32 hash = leaf;
        for (uint i = 0; i < proof.length; i++) {
            hash = keccak256(
                abi.encodePacked(
                    hash < proof[i] ? hash : proof[i],
                    hash < proof[i] ? proof[i] : hash
                )
            );
        }
        return hash == root;
    }

    // 位运算控制权限
    uint256 public perms;

    function addPermission(uint8 i) public {
        perms |= (1 << i); // 设置第 i 位
    }

    function removePermission(uint8 i) public {
        perms &= ~(1 << i); // 清除第 i 位
    }

    function hasPermission(uint8 i) public view returns (bool) {
        return (perms >> i) & 1 == 1; // 检查第 i 位
    }
}
