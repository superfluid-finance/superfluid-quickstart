// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {SuperfluidVesting} from "../src/SuperfluidVesting.sol";
import {SuperfluidFrameworkDeployer} from "@superfluid-finance/ethereum-contracts/contracts/utils/SuperfluidFrameworkDeployer.t.sol";
import {SuperTokenV1Library, ISuperToken, ISuperfluid} from "@superfluid-finance/ethereum-contracts/contracts/apps/SuperTokenV1Library.sol";
import { ERC1820RegistryCompiled } from "@superfluid-finance/ethereum-contracts/contracts/libs/ERC1820RegistryCompiled.sol";


contract SuperfluidVestingTest is Test {
    SuperfluidVesting private vestingContract;
    SuperfluidFrameworkDeployer.Framework private sf;
    ISuperToken private acceptedSuperToken;
    using SuperTokenV1Library for ISuperToken;

    function setUp() public {
        vm.etch(ERC1820RegistryCompiled.at, ERC1820RegistryCompiled.bin);
        SuperfluidFrameworkDeployer sfDeployer = new SuperfluidFrameworkDeployer();
        sfDeployer.deployTestFramework();
        sf = sfDeployer.getFramework();
    
        vestingContract = new SuperfluidVesting(sf.host);
        acceptedSuperToken = vestingContract.acceptedSuperToken();
    }

    function testSetFlowRate() public {
        vestingContract.setVesting(address(this), 100000000);
        uint256 flowRate = uint256(uint96(acceptedSuperToken.getFlowRate(address(vestingContract), address(this))));
        assertEq(flowRate, uint256(100000000));
    }

}
