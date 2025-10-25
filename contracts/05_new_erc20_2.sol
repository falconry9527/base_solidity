// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title MyToken
 * @notice ERC20 模板：可增发、可销毁、总量上限、团队锁仓
 */
contract MyToken is ERC20Capped, ERC20Burnable,Ownable{
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

    // 必须显式 override 列出所有含有 _update 的基类
    // ERC20Capped ,每次 mint的时候，会检查最大总量
    function _update(address from, address to, uint256 value) internal virtual override(ERC20, ERC20Capped) {
        // 通常直接调用 super 即可（遵循C3线性化）
        super._update(from, to, value);
        // 如果需要在这里加额外逻辑可以加，但注意不要重复调用基类导致双重副作用
    }
}
