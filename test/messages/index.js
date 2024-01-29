const AccessErrorMsg = {
  CALLER_NOT_OWNER: "AR::caller is not owner",
  CALLER_NOT_ADMIN: "AR::caller is not admin",
  CALLER_NOT_DISTRIBUTOR: "AR::caller is not distributor",
  CALLER_NOT_VESTING_MANAGER: "AR::caller is not vesting manager",

  CALLER_NOT_APPROVED_CONTRACT: "AR::caller is not approved contract",
  CALLER_NOT_SCRIPT: "AR::caller is not script",
  CALLER_NOT_WERT: "AR::caller is not wert",

  PAUSEABLE_PAUSED: "AR::Pausable: paused",
  PAUSEABLE_NOT_PAUSED: "AR::Pausable: not paused",

  CALLER_NOT_OWNER_OR_ADMIN: "AR::caller is not admin or owner",
  CALLER_NOT_ADMIN_OR_APPROVED_CONTRACT:
    "AR::caller is not admin or approved contract",
  CALLER_NOT_ADMIN_OR_SCRIPT: "AR::caller is not admin or script",
};

const LRTErrorMsg = {
  LRT_MAX_SUPPLY: "LRT::Max supply exceeded",
  LRT_BURN_LIMIT: "LRT::Burn amount exceeds balance",
  LRT_TOO_LOW_AMOUNT: "LRT::Insufficient amount:equal to zero",
  INSUFFICIENT_BALANCE: "LRT::Insufficient balance",
  INVALID_DEST: "LRT::LRT can't transfer to owner",
};

const LRTDistroErrorMsg = {
  POOL_INSUFFICIENT_BALANCE: "LRTDistributor::The pool has not enough balance",
  INVALID_ADDRESS: "LRTDistributor::Not valid address",
  NOT_VALID_DESTINATION: "LRTDistributor::LRT cannot transfer to distributor",
};

const LRTVestingErrorMsg = {
  INVALID_CLIFF: "LRTVesting::Cliff priod is invalid",
  ZERO_DURATION: "LRTVesting::Duration is not seted",
  PLAN_IS_NOT_EXIST: "LRTVesting::Plan is not exist",
  LOW_AMOUNT: "LRTVesting::Amount is too low",
  REVOKED_BEFORE: "LRTVesting::Your vesting are revoked",

  INSUFFICIENT_BALANCE: "LRTVesting::Not sufficient tokens",
  INVALID_START_DATE: "LRTVesting::StartDate is not valid",
  INVALID_START_DATE_VESTING:
    "LRTVesting::createVesting:StartDate is not valid",

  LOW_DURATION: "LRTVesting::Duration is too low",
  START2: "LRTVesting::StartDate is not valid2",
  INVALID_UNLOCK_DATE: "LRTVesting::UnlockDate is not valid",
  ZERO_CLAIMABLE_AMOUNT: "LRTVesting::Not enough vested tokens",
  NO_VESTING: "LRTVesting::No vesting",
  NOT_REVOCABLE: "LRTVesting:Vesting is not revocable",
  NOT_VALID_ADDRESS: "LRTVesting::Not valid address",
  DEBT_LIMIT_EXCEED: "LRTVesting::Debt limit Exceeded",
  INSUFFICIENT_CONTRACT_BALANCE: "LRTVesting::Insufficient contract balance",
};

const SaleErrorMsg = {
  LIMIT_EXCEED: "PreSale::LRT limit Exceeded",
  TIME_EXCEED: "PreSale::Sale time is over",
  DAILY_LIMIT: "LRTPreSale::You've reached the daily buying limit",
  ELIGBLE_ADDRESS: "PreSale::You are not eligible",
  TOO_LOW_AMOUNT: "PreSale::Insufficient amount:Below minLrtPerUser",
  NOT_SUPPORTED_STABLE_COIN: "PreSale::Stable Coin is not Supported",
  NOT_VALID_ADDRESS: "PreSale::Not valid address",
  NOT_ELIGBLE_ADDRESS: "PreSale::Address is not eligible",
  PRICE_TOO_OLD: "PreSale::Price too old",
  NOT_ENABLED: "PreSale::Does not enable",
  NOT_VALID_STABLECOIN: "PreSale::_stableCoin address is not valid",
  VALID_AMOUNT: "PreSale::Insufficient amount:equal to zero",
  INSUFFICIENT_BALANCE: "PreSale::insufficient balance",
  ALLOWANCE_ERROR: "PreSale::allowance error",
  TOKEN_NOT_EXIST: "PreSale::payment token is not valid",
  USER_BALANCE_LIMIT: "PreSale::You've reached the max lrt amount",
  SALE_NOT_ACTIVE: "LRTPreSale::sale is not active",
};

const LRMessage = {
  INVALID_SYSTEM_FEE: "LandRocker::Invalid system fee",
  INVALID_Address: "LandRocker::Not valid address",
};

const LR721Message = {
  INVALID_URI: "LandRockerERC721::Base URI is invalid",
  NOTHING_SET: "LandRockerERC721::No default royalty set",
  INVALID_FEE: "LandRockerERC721::New default lower than previous",
  NOT_VALID_ADDRESS: "LandRockerERC721::Not valid address",
  IN_VALID_FEES: "LandRockerERC721::Royalty fee is invalid",
  DOUBLE_INITIALIZER_CALL: "Initializable:Contract is already initialized",
};

const LR1155Message = {
  INVALID_URI: "LandRockerERC1155::Base URI is invalid",
  INVALID_FEE: "LandRockerERC1155::Royalty fee is invalid",
  IN_VALID_FEE: "LandRockerERC1155::New default lower than previous",
  NOT_VALID_ADDRESS: "LandRockerERC1155::Not valid address",
  LOW_AMOUNT: "LandRockerERC1155::Insufficient amount, equal to zero",
  INSUFFICIENT_BALANCE: "LandRockerERC1155::Insufficient balance to burn",
};

const MarketplaceErrorMsg = {
  INVALID_ADDRESS: "Marketplace::Invalid address",
  INVALID_EXPIRE_DATE: "Marketplace::Expiration date is invalid",
  SALE_HAS_EXPIRED: "Marketplace::The sale has expired",

  //CANCEL
  CANCEL_ACTIVE: "Marketplace::Cannot cancel active offer",
  CANCEL_OFFER_NOT_OWNER: "Marketplace::You are not owner",
  //LIST NFT
  INVALID_TOKEN_TYPE: "Marketplace::Invalid tokenType",
  INVALID_URI: "Marketplace::Invalid URI",
  INVALID_NFT_ADDRESS: "Marketplace::nftAddress is invalid",
  INVALID_BATCH_AMOUNT: "Marketplace::At least one item to sell",
  INVALID_PAYMENT_TOKEN: "Marketplace::Invalid paymentToken",
  NOT_OWNER_LIST_NFT_721: "Marketplace::You are not owner",
  MARKETPLACE_LIST_NFT_PERMISSION_721:
    "Marketplace::Marketplace has not access",
  MARKETPLACE_LIST_NFT_PERMISSION_1155:
    "Marketplace::Marketplace has not access",
  NOT_ENOUGH_BALANCE_LIST_NFT_1155:
    "Marketplace::You do not have enough balance",

  //BUY ITEM BY TOKEN
  ALLOWANCE: "Marketplace::Allowance error",
  INSUFFICIENT_BALANCE: "Marketplace::Insufficient balance",
  UNSUCCESSFUL_TRANSFER_BUY_ITEM: "Marketplace::Unsuccessful transfer",

  //WITHDRAW BALANCE
  TOO_LOW_AMOUNT: "Marketplace::Insufficient amount, equal to zero",
  NO_BALANCE_WITHDRAW: "Marketplace::No balance to withdraw",
  INVALID_ADMIN_WALLET: "Marketplace::Invalid admin wallet",
  UNSUCCESSFUL_TRANSFER_WITHDRAW: "Marketplace::Unsuccessful transfer",

  //TRANSFER TO BUYER
  NOT_OWNER_TRANSFER_721: "Marketplace::You are not owner",
  MARKETPLACE_TRANSFER_PERMISSION_721:
    "Marketplace::Marketplace has not access",
  MARKETPLACE_TRANSFER_PERMISSION_1155:
    "Marketplace::Marketplace has not access",
  NOT_ENOUGH_BALANCE_TRANSFER_1155:
    "Marketplace::You do not have enough balance",

  // HANDLE BACK TOKEN
  NOT_REVOKED_721: "Marketplace::Marketplace approve are not revoked",
  NOT_REVOKED_1155: "Marketplace::Marketplace approve are not revoked",
};

const NonMinted1155ErrorMsg = {
  SELL_UNIT_IS_LARGER:
    "NonMinted1155Marketplace::Sell unit is larger than listed amount",
  INVALID_LISTED_AMOUNT:
    "NonMinted1155Marketplace::There are not any item to sell",
  INVALID_SELL_UNIT: "NonMinted1155Marketplace::At least one item to sell",
  SOLD_NFT: "NonMinted1155Marketplace::Sold listing NFT cannot be edit",
  EXCEED_SELL: "NonMinted1155Marketplace::Exceed sell limit",
  INVALID_STATUS_TO_SELL:
    "NonMinted1155Marketplace::Listed NFT has not valid status",
  ACTIVE_ORDER: "NonMinted1155Marketplace::Cannot cancel active offer",
  INSUFFICIENT_TOKEN_BALANCE:
    "NonMinted1155Marketplace::Insufficient token balance",
  NOT_COEFFICIENT_OF_SELL_UNIT:
    "NonMinted1155Marketplace::Listed amount is not a coefficient of sell unit",
  LOW_LISTED_AMOUNT:
    "NonMinted1155Marketplace::Listed amount is less than already listed amount",
  INVALID_SELL: "NonMinted1155Marketplace::The sell does not exist",
  INSUFFICIENT_VESTED_BALANCE:
    "NonMinted1155Marketplace::Insufficient vested balance",
};

const Minted1155ErrorMsg = {
  INSUFFICIENT_BALANCE: "Minted1155Marketplace::You do not have enough balance",
  HAS_NOT_ACCESS: "Minted1155Marketplace::Marketplace has not access",
  INVALID_QUANTITY: "Minted1155Marketplace::At least one item to sell",
  NOT_NFT_OWNER: "Minted1155Marketplace::You are not owner",
  CAN_NOT_EDIT: "Minted1155Marketplace::listing NFT cannot be edit",
  EXCEED_SELL: "Minted1155Marketplace::Exceed sell limit",
  INVALID_STATUS_TO_SELL: "Minted1155Marketplace::Sell has invalid status",
  NOT_REVOKED: "Minted1155Marketplace::Marketplace approve are not revoked",
  NOT_OWNER_CANCEL: "Minted1155Marketplace::You are not owner",
  SOLD_SELL: "Minted1155Marketplace::Cannot cancel sold NFT",
  INSUFFICIENT_TOKEN_BALANCE:
    "Minted1155Marketplace::Insufficient token balance",
  UNSUCCESSFUL_TRANSFER: "Minted1155Marketplace::Unsuccessful transfer",
  INVALID_SELL: "Minted1155Marketplace::The sell does not exist",
  INVALID_PRICE: "Minted1155Marketplace::Invalid price",
};

const NonMinted721ErrorMsg = {
  INVALID_TOKEN: "NonMinted721Marketplace::Collection is not active",
  ACTIVE_ORDER: "NonMinted721Marketplace::Cannot cancel active offer",
  SOLD_NFT: "NonMinted721Marketplace::Sold NFT cannot be edit",
  INVALID_STATUS_TO_SELL:
    "NonMinted721Marketplace::Listed NFT has not valid status",
  UNSUCCESSFUL_TRANSFER: "NonMinted721Marketplace::Unsuccessful transfer",
  INVALID_SELL: "NonMinted721Marketplace::The sell does not exist",
  INSUFFICIENT_VESTED_BALANCE:
    "NonMinted721Marketplace::Insufficient vested balance",
};

const Minted721ErrorMsg = {
  NOT_VALID_ADDRESS: "Minted721Marketplace::Not valid address",
  INVALID_TOKEN: "Minted721Marketplace::Token contract is invalid",
  NOT_NFT_OWNER: "Minted721Marketplace::You are not owner",
  CAN_NOT_EDIT: "Minted721Marketplace::listing NFT cannot be edit",
  CANCEL_ACTIVE: "Minted721Marketplace::Cannot cancel active offer",
  NOT_REVOKED: "Minted721Marketplace::Marketplace approve are not revoked",
  HAS_NOT_ACCESS: "Minted721Marketplace::Marketplace has not access",
  SOLD_NFT: "Minted721Marketplace::Sold NFT cannot be edit",
  UNSUCCESSFUL_TRANSFER: "Minted721Marketplace::Unsuccessful transfer",
  SOLD_SELL: "Minted721Marketplace::Cannot cancel sold NFT",
  INVALID_STATUS_TO_SELL:
    "Minted721Marketplace::Listed NFT has not valid status",
  INVALID_SELL: "Minted721Marketplace::The sell does not exist",
  INVALID_PRICE: "Minted721Marketplace::Invalid price",
};

const AssetMarketplaceErrorMsg = {
  INVALID_EXPIRE_DATE: "AssetMarketplace::Expiration date is invalid",
  UNSUCCESSFUL_TRANSFER: "AssetMarketplace::Unsuccessful transfer",
  NO_BALANCE: "AssetMarketplace::No balance to withdraw",
  LOW_AMOUNT: "AssetMarketplace::Insufficient amount, equal to zero",
  ACTIVE_ORDER: "AssetMarketplace::Cannot cancel active offer",
  INVALID_STATUS: "AssetMarketplace::Listed asset has not valid status",
  SOLD_ASSET: "AssetMarketplace::Sold listing asset cannot be edit",
  ALLOWANCE: "AssetMarketplace::Allowance error",
  UNSUCCESSFUL_TRANSFER_BUY: "AssetMarketplace::Unsuccessful transfer",
  INSUFFICIENT_BALANCE: "LRTVesting::Debt limit Exceeded",
  INSUFFICIENT_VESTED_BALANCE: "AssetMarketplace::Insufficient vested balance",
  HAS_EXPIRED: "AssetMarketplace::The sale has expired",
  FUEL_CANNOT_BE_SOLD: "AssetMarketplace::Fuel cannot be sold",
  INSUFFICIENT_LRT_BALANCE: "AssetMarketplace::Insufficient token balance",
  ORDER_ALREADY_FUL_FILLED: "AssetMarketplace::Order already fulfilled",
  SELL_UNIT_IS_LARGER:
    "AssetMarketplace::Sell unit is larger than listed amount",
  INVALID_LISTED_AMOUNT: "AssetMarketplace::There are not any item to sell",
  NOT_COEFFICIENT_OF_SELL_UNIT:
    "AssetMarketplace::Listed amount is not a coefficient of sell unit",
  INVALID_SELL_UNIT: "AssetMarketplace::At least one item to sell",
  EXCEED_SELL: "AssetMarketplace::Exceed sell limit",
};

const PlanetStakeErrorMsg = {
  MAX_STAKE_COUNT: "PlanetStake::You can stake one token",
  CANT_CLAIMED: "PlanetStake::Cannot be claimed",
  AMOUNT_EXCEED: "PlanetStake::There is not token to claim",
  FAIL_TRANSFER_STAKE: "PlanetStake::Fail transfer in staking claim",
  IS_NOT_WHITE_LISTED: "PlanetStake::This token cannot be stake",
  APPROVED_ERROR: "PlanetStake::Stake has not access",
  INSUFFICIENT_BALANCE: "PlanetStake::You do not have enough balance",
  INVALID_TOKEN_TYPE: "PlanetStake::TokenType is invalid",
  STAKE_INVALID_TOKEN_TYPE: "Stake::TokenType is invalid",
  INVALID_ADDRESS: "Stake::Invalid address",
  AMOUNT_TOO_LOW: "PlanetStake::Insufficient amount, equal to zero",
  INVALID_TOKEN_ADDRESS: "PlanetStake::NFT address is invalid",
};

module.exports = {
  AccessErrorMsg,
  LRTErrorMsg,
  LRTVestingErrorMsg,
  SaleErrorMsg,
  LRMessage,
  LR721Message,
  LR1155Message,
  MarketplaceErrorMsg,
  PlanetStakeErrorMsg,
  NonMinted721ErrorMsg,
  Minted721ErrorMsg,
  NonMinted1155ErrorMsg,
  Minted1155ErrorMsg,
  AssetMarketplaceErrorMsg,
  LRTDistroErrorMsg,
};
