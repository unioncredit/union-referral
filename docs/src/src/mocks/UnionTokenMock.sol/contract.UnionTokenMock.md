# UnionTokenMock
[Git Source](https://github.com/unioncredit/union-referral/blob/9b7aa18150da0b45f31e8d5f9fe2f6615f17c4a9/src/mocks/UnionTokenMock.sol)


## State Variables
### totalSupply

```solidity
uint256 public totalSupply;
```


### balanceOf

```solidity
mapping(address => uint256) public balanceOf;
```


### allowance

```solidity
mapping(address => mapping(address => uint256)) public allowance;
```


### name

```solidity
string public name = "UnionMock";
```


### symbol

```solidity
string public symbol = "UNM";
```


### decimals

```solidity
uint8 public decimals = 18;
```


## Functions
### transfer


```solidity
function transfer(address recipient, uint256 amount) external returns (bool);
```

### approve


```solidity
function approve(address spender, uint256 amount) external returns (bool);
```

### transferFrom


```solidity
function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
```

### mint


```solidity
function mint(uint256 amount) external;
```

### burn


```solidity
function burn(uint256 amount) external;
```

### burnFrom


```solidity
function burnFrom(address sender, uint256 amount) external;
```

