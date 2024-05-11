// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";

import {DSCEngine} from "../../src/DSCEngine.sol";
import {DecentralizedStableCoin} from "../../src/DecentralizedStableCoin.sol";
import {ERC20Mock} from "../../src/ERC20Mock.sol";

contract Handler is Test {
    DSCEngine dsce;
    DecentralizedStableCoin dsc;
    ERC20Mock weth;
    ERC20Mock wbtc;

    constructor(DSCEngine _dsce, DecentralizedStableCoin _dsc) {
        dsce = _dsce;
        dsc = _dsc;
    }

    function depositCollateral( uint256 collateralSeed, uint256 amountCollateral) public {
        dsce.depositCollateral(collateral, amountCollateral);
    }

    //Hekper Function
    function _getCollateralFromSeed( uint256 collateralSeed) private vieew returns (ERC20Mock)
    {
        if (collateralSeed %2 =)
    }
}
