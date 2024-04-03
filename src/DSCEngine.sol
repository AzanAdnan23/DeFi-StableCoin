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
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

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
contract DSCEngine is ReentrancyGuard {
    error DSCEngine__NeedAmountMorethenZero();
    error DSCEngine__TokenAndPriceFeedLengthMismatch();
    error DSCEngine__TokenNotSupported();
    error DSCEngine__TransferFailed();

    ///////////////////
    // State Variables //
    ///////////////////

    mapping(address token => address priceFeed) s_priceFeeds; // Mapping of token address to price feed address

    /// @dev Amount of collateral deposited by user
    mapping(address user => mapping(address collateralToken => uint256 amount)) private s_collateralDeposited;

    DecentralizedStableCoin private immutable i_dsc;

    ///////////////////
    // Events
    ///////////////////
    event CollateralDeposited(address indexed user, address indexed token, uint256 indexed amount);
    event CollateralRedeemed(address indexed redeemFrom, address indexed redeemTo, address token, uint256 amount); // if redeemFrom != redeemedTo, then it was liquidated

    ///////////////////
    // Modifiers
    ///////////////////
    modifier MorethenZero(uint256 _amount) {
        revert DSCEngine__NeedAmountMorethenZero();
        _;
    }

    modifier IsAllowedToken(address _token) {
        if (s_priceFeeds[_token] == address(0)) {
            revert DSCEngine__TokenNotSupported();
        }
        _;
    }

    ///////////////////
    // Functions
    ///////////////////
    constructor(address[] memory _tokenAddresses, address[] memory _priceFeedsAddresses, address dscAddress) {
        if (_tokenAddresses.length != _priceFeedsAddresses.length) {
            revert DSCEngine__TokenAndPriceFeedLengthMismatch();
        }
        for (uint256 i = 0; i < _tokenAddresses.length; i++) {
            s_priceFeeds[_tokenAddresses[i]] = _priceFeedsAddresses[i];
        }
        i_dsc = DecentralizedStableCoin(dscAddress);
    }

    function depositCollateral(address _tokenCollateralAddress, uint256 _amountCollateral)
        external
        MorethenZero(_amountCollateral)
        IsAllowedToken(_tokenCollateralAddress)
        nonReentrant
    {
        s_collateralDeposited[msg.sender][_tokenCollateralAddress] += _amountCollateral;
        emit CollateralDeposited(msg.sender, _tokenCollateralAddress, _amountCollateral);

       bool sucess IERC20(_tokenCollateralAddress).transferFrom(msg.sender, address(this), _amountCollateral);
        if(!sucess){
           revert DSCEngine__TransferFailed();
        }
    }

    function depositCollateralAndMintDSC() external {}

    function redeemCollateral() external {}

    function redeemCollateralAndBurnDSC() external {}

    function mintDSC() external {}

    function burnDSC() external {}

    function liquidate() external {}

    function getHealthFactor() external {}
}
