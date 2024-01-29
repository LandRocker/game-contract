// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.6;

import {IMarketplace} from "./../../marketplace/IMarketplace.sol";
import {MarketPlaceLib} from "./../../marketplace/MarketplaceLib.sol";

/**
 * @title INonMinted1155Marketplace
 * @dev Interface for a marketplace managing non-minted ERC1155 asset sell orders.
 */
interface INonMinted1155MarketplaceUpgraded is IMarketplace {
   // Struct representing a non-minted sell order for an ERC1155 asset.
    struct NonMinted1155Sell {
        MarketPlaceLib.Sell sellData; // Information about the sell order (status, expire date, etc.).
        uint256 listedAmount; // The total amount of the asset listed for sale.
        uint256 sellUnit; // The unit of the asset being sold in each transaction.
        uint256 soldAmount; // The amount of the asset that has been sold.
        uint256 tokenId; // The unique identifier of the ERC1155 asset.
        string tokenSpecs;
    }

    /**
     * @dev Event emitted when a new sell order is created.
     * @param sellId The unique identifier of the sell order.
     * @param creator The address of the user who created the sell order.
     * @param collection The address of the ERC1155 collection.
     * @param expireDate The expiration date of the sell order.
     * @param price The price per unit of the asset.
     * @param listedAmount The total amount of the asset listed for sale.
     * @param sellUnit The unit of the asset being sold in each transaction.
     * @param tokenId The unique identifier of the ERC1155 asset.
     */
    event SellCreated(
        uint256 sellId,
        address creator,
        address collection,
        uint64 expireDate,
        uint256 price,
        uint256 listedAmount,
        uint256 sellUnit,
        uint256 tokenId,
        string tokenSpecs
    );

    /**
     * @dev Event emitted when an existing sell order is updated.
     * @param sellId The unique identifier of the sell order.
     * @param collection The address of the ERC1155 collection.
     * @param expireDate The updated expiration date of the sell order.
     * @param price The updated price per unit of the asset.
     * @param listedAmount The updated total amount of the asset listed for sale.
     * @param sellUnit The updated unit of the asset being sold in each transaction.
     */
    event SellUpdated(
        uint256 sellId,
        address collection,
        uint64 expireDate,
        uint256 price,
        uint256 listedAmount,
        uint256 sellUnit,
        string tokenSpecs
    );

    /**
     * @dev Emitted when a non-minted ERC1155 item is successfully purchased on the marketplace using LRT.
     * @param sellId The unique identifier of the sell order.
     * @param buyer The address of the buyer who purchased the item.
     * @param tokenId The unique identifier of the ERC1155 asset that was purchased.
     * @param sellAmount The amount of the asset that was purchased in this transaction.
     */
    event AssetBought1155WithBalance(
        uint256 sellId,
        address buyer,
        uint256 tokenId,
        uint256 sellAmount,
        uint256 totalPayment
    );

    /**
     * @dev Emitted when a non-minted ERC1155 item is successfully purchased on the marketplace using LRT vesting.
     * @param sellId The unique identifier of the sell order.
     * @param buyer The address of the buyer who purchased the item.
     * @param tokenId The unique identifier of the ERC1155 asset that was purchased.
     * @param sellAmount The amount of the asset that was purchased in this transaction.
     */
    event AssetBought1155WithVesting(
        uint256 sellId,
        address buyer,
        uint256 tokenId,
        uint256 sellAmount,
        uint256 price
    );

    /**
     * @dev initializeNonMinted1155Marketplace the marketplace contract.
     * @param _landRockerERC1155 The address of the LandRockerERC1155 contract.
     * @param _accessRestriction The address of the AccessRestriction contract.
     * @param _lrt The address of the LRT contract.
     * @param _landRocker The address of the LandRocker contract.
     * @param lrtVesting The address of the LRT vesting contract.
     * @param _greeting // grreting
     */
    function initializeNonMinted1155Marketplace(
         address _landRockerERC1155,
        address _accessRestriction,
        address _lrt,
        address _landRocker,
        address lrtVesting,
        string memory _greeting
    ) external;

    /**
     * @dev Creates a new non-minted sell order for an ERC1155 asset.
     * @param _price The price of the asset.
     * @param _expireDate The expiration date of the sell order.
     * @param _listedAmount The total amount of the asset listed for sale.
     * @param _sellUnit The unit of the asset being sold in each transaction.
     */
    function createSell(
        uint256 _price,
        uint64 _expireDate,
        uint256 _listedAmount,
        uint256 _sellUnit,
        string calldata tokenSpecs
    ) external;

    /**
     * @dev Edits an existing non-minted sell order for an ERC1155 asset.
     * @param _sellId The Id of the sell order to be edited.
     * @param _price The updated price of the asset.
     * @param _expireDate The updated expiration date of the sell order.
     * @param _listedAmount The updated total amount of the asset listed for sale.
     * @param _sellUnit The updated unit of the asset being sold in each transaction.
     */
    function editSell(
        uint256 _sellId,
        uint256 _price,
        uint64 _expireDate,
        uint256 _listedAmount,
        uint256 _sellUnit,
        string calldata tokenSpecs
    ) external;

    /**
     * @dev Retrieves detailed information about a non-minted ERC1155 sell order by its unique identifier.
     * This function allows querying information about a specific sell order, including its status, expiration date,
     * listed amount, sell unit, sold amount, and the unique identifier (token Id) of the ERC1155 asset associated with it.
     * @param _sellId The unique identifier of the sell order to retrieve information about.
     * @return sellData A `MarketPlaceLib.Sell` struct containing information about the sell order.
     * @return listedAmount The total amount of the asset listed for sale in the sell order.
     * @return sellUnit The unit of the asset being sold in each transaction within the sell order.
     * @return soldAmount The amount of the asset that has been sold so far in the sell order.
     * @return tokenId The unique identifier (token Id) of the ERC1155 asset associated with the sell order.
     */
    function nonMinted1155Sells(
        uint256 _sellId
    )
        external
        view
        returns (
            MarketPlaceLib.Sell memory sellData,
            uint256 listedAmount,
            uint256 sellUnit,
            uint256 soldAmount,
            uint256 tokenId,
            string calldata tokenSpecs

        );

    function greeting() external view returns(string memory);

}
