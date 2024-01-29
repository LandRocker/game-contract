// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.6;

import {IMarketplace} from "./../../marketplace/IMarketplace.sol";
import {MarketPlaceLib} from "./../../marketplace/MarketplaceLib.sol";

/**
 * @title INonMinted721Marketplace interface
 * @dev This interface defines the functions and events for a non-minted721 NFT marketplace.
 */
interface INonMinted721MarketplaceUpgraded is IMarketplace {
   // Struct representing a non-minted sell order for an ERC1155 asset.
    struct NonMinted721Sell {
        MarketPlaceLib.Sell sellData; // Information about the sell order (status, expire date, etc.).
        uint256 itemId; //unique item id
    }
    /**
     * @dev Emitted when a new non-minted721 NFT listing is created in the marketplace.
     * @param sellId The unique identifier of the listing.
     * @param creator The address of the listing creator.
     * @param collection The address of the NFT collection contract.
     * @param expireDate The expiration date of the listing.
     * @param price The price of the NFT.
       @param itemId; unique item id

     */
    event SellCreated(
        uint256 sellId,
        address creator,
        address collection,
        uint64 expireDate,
        uint256 price,
        uint256 itemId
    );
    /**
     * @dev Emitted when an existing non-minted721 NFT listing is updated in the marketplace.
     * @param sellId The unique identifier of the listing.
     * @param collection The address of the NFT collection contract.
     * @param expireDate The new expiration date of the listing.
     * @param price The new price of the NFT.
       @param itemId unique item id

     */
    event SellUpdated(
        uint256 sellId,
        address collection,
        uint64 expireDate,
        uint256 price,
        uint256 itemId
    );

    /**
     * @dev Emitted when a new NFT collection is added to the marketplace.
     * @param collection The address of the NFT collection.
     * @param isActive A boolean indicating if the collection is active for sell.

     */
    event CollectionAdded(address collection, bool isActive);

    /**
     * @dev Emitted when an asset is successfully bought with LRT balance.
     * @param sellId ID of the sell order.
     * @param buyer Address of the buyer.
     * @param collection Address of the token collection.
     * @param sellAmount Amount paid for the purchase.
     * @param tokenId ID of the purchased token.
       @param itemId unique item id

     */
    event AssetBought721WithBalance(
        uint256 sellId,
        address buyer,
        address collection,
        uint256 sellAmount,
        uint256 tokenId,
        uint256 itemId
    );

    /**
     * @dev Emitted when an asset is successfully bought with vested LRT balance.
     * @param sellId ID of the sell order.
     * @param buyer Address of the buyer.
     * @param collection Address of the token collection.
     * @param sellAmount Amount paid for the purchase.
     * @param tokenId ID of the purchased token.
       @param itemId unique item id

     */
    event AssetBought721WithVesting(
        uint256 sellId,
        address buyer,
        address collection,
        uint256 sellAmount,
        uint256 tokenId,
        uint256 itemId
    );

    /**
     * @dev Initializes the marketplace contract.
     * @param _landRockerERC1155 The address of the LandRockerERC1155 contract.
     * @param _accessRestriction The address of the AccessRestriction contract.
     * @param _lrt The address of the LRT contract.
     * @param _lrtDistributorAddress The address of the LRT distributor.
     * @param _landRocker The address of the LandRocker contract.
     * @param _lrtVestingAddress The address of the LRT vesting contract.
     */
    function initializeNonMinted721Marketplace(
        address _landRockerERC1155,
        address _accessRestriction,
        address _lrt,
        address _lrtDistributorAddress,
        address _landRocker,
        address _lrtVestingAddress,
         string memory _greeting

    ) external;

    /**
     * @dev Create a new non-minted721 NFT listing in the marketplace.
     * @param _itemId unique item id
     * @param _price The price of the NFT.
     * @param _collection The address of the NFT collection contract.
     * @param _expireDate The expiration date of the listing.
     */
    function createSell(
        uint256 _itemId,
        uint256 _price,
        address _collection,
        uint64 _expireDate
    ) external;

    /**
     * @dev Update an existing non-minted721 NFT listing in the marketplace.
     * @param _sellId The unique identifier of the listing to be updated.
       @param _itemId unique item id
     * @param _price The new price of the NFT.
     * @param _collection The address of the NFT collection contract.
     * @param _expireDate The new expiration date of the listing.
     */
    function editSell(
        uint256 _sellId,
        uint256 _itemId,
        uint256 _price,
        address _collection,
        uint64 _expireDate
    ) external;

    /**
     * @dev Set whether a specific NFT collection is considered a valid non-minted721 collection in the marketplace.
     * @param _addr The address of the NFT collection contract.
     * @param _isActive A boolean indicating whether the collection is valid or not.
     */
    function setLandRockerCollection(address _addr, bool _isActive) external;

    /**
     * @dev Check if a specific NFT collection is considered valid for non-minted721 listings in the marketplace.
     * @param _collection The address of the NFT collection contract.
     * @return A boolean indicating if the collection is valid or not.
     */
    function landrocker721Collections(
        address _collection
    ) external view returns (bool);

    /**
     * @dev Retrieve information about a specific non-minted721 NFT listing.
     * @param _listId The unique identifier of the listing.
     * @return sellData A `MarketPlaceLib.Sell` struct containing information about the sell order.
       @return itemId unique item id
     */
    function nonMinted721Sells(
        uint256 _listId
    )
        external
        view
        returns (
            MarketPlaceLib.Sell memory sellData,
            uint256 itemId
        );

    function greeting() external view returns(string memory);
}
