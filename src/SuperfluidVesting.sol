// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {SuperTokenV1Library, ISuperToken, ISuperfluid} from "@superfluid-finance/ethereum-contracts/contracts/apps/SuperTokenV1Library.sol";
import {ISuperTokenFactory} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperTokenFactory.sol";
import {PureSuperTokenProxy, IPureSuperToken} from "./PureSuperToken.sol";

/// @title SuperfluidVesting
/// @notice A contract for managing token vesting using Superfluid streams
/// @dev Uses SuperTokenV1Library for handling Superfluid token operations
contract SuperfluidVesting {
    using SuperTokenV1Library for ISuperToken;

    /// @notice The Super Token that will be used for vesting
    ISuperToken public acceptedSuperToken;
    /// @notice The Superfluid protocol host contract
    ISuperfluid public host;
    /// @notice The address of the contract owner
    address public owner;

    /// @notice Restricts function access to contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    /// @notice Initializes the vesting contract
    /// @param _host The address of the Superfluid host contract
    /// @dev Assigns the host and owner addresses
    /// Creates a new PureSuperToken and initializes it with mock data
    /// Mints the total supply of the token to the contract
    constructor(ISuperfluid _host) {
        host = _host;
        owner = msg.sender;
        acceptedSuperToken = IPureSuperToken(address(new PureSuperTokenProxy()));
        PureSuperTokenProxy(payable(address(acceptedSuperToken))).initialize(
            ISuperTokenFactory(host.getSuperTokenFactory()),
            "Mock Super Token",
            "mST",
            address(this),
            1000000000000000000000000
        );
    }

    /// @notice Creates or updates a vesting stream for a recipient
    /// @param recipient The address that will receive the stream
    /// @param flowRate The rate at which tokens will be streamed (tokens per second)
    /// @dev Flow rate must be positive and contract must have sufficient balance
    function setVesting(address recipient, int96 flowRate) public onlyOwner {
        require(flowRate > 0, "Flow rate must be greater than 0");
        require(acceptedSuperToken.balanceOf(address(this)) > 0, "Insufficient balance");
        acceptedSuperToken.flow(recipient, flowRate);
    }
}
