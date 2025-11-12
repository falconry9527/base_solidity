// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns(bool);
    function transfer(address to, uint256 amount) external returns(bool);
    function balanceOf(address account) external view returns(uint256);
}

contract TwapExecutor {
    struct TwapOrder {
        address user;
        IERC20 tokenIn;
        IERC20 tokenOut;
        uint256 totalAmount;
        uint256 executedAmount;
        uint256 steps;
        uint256 stepAmount;
        uint256 interval;         // seconds between steps
        uint256 lastExecuted;     // timestamp of last execution
        uint256 rewardPerStep;    // gas reward for executor
        bool finished;
    }

    uint256 public nextOrderId;
    mapping(uint256 => TwapOrder) public orders;

    event OrderCreated(uint256 indexed orderId, address indexed user);
    event StepExecuted(uint256 indexed orderId, address indexed executor, uint256 stepAmount, uint256 gasUsed, bool finished);

    // 用户创建 TWAP 订单
    function createOrder(
        IERC20 tokenIn,
        IERC20 tokenOut,
        uint256 totalAmount,
        uint256 steps,
        uint256 interval,
        uint256 rewardPerStep
    ) external payable {
        require(totalAmount > 0 && steps > 0 && interval > 0, "Invalid params");
        require(msg.value == rewardPerStep * steps, "Insufficient reward for all steps");

        uint256 stepAmount = totalAmount / steps;

        orders[nextOrderId] = TwapOrder({
            user: msg.sender,
            tokenIn: tokenIn,
            tokenOut: tokenOut,
            totalAmount: totalAmount,
            executedAmount: 0,
            steps: steps,
            stepAmount: stepAmount,
            interval: interval,
            lastExecuted: block.timestamp - interval, // 可以立即执行第一步
            rewardPerStep: rewardPerStep,
            finished: false
        });

        emit OrderCreated(nextOrderId, msg.sender);
        nextOrderId++;
    }

    // 执行一笔 TWAP 步骤，由机器人调用
    function executeStep(uint256 orderId) external {
        TwapOrder storage order = orders[orderId];
        require(!order.finished, "Order finished");
        require(block.timestamp >= order.lastExecuted + order.interval, "Too early");

        uint256 gasStart = gasleft();

        // ---------------------------
        // 这里调用 Swap 逻辑（示例使用转账模拟）
        // ---------------------------
        uint256 stepAmount = order.stepAmount;
        require(order.tokenIn.balanceOf(order.user) >= stepAmount, "Insufficient balance");

        bool sent = order.tokenIn.transferFrom(order.user, msg.sender, stepAmount);
        require(sent, "Transfer failed");

        // 更新订单状态
        order.executedAmount += stepAmount;
        order.lastExecuted = block.timestamp;
        if(order.executedAmount >= order.totalAmount) {
            order.finished = true;
        }

        // 支付执行奖励
        payable(msg.sender).transfer(order.rewardPerStep);

        uint256 gasUsed = gasStart - gasleft();
        emit StepExecuted(orderId, msg.sender, stepAmount, gasUsed, order.finished);
    }

    // 允许用户取回未使用的奖励（可选）
    function withdrawRemainingReward(uint256 orderId) external {
        TwapOrder storage order = orders[orderId];
        require(msg.sender == order.user, "Not order owner");
        require(order.finished, "Order not finished");

        uint256 totalRewardUsed = order.rewardPerStep * order.steps;
        uint256 remaining = address(this).balance;
        if(remaining > 0) {
            payable(order.user).transfer(remaining);
        }
    }

    // 接收 ETH 作为奖励池
    receive() external payable {}
}
