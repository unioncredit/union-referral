# AccessControl
[Git Source](https://github.com/unioncredit/union-referral/blob/9b7aa18150da0b45f31e8d5f9fe2f6615f17c4a9/src/AccessControl.sol)

This contract provides basic access control with an admin role, pause functionality, and pending admin transfer.

*The contract uses role-based permissioning for administrative actions and pausing functionality.*


## State Variables
### admin
Address of the current admin


```solidity
address public admin;
```


### pendingAdmin
Address of the pending admin, to be accepted as new admin


```solidity
address public pendingAdmin;
```


### paused
Indicates whether the contract is paused


```solidity
bool public paused;
```


## Functions
### onlyAuth

Ensures only the admin can perform certain actions


```solidity
modifier onlyAuth();
```

### whenNotPaused

Ensures certain actions can only be performed when the contract is not paused


```solidity
modifier whenNotPaused();
```

### whenPaused

Ensures certain actions can only be performed when the contract is paused


```solidity
modifier whenPaused();
```

### constructor

Constructor to set the initial admin of the contract


```solidity
constructor(address _admin);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_admin`|`address`|The initial admin address|


### setPendingAdmin

Sets a new pending admin

*Can only be called by the current admin*


```solidity
function setPendingAdmin(address newAdmin) public onlyAuth;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`newAdmin`|`address`|The address of the proposed new admin|


### acceptAdmin

Accepts the role of admin by the pending admin

*Transfers the admin role from the current admin to the pending admin*


```solidity
function acceptAdmin() public;
```

### pause

Pauses the contract

*Can only be called by the current admin when the contract is not paused*


```solidity
function pause() external onlyAuth whenNotPaused;
```

### unpause

Unpauses the contract

*Can only be called by the current admin when the contract is paused*


```solidity
function unpause() external onlyAuth whenPaused;
```

## Events
### AdminChange
Events for logging state changes


```solidity
event AdminChange(address newAdmin, address oldAdmin);
```

### Pause

```solidity
event Pause(address account);
```

### Unpause

```solidity
event Unpause(address account);
```

## Errors
### HasPaused
Custom errors for contract-specific revert reasons


```solidity
error HasPaused(bool _paused);
```

### NullAddress

```solidity
error NullAddress();
```

### NotAdmin

```solidity
error NotAdmin();
```

### NotPendingAdmin

```solidity
error NotPendingAdmin();
```

