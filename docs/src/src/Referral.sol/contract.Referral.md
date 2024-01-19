# Referral
[Git Source](https://github.com/unioncredit/union-referral/blob/9b7aa18150da0b45f31e8d5f9fe2f6615f17c4a9/src/Referral.sol)

**Inherits:**
[AccessControl](/src/AccessControl.sol/abstract.AccessControl.md)

This contract allows for the management of referral relationships within the UNION protocol.

*Inherits from the AccessControl contract to utilize role-based permissions.*


## State Variables
### setters
Tracks the authorized entities allowed to set referral relationships.


```solidity
mapping(address => bool) public setters;
```


### referrers
Records referral relationships, mapping each recipient to their referrer.


```solidity
mapping(address => address) public referrers;
```


## Functions
### onlySetter

Ensures the function can only be called by an authorized setter.


```solidity
modifier onlySetter();
```

### constructor

Constructor to set up the initial admin and authorized setter.


```solidity
constructor(address _admin, address initialSetter) AccessControl(_admin);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_admin`|`address`|The initial admin address for the AccessControl base contract.|
|`initialSetter`|`address`|The initial authorized setter.|


### changeSetter

Allows the admin to change the authorization status of a setter.


```solidity
function changeSetter(address setter, bool isAuthorized) external onlyAuth;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`setter`|`address`|The address of the setter whose authorization is to be changed.|
|`isAuthorized`|`bool`|The new authorization status.|


### _setReferrer

*Internal function to set or change a referrer.*


```solidity
function _setReferrer(address recipient, address referrer) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`recipient`|`address`|The address of the recipient for whom the referrer is being set.|
|`referrer`|`address`|The address of the referrer.|


### setReferrer

Allows an authorized setter to set a referrer for a user.


```solidity
function setReferrer(address recipient, address referrer) external onlySetter;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`recipient`|`address`|The address of the recipient for whom the referrer is being set.|
|`referrer`|`address`|The address of the referrer.|


### setSelfReferrer

Allows users to set their own referrer.


```solidity
function setSelfReferrer(address referrer) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`referrer`|`address`|The address of the referrer being set by the user for themselves.|


## Events
### ReferrerChange
Event emitted when a referral relationship is changed.


```solidity
event ReferrerChange(address indexed newReferrer, address indexed oldReferrer);
```

## Errors
### NotSetter
Custom errors for contract-specific revert reasons.


```solidity
error NotSetter();
```

### SelfReferral

```solidity
error SelfReferral();
```

