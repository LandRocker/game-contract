// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.6;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/**
 * @title ILandRockerERC721
 * @dev An interface for ERC721-based tokens with additional functionality.
 */
interface ILandRockerERC721 is IERC721 {
    /**
     * @dev Emitted when the base URI for token metadata is set.
     * @param uri The base URI for token metadata.
     */
    event BaseUriSet(string uri);

    /**
     * @dev Emitted when the royalty fee and recipient address are set.
     * @param receiver The address of the royalty recipient.
     * @param feeNumerator The numerator of the royalty fee.
     */
    event RoyaltySet(address receiver, uint96 feeNumerator);

    event FloorPriceUpdated(uint256 floorPrice);

    /**
     * @dev Event emitted when the default royalty fee is deleted.
     */
    event RoyaltyDeleted();

    /**
     * @dev Safely mints a new token and assigns it to the provided address.
     * @param _to The address to which the new token will be assigned.
     * @return The Id of the newly minted token.
     */
    function safeMint(address _to) external returns (uint256);

    /**
     * @dev Burns (destroys) a token with the specified tokenId.
     * @param _tokenId The Id of the token to be burned.
     */
    function burn(uint256 _tokenId) external;

    /**
     * @dev Sets the base URI for token metadata.
     * @param _baseURI The base URI to set.
     */
    function setBaseURI(string calldata _baseURI) external;

    /**
     * @dev Sets the default royalty fee and recipient address for tokens.
     * @param _receiver The address of the royalty recipient.
     * @param _feeNumerator The numerator of the royalty fee.
     */
    function setDefaultRoyalty(
        address _receiver,
        uint96 _feeNumerator
    ) external;

     function setFloorPrice(uint256 _floorPrice) external ;

    /**
     * @dev Deletes the default royalty fee and recipient address for tokens.
     */
    function deleteDefaultRoyalty() external;

    /**
     * @dev Initializes the ERC721 contract with various parameters.
     * @param _name The name of the ERC721 contract.
     * @param _symbol The symbol of the ERC721 contract.
     * @param _accessRestriction The address of access restriction (if applicable).
     * @param _receiver The address of the royalty recipient.
     * @param _feeNumerator The numerator of the royalty fee.
     * @param _baseURI The base URI for token metadata.
         * @param _floorPrice floor price of collection

     */
    function erc721Init(
        string memory _name,
        string memory _symbol,
        address _accessRestriction,
        address _receiver,
        uint96 _feeNumerator,
        string memory _baseURI,
        uint256 _floorPrice
    ) external;

    /**
     * @dev Checks if a token with the given tokenId exists.
     * @param _tokenId The Id of the token to check.
     * @return A boolean indicating whether the token exists.
     */
    function exists(uint256 _tokenId) external view returns (bool);

    /**
     * @dev Retrieves the URI for a specific token.
     * @param _tokenId The Id of the token.
     * @return The URI for the specified token.
     */
    function uri(uint256 _tokenId) external view returns (string memory);

    /**
     * @dev Returns the base URI for token metadata.
     * @return The base URI for token metadata.
     */
    function tokenBaseURI() external view returns (string memory);

    /**
     * @dev Returns the name of the ERC721 contract.
     * @return The name of the ERC721 contract.
     */
    function tokenName() external view returns (string memory);

    /**
     * @dev Returns the symbol of the ERC721 contract.
     * @return The symbol of the ERC721 contract.
     */
    function tokenSymbol() external view returns (string memory);

      /**
     * @dev Returns floor price of collection
     * @return floor price of collection
     */
    function floorPrice() external view returns (uint256);
}
