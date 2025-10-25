
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Dedupe {

mapping(int16 => uint256) public tickBitmap; // key: wordIndex

// 初始化 tick
function setTick(int16 tick) external {
    int16 wordPos = tick >> 8; // 除以 256 向下取整，一个 word 管理 256 个 tick，
    uint8 bitPos = uint8(uint16(tick) & 0xFF);  // 取模 256
    tickBitmap[wordPos] |= (1 << bitPos);
}

// 检查 tick 是否存在
function isInitialized(int16 tick) external view returns(bool) {
    int16 wordPos = tick >> 8;
    uint8 bitPos = uint8(uint16(tick) & 0xFF);
    return (tickBitmap[wordPos] & (1 << bitPos)) != 0;
}


}