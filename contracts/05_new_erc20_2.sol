// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title MyToken
 * @notice ERC20 模板：可增发、可销毁、总量上限、团队锁仓
 * ERC20Capped : 设置最大总量   ERC20Capped(cap)
 * ERC20Burnable : 可销毁 
 * Ownable : 访问控制 Ownable(msg.sender)  
 */
contract MyToken is ERC20Capped,Ownable{
    // 团队锁仓信息
    struct Vesting {
        uint256 amount;
        uint256 start;
        uint256 duration;
        uint256 released;
    }

    mapping(address => Vesting) public vestings;

    event Mint(address indexed to, uint256 amount);
    event Release(address indexed to, uint256 amount);

    /**
     * @param cap 总量上限
     * @param initialSupply 部署者初始分配
     */
    constructor(
        uint256 cap,
        uint256 initialSupply
    )
        ERC20("AAAAAA", "Bbbb")
        ERC20Capped(cap)
        Ownable(msg.sender)      // 设置部署者为初始 owner
    {
        // 初始化给部署者
        _mint(msg.sender, initialSupply);
    }

    /**
     * @notice 增发代币，仅 owner
     */
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
        emit Mint(to, amount);
    }

    /**
     * @notice 设置团队锁仓
     */
    function setTeamVesting(address account, uint256 amount, uint256 start, uint256 duration) external onlyOwner {
        require(account != address(0), "Invalid address");
        require(amount > 0, "Amount must > 0");
        require(duration > 0, "Duration must > 0");
        require(balanceOf(account) == 0 && vestings[account].amount == 0, "Already has vesting");

        vestings[account] = Vesting(amount, start, duration, 0);

        // 锁仓代币 mint 到合约自身
        _mint(address(this), amount);
    }

    /**
     * @notice 释放锁仓代币
     */
    function releaseVested(address account) external {
        Vesting storage v = vestings[account];
        require(v.amount > 0, "No vesting");

        uint256 vested = _vestedAmount(v);
        uint256 unreleased = vested - v.released;
        require(unreleased > 0, "Nothing to release");

        v.released += unreleased;
        _transfer(address(this), account, unreleased);

        emit Release(account, unreleased);
    }

    /**
     * @dev 计算已解锁数量
     */
    function _vestedAmount(Vesting memory v) internal view returns (uint256) {
        if (block.timestamp < v.start) {
            return 0;
        } else if (block.timestamp >= v.start + v.duration) {
            return v.amount;
        } else {
            return (v.amount * (block.timestamp - v.start)) / v.duration;
        }
    }


}
