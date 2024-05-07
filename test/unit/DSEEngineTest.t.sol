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
    uint256 public constant STARTING_USER_ERC20_BALANCE = 10 ether;

    uint256 public constant AMOUNT_COLLATERAL = 10 ether;

    function setUp() external {
        deployer = new DeployDSC();

        (dsc, dsce, helperConfig) = deployer.run();

        (ethUsdPriceFeed, btcUsdPriceFeed, weth, wbtc, deployerKey) = helperConfig.activeNetworkConfig();

        ERC20Mock(weth).mint(USER, STARTING_USER_ERC20_BALANCE);
        ERC20Mock(wbtc).mint(USER, STARTING_USER_ERC20_BALANCE);
    }

    //////////////////////
    // Constructor Tests ////
    //////////////////////

    address[] public tokenAddresses;
    address[] public priceFeedAddresses;

    function testRevertsIfTokenLenghtDoesNotMatchpriceFeeds() public {
        tokenAddresses.push(weth);
        priceFeedAddresses.push(ethUsdPriceFeed);
        priceFeedAddresses.push(btcUsdPriceFeed);

        vm.expectRevert(DSCEngine.DSCEngine__TokenAndPriceFeedLengthMismatch.selector);
        new DSCEngine(tokenAddresses, priceFeedAddresses, address(dsc));
    }

    /////////////
    // Price Test
    ////////////
    function testGetUSDValue() public {
        uint256 ethAmount = 20e18;
        uint256 expectedUSD = 40000e18;
        uint256 actualUSD = dsce._getUsdValue(weth, ethAmount);
        assertEq(actualUSD, expectedUSD);
    }

    function testGetTokenAmountFromUsd() public {
        uint256 usdAmount = 100 ether;
        uint256 expectedWeth = 0.05 ether;

        uint256 actualWeth = dsce.getTokenAmountFromUsd(weth, usdAmount);
        assertEq(actualWeth, expectedWeth);
    }
    //////////////////////
    // deposi collateral tests
    //////////////////////

    function testRevertsIfCollateralisZero() public {
        vm.startPrank(USER);
        ERC20Mock(weth).approve(address(dsce), AMOUNT_COLLATERAL);

        vm.expectRevert(DSCEngine.DSCEngine__NeedAmountMorethenZero.selector);
        dsce.depositCollateral(weth, 0);
        vm.stopPrank();
    }
}
