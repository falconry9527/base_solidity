// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract testArray {
    // 存款用户信息
    struct LendInfo {
        uint256 stakeAmount;          // 当前借款的质押金额
        uint256 refundAmount;         // 超额退款金额
        bool hasNoRefund;             // 默认为false，false = 无退款，true = 已退款
        bool hasNoClaim;              // 默认为false，false = 无索赔，true = 已索赔
    }
    mapping (address => mapping (uint256 => LendInfo)) public userLendInfo;

    function depositLend(uint256 _pid, uint256 _stakeAmount)    external returns(LendInfo memory) {
        LendInfo storage lendInfo = userLendInfo[msg.sender][_pid];
        lendInfo.hasNoClaim = false ;
        lendInfo.hasNoRefund = false ;
        lendInfo.stakeAmount = lendInfo.stakeAmount + _stakeAmount ;
        return lendInfo ;
  } 
}