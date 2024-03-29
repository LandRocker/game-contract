// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.6;

import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

/**
 * @title ILandRockerERC1155
 * @dev Interface for the LandRockerERC1155 contract, extending the ERC1155 standard.
 */
interface ILandRockerERC1155 is IERC1155 {
    /**
     * @dev Event emitted when the base URI for token metadata is set.
     * @param uri the URI for token metadata
     */
    event BaseUriSet(string uri);
    /**
     * @dev Event emitted when the royalty fee for a receiver is set.
     * @param receiver The address that will receive royalties.
     * @param feeNumerator The percentage of transaction value to collect as royalties.
     */
    event RoyaltySet(address receiver, uint96 feeNumerator);

    /**
     * @dev Event emitted when the default royalty fee is deleted.
     */
    event RoyaltyDeleted();

        /**
     * @dev Emitted when floor price is updated
       @param tokenId  tokenId
     * @param floorPrice New floor price
     */
    event FloorPriceUpdated(uint256 tokenId,uint256 floorPrice);

    /**
     * @dev Mint tokens and assign them to a given address.
     * @param _account Address to receive the minted tokens.
     * @param _amount The amount to mint.
     * @return currentId The Id of the newly minted tokens.
     */
    function safeMint(
        address _account,
        uint256 _amount
    ) external returns (uint256);

    /**
     * @dev Increase the amount of an already minted token.
     * @param _tokenId The Id of the token.
     * @param _to Address to receive the additional tokens.
     * @param _amount The amount to mint.
     */
    function mint(uint256 _tokenId, address _to, uint256 _amount) external;

    /**
     * @dev Set the base URI for token metadata.
     * @param _newUri The new base URI.
     */
    function setBaseURI(string memory _newUri) external;

    /**
     * @dev Set default royalty parameters.
     * @param _receiver The address that will receive royalties.
     * @param _feeNumerator The percentage of transaction value to collect as royalties.
     */
    function setDefaultRoyalty(
        address _receiver,
        uint96 _feeNumerator
    ) external;

    function setFloorPrice(uint256 _tokenId,
        uint256 _floorPrice
    ) external;

    /**
     * @dev Removes default royalty information.
     */
    function deleteDefaultRoyalty() external;

    /**
     * @dev Burn tokens held by a specific address.
     * @param _from Address from which to burn tokens.
     * @param _id The Id of the token.
     * @param _amount The amount to burn.
     */
    function burn(address _from, uint256 _id, uint256 _amount) external;

    /**
     * @dev Check if a token with a given Id exists.
     * @param _tokenId The Id of the token.
     * @return true if the token exists, otherwise false.
     */
    function exists(uint256 _tokenId) external view returns (bool);

    /**
     * @dev Get the URI for a given token Id.
     * @param _tokenId The Id of the token.
     * @return The URI string.
     */
    function uri(uint256 _tokenId) external view returns (string memory);

    /**
     * @dev Returns the floor price
     * @param tokenId The Id of the token.
     * @return The floor price amount.
     */
    function floorPrices(uint256 tokenId) external view returns (uint256);
}
