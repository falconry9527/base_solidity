// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleWhitelist {
    bytes32 public merkleRoot;
    address public owner;

    event MerkleRootUpdated(bytes32 newRoot);

    constructor(bytes32 _merkleRoot) {
        merkleRoot = _merkleRoot;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    // 管理员更新 Merkle Root
    function updateMerkleRoot(bytes32 _newRoot) external onlyOwner {
        merkleRoot = _newRoot;
        emit MerkleRootUpdated(_newRoot);
    }

    // 验证用户是否在白名单
    function isWhitelisted(address user, bytes32[] calldata _merkleProof) external view returns (bool) {
        bytes32 leaf = keccak256(abi.encodePacked(user));
        return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
    }
}
