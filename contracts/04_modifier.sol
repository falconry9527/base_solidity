contract ModifierExample {
    // SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract testModifier{

    address public owner;
    constructor() public {
        owner = msg.sender;
    }
    //modifier 主要用于权限控制
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }
    function changeOwner(address newOwner) public onlyOwner {
        owner = newOwner;
    }
}