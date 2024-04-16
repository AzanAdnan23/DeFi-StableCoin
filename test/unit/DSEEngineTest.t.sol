//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";

import {DSCEngine} from "../../src/DSCEngine.sol";
import {DecentralizedStableCoin} from "../../src/DecentralizedStableCoin.sol";
import {DeployDSC} from "../../script/DeployDSC.s.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract DSCEngineTest is Test {
    DSCEngine dsce;
    DecentralizedStableCoin dsc;

    DeployDSC deployer;
    HelperConfig helperConfig;
    address ethUsdPriceFeed;
    address weth;

    function setUp() public {
        deployer = new DeployDSC();

        (dsc, dsce,helperConfig) = deployer.run();
    }

    /**
     * Price Test
     */

    function testGetUSDValue() 
}
