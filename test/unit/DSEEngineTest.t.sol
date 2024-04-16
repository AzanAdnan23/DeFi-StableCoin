//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";

import {DSCEngine} from "../../src/DSCEngine.sol";
import {DecentralizedStableCoin} from "../../src/DecentralizedStableCoin.sol";
import {DeployDSC} from "../../script/DeployDSC.s.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {ERC20Mock} from "../mocks/ERC20Mock.sol";

contract DSCEngineTest is Test {
    DSCEngine dsce;
    DecentralizedStableCoin dsc;

    DeployDSC deployer;
    HelperConfig helperConfig;

    address public ethUsdPriceFeed;
    address public btcUsdPriceFeed;
    address public weth;
    address public wbtc;
    uint256 public deployerKey;

    address public USER = makeAddr("Azan");

    uint256 public constant AMOUNT_COLLATERAL = 10 ether;

    function setUp() external {
        deployer = new DeployDSC();

        (dsc, dsce, helperConfig) = deployer.run();

        (ethUsdPriceFeed, btcUsdPriceFeed, weth, wbtc, deployerKey) = helperConfig.activeNetworkConfig();
    }

    /**
     * Price Test
     */
    function testGetUSDValue() public {
        uint256 ethAmount = 20e18;
        uint256 expectedUSD = 40000e18;
        uint256 actualUSD = dsce._getUsdValue(weth, ethAmount);
        assertEq(actualUSD, expectedUSD);
    }

    // deposi collateral tests

    function testRevertsIfCollateralisZero() public {
        vm.startPrank(USER);
        ERC20Mock(weth).approve(address(dsce), AMOUNT_COLLATERAL);

        vm.expectRevert(DSCEngine.DSCEngine__NeedAmountMorethenZero.selector);
        dsce.depositCollateral(weth, 0);
        vm.stopPrank();
    }
}
