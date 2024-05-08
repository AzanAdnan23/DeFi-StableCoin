// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";

import {DeployDSC} from "../../script/DeployDSC.s.sol";
import {DSCEngine} from "../../src/DSCEngine.sol";
import {DecentralizedStableCoin} from "../../src/DecentralizedStableCoin.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract InvariantsTest is StdInvariant, Test {
    DSCEngine dsce;
    DecentralizedStableCoin dsc;
    DeployDSC deployer;
    HelperConfig helperConfig;

    function setUp() external {}
}
