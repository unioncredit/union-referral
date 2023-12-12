# UNION-Referral

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

- Level 2 (-vv): Logs emitted during tests are also displayed.
- Level 3 (-vvv): Stack traces for failing tests are also displayed.
- Level 4 (-vvvv): Stack traces for all tests are displayed, and setup traces for failing tests are displayed.
- Level 5 (-vvvvv): Stack traces and setup traces are always displayed.

To profile gas usage:

```
forge test --gas-report
forge snapshot
```
