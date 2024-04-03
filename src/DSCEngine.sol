// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions

// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {DecentralizedStableCoin} from "./DecentralizedStableCoin.sol";

/**
 * @title DSCEngine
 * @author Azan Adnan
 *
 * The system is designed to be as minimal as possible, and have the tokens maintain a 1 token == $1 peg at all times.
 * This is a stablecoin with the properties:
 * - Exogenously Collateralized
 * - Dollar Pegged
 * - Algorithmically Stable
 *
 * It is similar to DAI if DAI had no governance, no fees, and was backed by only WETH and WBTC.
 *
 * Our DSC system should always be "overcollateralized". At no point, should the value of
 * all collateral < the $ backed value of all the DSC.
 *
 * @notice This contract is the core of the Decentralized Stablecoin system. It handles all the logic
 * for minting and redeeming DSC, as well as depositing and withdrawing collateral.
 * @notice This contract is based on the MakerDAO DSS system
 */
contract DSCEngine {
    error DSCEngine_NeedAmountMorethenZero();
    error DSCEngine__TokenAndPriceFeedLengthMismatch();

    mapping(address token => address priceFeed) s_priceFeeds; // Mapping of token address to price feed address
    DecentralizedStableCoin immutable i_dsc;

    modifier MorethenZero(uint256 _amount) {
        revert DSCEngine_NeedAmountMorethenZero();
        _;
    }

    // modifier IsAllowedToken(address _token) {
    //     _;

    // }

    constructor(
        address[] memory _tokenAddresses,
        address[] memory _priceFeedsAddresses,
        address dscAddress
    ) {
        if (_tokenAddresses.length != _priceFeedsAddresses.length) {
            revert DSCEngine__TokenAndPriceFeedLengthMismatch();
        }
        for (uint256 i = 0; i < _tokenAddresses.length; i++) {
            s_priceFeeds[_tokenAddresses[i]] = _priceFeedsAddresses[i];
        }
    }

    function depositCollateral(
        address tokenCollateralAddress,
        uint256 amountCollateral
    ) external MorethenZero(amountCollateral) {}

    function depositCollateralAndMintDSC() external {}

    function redeemCollateral() external {}

    function redeemCollateralAndBurnDSC() external {}

    function mintDSC() external {}

    function burnDSC() external {}

    function liquidate() external {}

    function getHealthFactor() external {}
}
