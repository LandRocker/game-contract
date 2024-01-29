// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.6;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {CountersUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import {IERC1155Receiver} from "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import {IERC165} from "@openzeppelin/contracts/interfaces/IERC165.sol";

import {ILRTVesting} from "./../../vesting/ILRTVesting.sol";
import {ILandRockerERC1155} from "./../../tokens/erc1155/ILandRockerERC1155.sol";
import {Marketplace} from "./../../marketplace/Marketplace.sol";
import {INonMinted1155MarketplaceUpgraded} from "./INonMinted1155MarketplaceUpgraded.sol";

// import "hardhat/console.sol";

/**
 * @title NonMinted1155Marketplace
 * @dev A contract for managing non-minted ERC1155 asset sell orders.
 * This contract inherits from Marketplace and implements the INonMinted1155Marketplace interface.
 */
contract NonMinted1155MarketplaceUpgraded is
    IERC1155Receiver,
    Marketplace,
    INonMinted1155MarketplaceUpgraded
{
    // Use counters library for incrementing sell Ids
    using CountersUpgradeable for CountersUpgradeable.Counter;

    ILandRockerERC1155 public landRockerERC1155;
    ILRTVesting internal _lrtVesting;


    /**
     * @dev Mapping to store sell for each nonMinted1155 token sell
     */
    mapping(uint256 => NonMinted1155Sell) public override nonMinted1155Sells;

    // Counter for sell Ids
    CountersUpgradeable.Counter private _sellIdCounter;

    string public override greeting;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }


    /**
     * @dev Initializes the contract with necessary addresses.
     * @param _landRockerERC1155 Address of the LandRockerERC1155 contract.
     * @param _accessRestriction Address of the access restriction contract.
     * @param _lrt Address of the LRT token contract.
     * @param _landRocker Address of the LandRocker contract.
     * @param lrtVesting Address of the LRTVesting contract.
     * @param _greeting The greeting message to be displayed on the marketplace.
     */
    function initializeNonMinted1155Marketplace(
        address _landRockerERC1155,
        address _accessRestriction,
        address _lrt,
        address _landRocker,
        address lrtVesting,
        string memory _greeting
    ) external override reinitializer(2) {
        Marketplace.initialize(
            _accessRestriction,
            _lrt,
            _landRocker
        );
        landRockerERC1155 = ILandRockerERC1155(_landRockerERC1155);
        _lrtVesting = ILRTVesting(lrtVesting);

        greeting = _greeting;
    }
 
    /**
     * @dev Creates a new sell order for a non-minted ERC1155 asset.
     * @param _price The price of the asset in LRT tokens.
     * @param _expireDate The expiration date for the sell order.
     * @param _listedAmount The total amount of the asset to be listed for sale.
     * @param _sellUnit The unit of the asset being sold in each transaction.
     * Only administrators can create sell orders.
     */
    function createSell(
        uint256 _price,
        uint64 _expireDate,
        uint256 _listedAmount,
        uint256 _sellUnit,
        string calldata _tokenSpecs
    ) external override onlyAdmin validExpirationDate(_expireDate) {
        _validateSell(_listedAmount, _sellUnit);

        NonMinted1155Sell storage nonMinted1155Sell = nonMinted1155Sells[
            _sellIdCounter.current()
        ];

        uint256 tokenId = landRockerERC1155.safeMint(
            address(this),
            _listedAmount
        );

        //Set the listing to started
        nonMinted1155Sell.sellData.status = 0;
        nonMinted1155Sell.sellData.collection = address(landRockerERC1155);
        nonMinted1155Sell.sellData.expireDate = _expireDate;
        nonMinted1155Sell.sellData.price = _price;
        nonMinted1155Sell.sellUnit = _sellUnit;
        nonMinted1155Sell.listedAmount = _listedAmount;
        nonMinted1155Sell.tokenId = tokenId;
        nonMinted1155Sell.tokenSpecs = _tokenSpecs;

        emit SellCreated(
            _sellIdCounter.current(),
            msg.sender,
            address(landRockerERC1155),
            _expireDate,
            _price,
            _listedAmount,
            _sellUnit,
            tokenId,
            _tokenSpecs
        );

        _sellIdCounter.increment();
    }

    /**
     * @dev Edits an existing sell order for a non-minted ERC1155 asset.
     * @param _sellId The unique identifier of the sell order to be edited.
     * @param _price The updated price of the asset in LRT tokens.
     * @param _expireDate The updated expiration date for the sell order.
     * @param _listedAmount The updated total amount of the asset to be listed for sale.
     * @param _sellUnit The updated unit of the asset being sold in each transaction.
     * Only administrators can edit sell orders.
     */
    function editSell(
        uint256 _sellId,
        uint256 _price,
        uint64 _expireDate,
        uint256 _listedAmount,
        uint256 _sellUnit,
        string calldata _tokenSpecs
    ) external override onlyAdmin validExpirationDate(_expireDate) {
        NonMinted1155Sell storage nonMinted1155Sell = nonMinted1155Sells[
            _sellId
        ];

        //Ensure that the sell is there
        require(
            nonMinted1155Sell.sellData.collection != address(0),
            "NonMinted1155Marketplace::The sell does not exist"
        );

        _validateSell(_listedAmount, _sellUnit);

        //Ensure that the listing is not sold
        require(
            nonMinted1155Sell.sellData.status != 1,
            "NonMinted1155Marketplace::Sold listing NFT cannot be edit"
        );

        // Ensure that the updated listed amount is greater than or equal to the previous amount
        require(
            _listedAmount >= nonMinted1155Sell.listedAmount,
            "NonMinted1155Marketplace::Listed amount is less than already listed amount"
        );

        // Ensure that the updated listed amount is greater than or equal to the previous amount
        if (_listedAmount > nonMinted1155Sell.listedAmount) {
            uint256 mintAmount = _listedAmount - nonMinted1155Sell.listedAmount;
            landRockerERC1155.mint(
                nonMinted1155Sell.tokenId,
                address(this),
                mintAmount
            );
        }

        // Update the sell order information
        nonMinted1155Sell.sellData.status = 0;
        nonMinted1155Sell.sellData.expireDate = _expireDate;
        nonMinted1155Sell.sellData.price = _price;
        nonMinted1155Sell.sellUnit = _sellUnit;
        nonMinted1155Sell.listedAmount = _listedAmount;
        nonMinted1155Sell.tokenSpecs = _tokenSpecs;

        // Emit an event to indicate the sell order has been updated
        emit SellUpdated(
            _sellId,
            address(landRockerERC1155),
            _expireDate,
            _price,
            _listedAmount,
            _sellUnit,
            _tokenSpecs
        );
    }

    /**
     * @dev Cancels a sell order.
     * @param _sellId The unique identifier of the sell order to be canceled.
     * Only administrators can cancel sell orders.
     */
    function cancelSell(uint256 _sellId) external override onlyAdmin {
        NonMinted1155Sell storage nonMinted1155Sell = nonMinted1155Sells[
            _sellId
        ];

        //Ensure that the sell is there
        require(
            nonMinted1155Sell.sellData.collection != address(0),
            "NonMinted1155Marketplace::The sell does not exist"
        );

        //Ensure that the listing is started
        require(
            nonMinted1155Sell.sellData.status == 0,
            "NonMinted1155Marketplace::Cannot cancel active offer"
        );
        //Set the listing to canceled
        nonMinted1155Sell.sellData.status = 2;

        emit SellCanceled(_sellId);
    }

    /**
     * @dev Allows a user to purchase a non-minted ERC1155 asset from the marketplace.
     * @param _sellId The unique identifier of the sell order to be purchased.
     * Only non-admin users can call this function to buy assets.
     */
    function buyItem(uint256 _sellId) external override nonReentrant {
        NonMinted1155Sell storage nonMinted1155Sell = nonMinted1155Sells[
            _sellId
        ];

        //Ensure that the sell is there
        require(
            nonMinted1155Sell.sellData.collection != address(0),
            "NonMinted1155Marketplace::The sell does not exist"
        );

        // Ensure that the total sold units do not exceed the listed amount
        require(
            nonMinted1155Sell.sellUnit + nonMinted1155Sell.soldAmount <=
                nonMinted1155Sell.listedAmount,
            "NonMinted1155Marketplace::Exceed sell limit"
        );

        //Ensure that the listing is started
        require(
            nonMinted1155Sell.sellData.status == 0,
            "NonMinted1155Marketplace::Listed NFT has not valid status"
        );

        // Ensure that the marketplace has sufficient tokens for the purchase
        require(
            landRockerERC1155.balanceOf(
                address(this),
                nonMinted1155Sell.tokenId
            ) >= nonMinted1155Sell.sellUnit,
            "NonMinted1155Marketplace::Insufficient token balance"
        );
        // Check if the sell order has expired
        _checkHasExpired(nonMinted1155Sell.sellData.expireDate);

        uint256 price = nonMinted1155Sell.sellData.price;
        bool hasSufficientBalance = _lrt.balanceOf(msg.sender) >= price;

        // Transfer the LRT tokens from the buyer to the marketplace
        if (hasSufficientBalance) {
            _processTokenPurchase(
                _sellId,
                msg.sender,
                price,
                nonMinted1155Sell
            );
        } else {
            _processVestingPurchase(_sellId, msg.sender, nonMinted1155Sell);
        }

        // Update the sold amount and check if the listing is now sold out
        nonMinted1155Sell.soldAmount += nonMinted1155Sell.sellUnit;

        if (nonMinted1155Sell.soldAmount == nonMinted1155Sell.listedAmount) {
            //Set the listing to sold
            nonMinted1155Sell.sellData.status = 1;
        }

        // Transfer the purchased tokens from the marketplace to the buyer
        landRockerERC1155.safeTransferFrom(
            address(this),
            msg.sender,
            nonMinted1155Sell.tokenId,
            nonMinted1155Sell.sellUnit,
            ""
        );
    }

    /**
     * @dev Allows the admin to withdraw LRT tokens from the marketplace contract.
     * @param _amount The amount of LRT tokens to be withdrawn.
     * Only the admin can call this function to withdraw tokens.
     */
    function withdraw(uint256 _amount) external override onlyAdmin {
        _withdraw(_amount);
    }

    /**
     * @dev Handles the receipt of ERC1155 tokens when they are transferred to this contract.
     * @param operator The address which called `safeTransferFrom` function (i.e., the sender).
     * @param from The address which previously owned the token.
     * @param id The Id of the ERC1155 token being transferred.
     * @param value The amount of tokens being transferred.
     * @param data Additional data with no specified format.
     * @return A bytes4 magic value, indicating ERC1155Receiver compatibility.
     *  See {IERC1155-onERC1155Received}.
     */
    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external pure override returns (bytes4) {
        return this.onERC1155Received.selector;
    }

    /**
     * @dev Handles the receipt of a batch of ERC1155 tokens when they are transferred to this contract.
     * @param operator The address which called `safeBatchTransferFrom` function (i.e., the sender).
     * @param from The address which previously owned the tokens.
     * @param ids An array of Ids for the ERC1155 tokens being transferred.
     * @param values An array of amounts corresponding to the tokens being transferred.
     * @param data Additional data with no specified format.
     * @return A bytes4 magic value, indicating ERC1155Receiver compatibility (0xbc197c81).
     *  See {IERC1155-onERC1155BatchReceived}.
     */
    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external pure override returns (bytes4) {
        return this.onERC1155BatchReceived.selector;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override returns (bool) {
        return
            interfaceId == type(IERC1155Receiver).interfaceId ||
            interfaceId == type(IERC165).interfaceId;
    }

    /**
     * @dev Handles the purchase of a Non-Minted 1155 asset using LRT balance.
     * @param _sellId ID of the sell order.
     * @param _buyer Address of the buyer.
     * @param _price Price of the asset.
     * @param _sellOrder Details of the sell order for a Non-Minted 1155 asset.
     */
    function _processTokenPurchase(
        uint256 _sellId,
        address _buyer,
        uint256 _price,
        NonMinted1155Sell memory _sellOrder
    ) private {
        // Check if the buyer has enough funds
        _checkFund(_price);

        // Transfer LRT tokens from the buyer to the marketplace
        require(
            _lrt.transferFrom(_buyer, address(this), _price),
            "NonMinted1155Marketplace::Unsuccessful transfer"
        );

        // Calculate the total payment after deducting system fees
        uint256 totalPayment = _calculateTotalPayment(_price);

        // Emit an event indicating a successful 1155NFT purchase
        emit AssetBought1155WithBalance(
            _sellId,
            msg.sender,
            _sellOrder.tokenId,
            _sellOrder.sellUnit,
            totalPayment
        );

        // Process the purchase and transfer funds to the marketplace treasury
        _processPurchase(
            _sellOrder.tokenId,
            _sellOrder.sellData.collection,
            totalPayment,
            _landrocker.treasury1155()
        );
    }

    /**
     * @dev Handles the purchase of a Non-Minted 1155 asset using vested LRT balance.
     * @param _sellId ID of the sell order.
     * @param _buyer Address of the buyer.
     * @param sellOrder Details of the sell order for a Non-Minted 1155 asset.
     */
    function _processVestingPurchase(
        uint256 _sellId,
        address _buyer,
        NonMinted1155Sell memory sellOrder
    ) private {
        // Get the vested and claimed amounts from the vesting contract
        (, uint256 vestedAmount, uint256 claimedAmount) = _lrtVesting
            .holdersStat(_buyer);

        // Ensure that the buyer has enough vested balance
        require(
            claimedAmount + sellOrder.sellData.price <= vestedAmount,
            "NonMinted1155Marketplace::Insufficient vested balance"
        );

        // Emit an event indicating a successful 1155NFT purchase
        emit AssetBought1155WithVesting(
            _sellId,
            _buyer,
            sellOrder.tokenId,
            sellOrder.sellUnit,
            sellOrder.sellData.price
        );

        _lrtVesting.setDebt(_buyer, sellOrder.sellData.price);
    }

    /**
     * @dev Validates the parameters for creating or editing a non-minted ERC1155 asset sell order.
     * @param _listedAmount The total amount of the asset listed for sale.
     * @param _sellUnit The unit of the asset being sold in each transaction.
     */
    function _validateSell(
        uint256 _listedAmount,
        uint256 _sellUnit
    ) private pure {
        // Ensure that there are items to sell (listed amount is greater than zero)
        require(
            _listedAmount > 0,
            "NonMinted1155Marketplace::There are not any item to sell"
        );
        // Ensure that at least one item is being sold (sell unit is greater than zero)
        require(
            _sellUnit > 0,
            "NonMinted1155Marketplace::At least one item to sell"
        );
        // Ensure that the listed amount is greater than or equal to the sell unit
        require(
            _listedAmount >= _sellUnit,
            "NonMinted1155Marketplace::Sell unit is larger than listed amount"
        );
        // Ensure that the listed amount is a multiple of the sell unit (divisible without remainder)
        require(
            _listedAmount % _sellUnit == 0,
            "NonMinted1155Marketplace::Listed amount is not a coefficient of sell unit"
        );
    }
}
