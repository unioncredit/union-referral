# RegisterHelper
[Git Source](https://github.com/unioncredit/union-referral/blob/9b7aa18150da0b45f31e8d5f9fe2f6615f17c4a9/src/RegisterHelper.sol)

**Inherits:**
[AccessControl](/src/AccessControl.sol/abstract.AccessControl.md)

This contract facilitates user registration and referral in the UNION protocol.

*Extends from the AccessControl contract for role-based permissions.*


## State Variables
### union

```solidity
address public immutable union;
```


### userManager

```solidity
address public immutable userManager;
```


### referral

```solidity
address public immutable referral;
```


### regFeeRecipient

```solidity
address payable public regFeeRecipient;
```


### rebate

```solidity
uint256 public rebate;
```


### regFee

```solidity
uint256 public regFee;
```


## Functions
### constructor

Constructor to initialize the contract with necessary addresses.


```solidity
constructor(
    address _admin,
    address _union,
    address _userManager,
    address _referral,
    address payable _regFeeRecipient,
    uint256 _rebate,
    uint256 _regFee
) AccessControl(_admin);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_admin`|`address`|Address of the initial admin.|
|`_union`|`address`|Address of the UNION token.|
|`_userManager`|`address`|Address of the user manager contract.|
|`_referral`|`address`|Address of the referral contract.|
|`_regFeeRecipient`|`address payable`||
|`_rebate`|`uint256`||
|`_regFee`|`uint256`||


### receive

Fallback receive function to accept ETH.


```solidity
receive() external payable;
```

### setRegFeeRecipient

Sets the recipient for registration fees.


```solidity
function setRegFeeRecipient(address payable newRecipient) external onlyAuth;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`newRecipient`|`address payable`|The address of the new fee recipient.|


### setRebate

Sets the rebate amount.


```solidity
function setRebate(uint256 newRebate) external onlyAuth;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`newRebate`|`uint256`|The new rebate amount.|


### setRegFee

Sets the registration fee amount.


```solidity
function setRegFee(uint256 newRegFee) external onlyAuth;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`newRegFee`|`uint256`|The new registration fee amount.|


### register

Registers a new user, sets their referrer, and handles fees.


```solidity
function register(address newUser, address payable referrer) external payable whenNotPaused;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`newUser`|`address`|The address of the user to be registered.|
|`referrer`|`address payable`|The address of the referrer.|


### claimToken


```solidity
function claimToken(address recipient) external onlyAuth;
```

## Events
### RegFeeRecipientChange
Events for logging state changes and operations.


```solidity
event RegFeeRecipientChange(address newRecipient, address oldRecipient);
```

### RebateChange

```solidity
event RebateChange(uint256 newRebate, uint256 oldRebate);
```

### RegFeeChange

```solidity
event RegFeeChange(uint256 newRegFee, uint256 oldRegFee);
```

### Register

```solidity
event Register(address newUser, address regFeeRecipient, address referrer, uint256 fee, uint256 regFee, uint256 rebate);
```

## Errors
### NotEnoughBalance
Custom errors for specific revert cases.


```solidity
error NotEnoughBalance();
```

### NotEnoughFee

```solidity
error NotEnoughFee(uint256 fee);
```

