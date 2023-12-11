//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract UserManagerMock {
    uint256 public constant MAX_TRUST_LIMIT = 100;
    uint256 public constant MAX_STAKE_AMOUNT = 1000e18;

    uint256 public newMemberFee; // New member application fee
    uint256 public totalStaked;
    uint256 public totalFrozen;
    bool public isMember;
    uint256 public limit;
    uint256 public stakerBalance;
    uint256 public totalLockedStake;
    uint256 public totalFrozenAmount;
    address public stakingToken;

    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public trust;

    constructor(address _stakingToken) {
        stakingToken = _stakingToken;
        newMemberFee = 10 ** 18; // Set the default membership fee
    }

    function stakers(address addr) public view returns (bool, uint96, uint96, uint64, uint256, uint256) {
        return (true, uint96(balances[addr]), uint96(0), uint64(0), uint256(0), uint256(0));
    }

    function batchUpdateTotalFrozen(address[] calldata account, bool[] calldata isOverdue) external {}

    function setNewMemberFee(uint256 amount) public {
        newMemberFee = amount;
    }

    function setIsMember(bool isMember_) public {
        isMember = isMember_;
    }

    function checkIsMember(address) public view returns (bool) {
        return isMember;
    }

    function setStakerBalance(uint256 stakerBalance_) public {
        stakerBalance = stakerBalance_;
    }

    function getStakerBalance(address) public view returns (uint256) {
        return stakerBalance;
    }

    function setTotalLockedStake(uint256 totalLockedStake_) public {
        totalLockedStake = totalLockedStake_;
    }

    function getTotalLockedStake(address) public view returns (uint256) {
        return totalLockedStake;
    }

    function setCreditLimit(uint256 limit_) public {
        limit = limit_;
    }

    function getCreditLimit(address) public view returns (uint256) {
        return limit;
    }

    function getLockedStake(address staker, address borrower) public view returns (uint256) {}

    function getVouchingAmount(address staker, address borrower) public view returns (uint256) {}

    function addMember(address account) public {}

    function updateTrust(address borrower_, uint96 trustAmount) external {
        trust[msg.sender][borrower_] = trustAmount;
    }

    function cancelVouch(address staker, address borrower) external {}

    function registerMemberWithPermit(
        address newMember,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public {}

    function registerMember(address newMember) public {}

    function stake(uint96 amount) public {
        balances[msg.sender] += amount;
    }

    function unstake(uint96 amount) external {
        balances[msg.sender] -= amount;
    }

    function withdrawRewards() external {}

    function updateLocked(address borrower, uint256 amount, bool lock) external {}

    //Only supports sumOfTrust
    function debtWriteOff(address staker, address borrower, uint256 amount) public {}

    function onWithdrawRewards(address staker, uint256 pastBlocks) public returns (uint256, uint256) {}

    function onRepayBorrow(address borrower, uint256 pastBlocks) public {}

    function getVoucherCount(address borrower) external view returns (uint256) {}

    function setEffectiveCount(uint256 effectiveCount) external {}

    function setMaxOverdueTime(uint256 maxOverdueTime) external {}

    function setMaxStakeAmount(uint96 maxStakeAmount) external {}

    function setUToken(address uToken) external {}
}
