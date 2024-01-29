// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.6;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {CountersUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import {IERC721} from "@openzeppelin/contracts/interfaces/IERC721.sol";
import {IERC165} from "@openzeppelin/contracts/interfaces/IERC165.sol";

import {ILandRockerERC721} from "./../../tokens/erc721/ILandRockerERC721.sol";
import {MarketPlaceLib} from "./../../marketplace/MarketplaceLib.sol";
import {ILRTVesting} from "./../../vesting/ILRTVesting.sol";
import {Marketplace} from "./../../marketplace/Marketplace.sol";
import {LandRockerERC721Factory} from "./../../tokens/erc721/LandRockerERC721Factory.sol";
import {INonMinted721MarketplaceUpgraded} from "./INonMinted721MarketplaceUpgraded.sol";

// import "hardhat/console.sol";

/**
 * @title NonMinted721Marketplace
 * @dev A contract for managing non-minted ERC721 asset sell orders.
 * This contract inherits from Marketplace and implements the INonMinted721Marketplace interface.
 */
contract NonMinted721MarketplaceUpgraded is Marketplace, INonMinted721MarketplaceUpgraded {
     using CountersUpgradeable for CountersUpgradeable.Counter;


    ILandRockerERC721 public landRockerERC721;
    LandRockerERC721Factory public landRockerERC721Factory;
    ILRTVesting internal _lrtVesting;

    // Mapping to store sell orders and collections
    mapping(uint256 => NonMinted721Sell) public override nonMinted721Sells;
    // Mapping to store collections and their validity
    mapping(address => bool) public override landrocker721Collections;

    CountersUpgradeable.Counter private _sellIdCounter;

    string public override greeting;

    // Modifier to check if an address is valid (not null)
    modifier validAddress(address _address) {
        require(
            _address != address(0),
            "Minted721Marketplace::Not valid address"
        );
        _;
    }

    // Modifier to check if a collection is valid
    modifier validCollection(address _collection) {
        require(
            landrocker721Collections[_collection],
            "NonMinted721Marketplace::Collection is not active"
        );
        _;
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
     * @dev Initializes the NonMinted721Marketplace contract.
     * @param _landRockerERC721Factory Address of the LandRockerERC721Factory contract.
     * @param _landRockerERC721 Address of the LandRockerERC721 contract.
     * @param _accessRestriction Address of the access restriction contract.
     * @param _lrt Address of the LRT token contract.
     * @param _landRocker Address of the LandRocker contract.
     * @param _lrtVestingAddress Address of the LRT Vesting contract.
     */
    function initializeNonMinted721Marketplace(
        address _landRockerERC721Factory,
        address _landRockerERC721,
        address _accessRestriction,
        address _lrt,
        address _landRocker,
        address _lrtVestingAddress,
        string memory _greeting
    ) external override reinitializer(2) {
        // Initialize the Marketplace contract with access control addresses
        Marketplace.initialize(_accessRestriction, _lrt, _landRocker);
        // Set the LandRocker contracts
        landRockerERC721 = ILandRockerERC721(_landRockerERC721);

        landRockerERC721Factory = LandRockerERC721Factory(
            _landRockerERC721Factory
        );

        _lrtVesting = ILRTVesting(_lrtVestingAddress);
        greeting = _greeting;
    }

    /**
     * @dev Creates a new sell order for non-minted ERC721 assets.
     * @param _itemId unique item id
     * @param _price The price at which the asset is to be sold.
     * @param _collection The address of the ERC721 collection.
     * @param _expireDate The expiration date of the sell order.
     */
    function createSell(
        uint256 _itemId,
        uint256 _price,
        address _collection,
        uint64 _expireDate
    )
        external
        override
        onlyAdmin
        validExpirationDate(_expireDate)
        validCollection(_collection)
    {
        // Get the current sell order
        NonMinted721Sell storage nonMinted721Sell = nonMinted721Sells[
            _sellIdCounter.current()
        ];

        // Set the status to active
        nonMinted721Sell.sellData.status = 0;
        // Assign collection, expire date, and price and item id to the sell order
        nonMinted721Sell.sellData.collection = _collection;
        nonMinted721Sell.sellData.expireDate = _expireDate;
        nonMinted721Sell.sellData.price = _price;
        nonMinted721Sell.itemId = _itemId;


        // Emit an event for the created sell order
        emit SellCreated(
            _sellIdCounter.current(),
            msg.sender,
            _collection,
            _expireDate,
            _price,
            _itemId
        );
        // Increment the sell order counter
        _sellIdCounter.increment();
    }

    /**
     * @dev Edits an existing sell order for non-minted ERC721 assets.
     * @param _sellId The Id of the sell order to be edited.
       @param _itemId unique item id
     * @param _price The updated price at which the asset is to be sold.
     * @param _collection The address of the ERC721 collection.
     * @param _expireDate The updated expiration date of the sell order.
     */
    function editSell(
        uint256 _sellId,
        uint256 _itemId,
        uint256 _price,
        address _collection,
        uint64 _expireDate
    )
        external
        override
        onlyAdmin
        validCollection(_collection)
        validExpirationDate(_expireDate)
    {
        // Get the sell order based on sell Id
        NonMinted721Sell storage nonMinted721Sell = nonMinted721Sells[_sellId];

        //Ensure that the sell is there
        require(
            nonMinted721Sell.sellData.collection != address(0),
            "NonMinted721Marketplace::The sell does not exist"
        );

        // Check that the NFT hasn't been sold
        require(
            nonMinted721Sell.sellData.status != 1,
            "NonMinted721Marketplace::Sold NFT cannot be edit"
        );

        // Update the expire date and price, in addition to setting the sale active
        nonMinted721Sell.sellData.status = 0;
        nonMinted721Sell.sellData.expireDate = _expireDate;
        nonMinted721Sell.sellData.price = _price;
        nonMinted721Sell.itemId = _itemId;

        // Emit an event indicating the edit
        emit SellUpdated(_sellId, _collection, _expireDate, _price, _itemId);
    }

    /**
     * @dev Cancels an active sell order for non-minted ERC721 assets.
     * @param _sellId The Id of the sell order to be canceled.
     */
    function cancelSell(uint256 _sellId) external override onlyAdmin {
        // Retrieve the sell order
        NonMinted721Sell storage nonMinted721Sell = nonMinted721Sells[_sellId];

        //Ensure that the sell is there
        require(
            nonMinted721Sell.sellData.collection != address(0),
            "NonMinted721Marketplace::The sell does not exist"
        );

        // Check if the order is not sold or canceled
        require(
            nonMinted721Sell.sellData.status == 0,
            "NonMinted721Marketplace::Cannot cancel active offer"
        );

        // Check if the order is not sold or canceled
        nonMinted721Sell.sellData.status = 2;

        // Emit an event indicating the cancellation
        emit SellCanceled(_sellId);
    }

    /**
     * @dev Allows a user to purchase a non-minted ERC721 asset from a sell order.
     * @param _sellId The Id of the sell order to be purchased.
     */
    function buyItem(
        uint256 _sellId
    )
        external
        override
        nonReentrant
        validCollection(nonMinted721Sells[_sellId].sellData.collection)
    {
        // Retrieve information about the sell order
        NonMinted721Sell storage nonMinted721Sell = nonMinted721Sells[_sellId];

        //Ensure that the sell is there
        require(
            nonMinted721Sell.sellData.collection != address(0),
            "NonMinted721Marketplace::The sell does not exist"
        );

        // Ensure the sell order is in a valid status (0 indicates an active listing)
        require(
            nonMinted721Sell.sellData.status == 0,
            "NonMinted721Marketplace::Listed NFT has not valid status"
        );

        // Check if the sell order has expired
        _checkHasExpired(nonMinted721Sell.sellData.expireDate);

        uint256 price = nonMinted721Sell.sellData.price;
        bool hasSufficientBalance = _lrt.balanceOf(msg.sender) >= price;

        // Mark the sell order as purchased (status 1 indicates a sold NFT)
        nonMinted721Sell.sellData.status = 1;

        if (hasSufficientBalance) {
            _proccessTokenPurchase(
                _sellId,
                msg.sender,
                price,
                nonMinted721Sell
            );
        } else {
            _processVestingPurchase(
                _sellId,
                msg.sender,
                price,
                nonMinted721Sell
            );
        }
    }

    /**
     * @dev Allows the contract owner to withdraw a specified amount of funds.
     * @param _amount The amount to be withdrawn.
     */
    function withdraw(uint256 _amount) external override onlyAdmin {
        // Call the internal _withdraw function to perform the withdrawal
        _withdraw(_amount);
    }

    /**
     * @dev Sets whether a particular ERC721 collection is considered valid.
     * @param _addr The address of the ERC721 collection contract.
     * @param _isActive A boolean indicating if the collection is active for sell.
     */
    function setLandRockerCollection(
        address _addr,
        bool _isActive
    ) external override onlyAdmin validAddress(_addr) {
        landrocker721Collections[_addr] = _isActive;
        // Emit an event upon successful validation status update.
        emit CollectionAdded(_addr, _isActive);
    }

    /**
     * @dev Processes a token purchase using the buyer's LRT balance.
     * @param _sellId ID of the sell order.
     * @param _buyer Address of the buyer.
     * @param _price Price of the asset.
     * @param _sellOrder Sell order details.
     */
    function _proccessTokenPurchase(
        uint256 _sellId,
        address _buyer,
        uint256 _price,
        NonMinted721Sell memory _sellOrder
    ) private {
        // Check if the buyer has enough funds
        _checkFund(_price);
        // Calculate the total payment after deducting system fees
        uint256 totalPayment = _calculateTotalPayment(_price);

        // Transfer the LRT tokens from the buyer to the marketplace
        require(
            _lrt.transferFrom(_buyer, address(this), _price),
            "NonMinted721Marketplace::Unsuccessful transfer"
        );

        // Transfer the purchased token to the buyer
        uint256 tokenId = ILandRockerERC721(_sellOrder.sellData.collection)
            .safeMint(_buyer);

        // Process the purchase and transfer funds to the marketplace treasury
        _processPurchase(
            tokenId,
            _sellOrder.sellData.collection,
            totalPayment,
            _landrocker.treasury721()
        );

        // Emit an event indicating a successful 721NFT purchase
        emit AssetBought721WithBalance(
            _sellId,
            _buyer,
            _sellOrder.sellData.collection,
            totalPayment,
            tokenId,
            _sellOrder.itemId
        );
    }

    /**
     * @dev Processes a token purchase using the buyer's vested LRT balance.
     * @param _sellId ID of the sell order.
     * @param _buyer Address of the buyer.
     * @param _price Price of the asset.
     * @param _sellOrder Sell order details.
     */
    function _processVestingPurchase(
        uint256 _sellId,
        address _buyer,
        uint256 _price,
        NonMinted721Sell memory _sellOrder
    ) private {
        uint256 vestedAmount = 0;
        uint claimedAmount = 0;
        // Get the vested and claimed amounts from the vesting contract
        (, vestedAmount, claimedAmount) = _lrtVesting.holdersStat(_buyer);

        // Ensure that the buyer has enough vested balance
        require(
            claimedAmount + _price <= vestedAmount,
            "NonMinted721Marketplace::Insufficient vested balance"
        );

        // If the buyer doesn't have enough LRT, set a debt using the vesting contract
        _lrtVesting.setDebt(_buyer, _price);
        // Transfer the purchased token to the buyer
        uint256 tokenId = ILandRockerERC721(_sellOrder.sellData.collection)
            .safeMint(_buyer);

        // Emit an event indicating a successful 721NFT purchase
        emit AssetBought721WithVesting(
            _sellId,
            _buyer,
            _sellOrder.sellData.collection,
            _price,
            tokenId,
            _sellOrder.itemId
        );
    }
}
