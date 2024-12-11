## Superfluid Quickstart : A simple vesting contract

**Superfluid is a token-centric infrastructure protocol for EVM-compatible blockchains, enabling developers to create one-to-one and many-to-manymoney streams (a second-by-second token distribution).**

This project uses [Foundry](https://book.getfoundry.sh/) to build and test a simple vesting contract.

## Usage

Before make sure you have [Foundry](https://book.getfoundry.sh/) installed.

### Install

Installing the dependencies (superfluid-contracts and openzeppelin-contracts)

```shell
$ forge install
```

### Build

Building the project

```shell
$ forge build
```

### Test

Running the tests

```shell
$ forge test
```

### Deploy

Deploying the contract to a live network

```shell
$ forge create --rpc-url <your_rpc_url> \
    --constructor-args <host_address>\
    --private-key <your_private_key> \
    --etherscan-api-key <your_etherscan_api_key> \
    --verify \
    src/SuperfluidVesting.sol:SuperfluidVesting
```

*note: you can find the host address in [The Superfluid Explorer](https://explorer.superfluid.finance/)*
