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

## Deployed

```
optimism-goerli
```

Referral: 0x40006f57bf781be997da9c096668579a044f140a
RegisterHelper: 0x1f506d05c3ab917610a2bd4ed4e7afbdb4ebecc1

```

```
