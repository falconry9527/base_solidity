pragma solidity >=0.5.0;

contract Owned {
    address payable public owner;

    constructor() public {
        owner = payable(msg.sender);
    }

    function setOwner(address _owner) public virtual {
        owner = payable(_owner);
    }
}

contract Mortal is Owned {
    event SetOwner(address indexed owner);

    function kill() public {
        if (msg.sender == owner) selfdestruct(owner);
    }

    function setOwner(address _owner) public override {
        super.setOwner(_owner); // 调用父合约的 setOwner
        emit SetOwner(_owner);
    }
}