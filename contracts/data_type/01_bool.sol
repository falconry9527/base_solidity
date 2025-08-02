// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract testbool {
    bool public isOn;
    
    // 切换状态
    function toggle() public {
        isOn = !isOn;
    }

    // 检查状态
    function checkStatus() public view returns (string memory) {
        return isOn ? "The switch is ON" : "The switch is OFF";
    }

}