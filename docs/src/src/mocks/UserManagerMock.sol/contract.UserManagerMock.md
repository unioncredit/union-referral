# UserManagerMock
[Git Source](https://github.com/unioncredit/union-referral/blob/9b7aa18150da0b45f31e8d5f9fe2f6615f17c4a9/src/mocks/UserManagerMock.sol)


## State Variables
### MAX_TRUST_LIMIT

```solidity
uint256 public constant MAX_TRUST_LIMIT = 100;
```


### MAX_STAKE_AMOUNT

```solidity
uint256 public constant MAX_STAKE_AMOUNT = 1000e18;
```


### newMemberFee

```solidity
uint256 public newMemberFee;
```


### totalStaked

```solidity
uint256 public totalStaked;
```


### totalFrozen

```solidity
uint256 public totalFrozen;
```


### isMember

```solidity
bool public isMember;
```


### limit

```solidity
uint256 public limit;
```


### stakerBalance

```solidity
uint256 public stakerBalance;
```


### totalLockedStake

```solidity
uint256 public totalLockedStake;
```


### totalFrozenAmount

```solidity
uint256 public totalFrozenAmount;
```


### stakingToken

```solidity
address public stakingToken;
```


### balances

```solidity
mapping(address => uint256) public balances;
```


### trust

```solidity
mapping(address => mapping(address => uint256)) public trust;
```


## Functions
### constructor


```solidity
constructor(address _stakingToken);
```

### stakers


```solidity
function stakers(address addr) public view returns (bool, uint96, uint96, uint64, uint256, uint256);
```

### batchUpdateTotalFrozen


```solidity
function batchUpdateTotalFrozen(address[] calldata account, bool[] calldata isOverdue) external;
```

### setNewMemberFee


```solidity
function setNewMemberFee(uint256 amount) public;
```

### setIsMember


```solidity
function setIsMember(bool isMember_) public;
```

### checkIsMember


```solidity
function checkIsMember(address) public view returns (bool);
```

### setStakerBalance


```solidity
function setStakerBalance(uint256 stakerBalance_) public;
```

### getStakerBalance


```solidity
function getStakerBalance(address) public view returns (uint256);
```

### setTotalLockedStake


```solidity
function setTotalLockedStake(uint256 totalLockedStake_) public;
```

### getTotalLockedStake


```solidity
function getTotalLockedStake(address) public view returns (uint256);
```

### setCreditLimit


```solidity
function setCreditLimit(uint256 limit_) public;
```

### getCreditLimit


```solidity
function getCreditLimit(address) public view returns (uint256);
```

### getLockedStake


```solidity
function getLockedStake(address staker, address borrower) public view returns (uint256);
```

### getVouchingAmount


```solidity
function getVouchingAmount(address staker, address borrower) public view returns (uint256);
```

### addMember


```solidity
function addMember(address account) public;
```

### updateTrust


```solidity
function updateTrust(address borrower_, uint96 trustAmount) external;
```

### cancelVouch


```solidity
function cancelVouch(address staker, address borrower) external;
```

### registerMember


```solidity
function registerMember(address) public;
```

### stake


```solidity
function stake(uint96 amount) public;
```

### unstake


```solidity
function unstake(uint96 amount) external;
```

### withdrawRewards


```solidity
function withdrawRewards() external;
```

### updateLocked


```solidity
function updateLocked(address borrower, uint256 amount, bool lock) external;
```

### debtWriteOff


```solidity
function debtWriteOff(address staker, address borrower, uint256 amount) public;
```

### onWithdrawRewards


```solidity
function onWithdrawRewards(address staker, uint256 pastBlocks) public returns (uint256, uint256);
```

### onRepayBorrow


```solidity
function onRepayBorrow(address borrower, uint256 pastBlocks) public;
```

### getVoucherCount


```solidity
function getVoucherCount(address borrower) external view returns (uint256);
```

### setEffectiveCount


```solidity
function setEffectiveCount(uint256 effectiveCount) external;
```

### setMaxOverdueTime


```solidity
function setMaxOverdueTime(uint256 maxOverdueTime) external;
```

### setMaxStakeAmount


```solidity
function setMaxStakeAmount(uint96 maxStakeAmount) external;
```

### setUToken


```solidity
function setUToken(address uToken) external;
```

