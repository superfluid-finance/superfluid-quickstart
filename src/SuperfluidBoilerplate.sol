// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {SuperTokenV1Library, ISuperToken, ISuperfluid} from "@superfluid-finance/ethereum-contracts/contracts/apps/SuperTokenV1Library.sol";
import {ISuperTokenFactory} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperTokenFactory.sol";
import {PureSuperTokenProxy, IPureSuperToken} from "./PureSuperToken.sol";

contract SuperfluidBoilerplate {
    using SuperTokenV1Library for ISuperToken;

    // Setting up the accepted Super Token of the contract
    ISuperToken public acceptedSuperToken;
    ISuperfluid public host;

    constructor(ISuperfluid _host) {
        host = _host;
    }

    /// @notice Deploys a new mock Super Token for testing purposes
    /// @dev Creates a new PureSuperTokenProxy and initializes it with basic parameters

    function deployMockSuperToken() public {
        acceptedSuperToken = IPureSuperToken(address(new PureSuperTokenProxy()));
        PureSuperTokenProxy(payable(address(acceptedSuperToken))).initialize(
            ISuperTokenFactory(host.getSuperTokenFactory()),
            "Mock Super Token",
            "mST",
            address(this),
            1000000000000000000000000
        );
    }

    /// @notice Creates a new stream of tokens to the caller
    /// @dev Uses SuperTokenV1Library to create a constant flow of tokens
    /// @param flowRate The rate at which tokens should be streamed (tokens per second)

    function setFlowRate(int96 flowRate) public {
        require(flowRate > 0, "Flow rate must be greater than 0");
        require(acceptedSuperToken.balanceOf(address(this)) > 0, "Insufficient balance");
        acceptedSuperToken.flow(msg.sender, flowRate);
    }
}
