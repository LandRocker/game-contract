// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.6;

import {ERC1155Supply} from "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import {IERC165} from "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import {CountersUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

import {IAccessRestriction} from "../../access/IAccessRestriction.sol";
import {LandRockerERC2981} from "../../royalty/LandRockerERC2981.sol";
import {ILandRockerERC1155} from "./ILandRockerERC1155.sol";

contract LandRockerERC1155 is
    ERC1155Supply,
    LandRockerERC2981,
    ILandRockerERC1155
{
    // Counter for generating unique token Ids
    using CountersUpgradeable for CountersUpgradeable.Counter;

    // Access control contract reference
    IAccessRestriction public accessRestriction;

    CountersUpgradeable.Counter private _id;

    /**
     * @dev Mapping to store floor prices for each tokenId
     */
    mapping(uint256 => uint256) public override floorPrices;

    /**
     * @dev Indicates a failure with the `operator`’s approval. Used in transfers.
     * @param operator Address that may be allowed to operate on tokens without being their owner.
     * @param owner Address of the current owner of a token.
     */
    error ERC1155MissingApprovalForAll(address operator, address owner);

    /**
     * @dev Reverts if address is invalid
     * @param _addr The address to validate
     */
    modifier validAddress(address _addr) {
        require(_addr != address(0), "LandRockerERC1155::Not valid address");
        _;
    }

    /**
     * @dev Modifier: Only accessible by administrators
     */
    modifier onlyAdmin() {
        accessRestriction.ifAdmin(msg.sender);
        _;
    }

    /**
     * @dev Modifier: Only accessible by approved contracts
     */
    modifier onlyApprovedContract() {
        accessRestriction.ifApprovedContract(msg.sender);
        _;
    }

    /**
     * @dev Reverts if amount is 0
     * @param _amount The amount to validate
     */
    modifier onlyValidAmount(uint256 _amount) {
        require(
            _amount > 0,
            "LandRockerERC1155::Insufficient amount, equal to zero"
        );
        _;
    }

    /**
     * @dev Constructor to initialize the LandRockerERC1155 contract
     * @param _accessRestrictionAddress Address of the access restriction contract
     * @param _receiver is the address that will receive royalties when tokens are traded
     * @param _feeNumerator represents the percentage of the transaction value that will be collected as royalties.
     * @param _baseURI representing the base URI for metadata associated with tokens.
     */
    constructor(
        address _accessRestrictionAddress,
        address _receiver,
        uint96 _feeNumerator,
        string memory _baseURI
    ) ERC1155(_baseURI) {
        accessRestriction = IAccessRestriction(_accessRestrictionAddress);
        _setDefaultRoyalty(_receiver, _feeNumerator);
    }

    /**
     * @dev Mint tokens and assign them to a given address.
     * @param _to Address to receive the minted tokens.
     * @param _amount The amount to mint.
     * @return currentId The Id of the newly minted tokens.
     */
    function safeMint(
        address _to,
        uint256 _amount
    )
        external
        override
        onlyApprovedContract
        validAddress(_to)
        onlyValidAmount(_amount)
        returns (uint256)
    {
        uint256 currentId = _id.current();

        // Mint the specified amount of tokens to the given address
        _mint(_to, currentId, _amount, "");
        // Increment the token Id counter for uniqueness
        _id.increment();

        return currentId;
    }

    /**
     * @dev Increase the amount of an already minted token.
     * @param _tokenId The Id of the token.
     * @param _to Address to receive the additional tokens.
     * @param _amount The amount to mint.
     */
    function mint(
        uint256 _tokenId,
        address _to,
        uint256 _amount
    )
        external
        override
        onlyApprovedContract
        validAddress(_to)
        onlyValidAmount(_amount)
    {
        // Mint the specified amount of tokens to the given address
        _mint(_to, _tokenId, _amount, "");
    }

    /**
     * @dev Burn tokens held by a specific address.
     * @param _from Address from which to burn tokens.
     * @param _tokenId The Id of the token.
     * @param _amount The amount to burn.
     */
    function burn(
        address _from,
        uint256 _tokenId,
        uint256 _amount
    )
        external
        override
        onlyApprovedContract
        validAddress(_from)
        onlyValidAmount(_amount)
    {
        // Burn the specified amount of tokens
        _burn(_from, _tokenId, _amount);

        // Reset the token's royalty
        _resetTokenRoyalty(_tokenId);
    }

    /**
     * @dev Set the base URI for token metadata.
     * @param _baseURI The new base URI.
     */
    function setBaseURI(string memory _baseURI) external override onlyAdmin {
        // Check if the provided base URI is valid
        require(
            bytes(_baseURI).length > 0,
            "LandRockerERC1155::Base URI is invalid"
        );

        // Set the new base URI
        _setURI(_baseURI);

        emit BaseUriSet(_baseURI);
    }

    /**
     * @dev Set default royalty parameters.
     * @param _receiver The address that will receive royalties.
     * @param _feeNumerator The percentage of transaction value to collect as royalties.
     */
    function setDefaultRoyalty(
        address _receiver,
        uint96 _feeNumerator
    ) external override onlyAdmin {
        require(_feeNumerator > 0, "LandRockerERC1155::Royalty fee is invalid");
        require(
            _receiver != address(0),
            "LandRockerERC1155::Not valid address"
        );

        RoyaltyInfo memory royalty = _defaultRoyaltyInfo;

        require(
            _feeNumerator <= royalty.royaltyFraction,
            "LandRockerERC1155::New default lower than previous"
        );

        // Call the internal function to set the default royalty
        _setDefaultRoyalty(_receiver, _feeNumerator);
        // Emit an event to indicate the updated royalty details
        emit RoyaltySet(_receiver, _feeNumerator);
    }

    /**
     * @dev Removes default royalty information.
     */
    function deleteDefaultRoyalty() external override onlyAdmin {
        _deleteDefaultRoyalty();
        // Emit an event to indicate the royalty details has been deleted
        emit RoyaltyDeleted();
    }

    /**
     * @dev set the amount of floor price for each token
     * @param _tokenId The Id of the token.
     * @param _floorPrice The amount to floor price.
     */
    function setFloorPrice(
        uint256 _tokenId,
        uint256 _floorPrice
    ) external override onlyAdmin onlyValidAmount(_floorPrice) {
        floorPrices[_tokenId] = _floorPrice;
        emit FloorPriceUpdated(_tokenId, _floorPrice);
    }

    /**
     * @dev Mint some tokens to the to address - See {IERC1155-supportsInterface}.
     * @param to Address to mint the token to.
     * @param _ids  The Ids being minted.
     * @param  amounts  Amount of tokens to mint given Id.
     * @param data Additional field to pass data to function.
     */
    function mintBatch(
        address to,
        uint256[] memory _ids,
        uint256[] memory amounts,
        bytes memory data
    ) public {
        _mintBatch(to, _ids, amounts, data);
    }

    /**
     * @dev See {IERC1155-safeBatchTransferFrom}.
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory values,
        bytes memory data
    ) public virtual override(IERC1155, ERC1155) {
        address sender = _msgSender();
        if (from != sender && !isApprovedForAll(from, sender)) {
            revert ERC1155MissingApprovalForAll(sender, from);
        }
        _safeBatchTransferFrom(from, to, ids, values, data);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        virtual
        override(LandRockerERC2981, ERC1155, IERC165)
        returns (bool)
    {
        return
            LandRockerERC2981.supportsInterface(interfaceId) ||
            ERC1155.supportsInterface(interfaceId);
    }

    /**
     * @dev Check if a token with a given Id exists.
     * @param _tokenId The Id of the token.
     * @return true if the token exists, otherwise false.
     */
    function exists(
        uint256 _tokenId
    )
        public
        view
        virtual
        override(ERC1155Supply, ILandRockerERC1155)
        returns (bool)
    {
        return ERC1155Supply.exists(_tokenId);
    }

    /**
     * @dev Get the URI for a given token Id.
     * @param _tokenId The Id of the token.
     * @return The URI string.
     */
    function uri(
        uint256 _tokenId
    )
        public
        view
        virtual
        override(ERC1155, ILandRockerERC1155)
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    super.uri(_tokenId),
                    Strings.toString(_tokenId)
                )
            );
    }

    /**
     * @dev Hook executed before any token transfer.
     * @param operator The address that initiates the transfer.
     * @param from The address from which tokens are transferred.
     * @param to The address to which tokens are transferred.
     * @param ids The Ids of the tokens being transferred.
     * @param amounts The amounts of tokens being transferred.
     * @param data Additional data.
     */
    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual override {
        // Implement your logic here
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
