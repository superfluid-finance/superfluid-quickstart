// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {SuperfluidBoilerplate} from "../src/SuperfluidBoilerplate.sol";
import {SuperfluidFrameworkDeployer} from "@superfluid-finance/ethereum-contracts/contracts/utils/SuperfluidFrameworkDeployer.t.sol";
import {SuperTokenV1Library, ISuperToken, ISuperfluid} from "@superfluid-finance/ethereum-contracts/contracts/apps/SuperTokenV1Library.sol";
import { ERC1820RegistryCompiled } from "@superfluid-finance/ethereum-contracts/contracts/libs/ERC1820RegistryCompiled.sol";


contract SuperfluidBoilerplateTest is Test {
    SuperfluidBoilerplate public boilerplate;
    SuperfluidFrameworkDeployer.Framework public sf;
    ISuperToken public acceptedSuperToken;
    using SuperTokenV1Library for ISuperToken;

    function setUp() public {
        vm.etch(ERC1820RegistryCompiled.at, ERC1820RegistryCompiled.bin);
        SuperfluidFrameworkDeployer sfDeployer = new SuperfluidFrameworkDeployer();
        sfDeployer.deployTestFramework();
        sf = sfDeployer.getFramework();

        boilerplate = new SuperfluidBoilerplate(sf.host);
        boilerplate.deployMockSuperToken();
        acceptedSuperToken = boilerplate.acceptedSuperToken();
    }

    function testSetFlowRate() public {
        boilerplate.setFlowRate(100000000);
        uint256 flowRate = uint256(uint96(acceptedSuperToken.getFlowRate(address(boilerplate), address(this))));
        assertEq(flowRate, uint256(100000000));
    }

}
