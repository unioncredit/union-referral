# UNION-Referral

[![test](https://github.com/unioncredit/union-referral/actions/workflows/test.yml/badge.svg)](https://github.com/unioncredit/union-referral/actions/workflows/test.yml)
[![codecov](https://codecov.io/gh/unioncredit/union-referral/graph/badge.svg?token=F6XWY7TPDB)](https://codecov.io/gh/unioncredit/union-referral)

UNION Referral is a smart contract suite designed to boost the UNION community through a robust referral system. It streamlines community growth by seamlessly integrating access control, referral tracking, and member registration processes.

## Install

To install dependencies:

```
git clone https://github.com/unioncredit/union-referral.git && cd union-referral
yarn install
```

## Test & Run

To install Foundry (assuming a Linux or macOS System):

```
curl -L https://foundry.paradigm.xyz | bash
```

This will download foundryup. To start Foundry, run:

```
foundryup
```

To install dependencies:

```
forge install
```

To run tests:

```
forge test
```

The following modifiers are also available:

-   Level 2 (-vv): Logs emitted during tests are also displayed.
-   Level 3 (-vvv): Stack traces for failing tests are also displayed.
-   Level 4 (-vvvv): Stack traces for all tests are displayed, and setup traces for failing tests are displayed.
-   Level 5 (-vvvvv): Stack traces and setup traces are always displayed.

To profile gas usage:

```
forge test --gas-report
forge snapshot
```

## Deploy

```
forge create --rpc-url <your_rpc_url> \
    --constructor-args <arg1> <arg2> ... \
    --private-key <your_private_key> \
    --etherscan-api-key <your_etherscan_api_key> \
    --verify \
    src/ContractName.sol:ContractName
```

## Verify Contracts

```
forge verify-contract --chain <chain_name> \
    --etherscan-api-key <your_etherscan_api_key> \
    --constructor-args $(cast abi-encode "constructor(arg_type1, arg_type2, ...)" <arg1> <arg2> ... ) \
    <deployed_address> \
    src/ContractName.sol:ContractName
```

## Deployed

**Optimism:**

-   Referral: [0x799FCdDEa2033aaC93AA744ff8AFefe95BC4E5AE](https://optimistic.etherscan.io/address/0x799FCdDEa2033aaC93AA744ff8AFefe95BC4E5AE)
-   RegisterHelper: [0x2683666a3004c553b3a40ed13c32678ed11d9b49](https://optimistic.etherscan.io/address/0x2683666a3004c553b3a40ed13c32678ed11d9b49)

**Optimism-Goerli:**

-   Referral: [0xbae830e2871E339D48912Fb5547808E9e0EE1aaD](https://goerli-optimism.etherscan.io/address/0xbae830e2871E339D48912Fb5547808E9e0EE1aaD)
-   RegisterHelper: [0xC38C2Bb8eD28fb87649DF1e5f02217441b12d49D](https://goerli-optimism.etherscan.io/address/0xC38C2Bb8eD28fb87649DF1e5f02217441b12d49D)

**Base-Sepolia:**

-   Referral: [0xf883722137ECD83a6DB0407D8c1111F4e9950102](https://base-sepolia.blockscout.com/address/0xf883722137ECD83a6DB0407D8c1111F4e9950102)
-   RegisterHelper: [0x4869F1d15772062Dc798bC0CB9A0D97c4e317688](https://base-sepolia.blockscout.com/address/0x4869F1d15772062Dc798bC0CB9A0D97c4e317688)

**Base:**

-   Referral: [0x50fe90134C5C7Baf7a84584655DB093f4D12E6DA](https://basescan.org/address/0x50fe90134c5c7baf7a84584655db093f4d12e6da)
-   RegisterHelper: [0x55D690fFC50F73401D170FbabeFE754f4ee1460E](https://basescan.org/address/0x55d690ffc50f73401d170fbabefe754f4ee1460e)
