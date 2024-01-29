const hre = require("hardhat");
const { ethers } = require("hardhat");

const deploy_access_restriction = require("./deploy/deploy_access_restriction");
const deploy_lrt = require("./deploy/deploy_lrt");
const deploy_lrt_distributor = require("./deploy/deploy_lrt_distributor");
const deploy_lrt_vesting = require("./deploy/deploy_lrt_vesting");
const deploy_pre_sale = require("./deploy/deploy_pre_sale");
// const setup_roles = require("./setup/setup_roles");
// const deploy_marketplace = require("./deploy/deploy_marketplace");
const deploy_planet_stake = require("./deploy/deploy_planet_stake");


const deploy_landRocker = require("./deploy/deploy_landrocker");
const deploy_Asset_Marketplace = require("./deploy/deploy_assetMarketplace");
const deploy_lr1155 = require("./deploy/deploy_lr1155");
const deploy_nonMinted1155_Marketplace = require("./deploy/deploy_nonMinted1155Marketplace");
const deploy_minted1155_Marketplace = require("./deploy/deploy_minted1155Marketplace");
const deploy_lr721_Factory = require("./deploy/deploy_landRockerERC721Factory");
const deploy_lr721 = require("./deploy/deploy_landRockerERC721");
const deploy_nonMinted721_Marketplace = require("./deploy/deploy_nonMinted721Marketplace");
const deploy_minted721_Marketplace = require("./deploy/deploy_minted721Marketplace");
const deploy_game = require("./deploy/deploy_game");


async function main() {
  // deploy contracts
  // await deploy_access_restriction();
  // const lrtAddress = await deploy_lrt();
  // const lrtDistributorAddress = await deploy_lrt_distributor();
  // const lrtVestingAddress = await deploy_lrt_vesting();
  // const lrtPreSaleAddress = await deploy_pre_sale();

  // await deploy_landRocker();
  // await deploy_Asset_Marketplace();
  //  await deploy_lr1155();
  // await deploy_nonMinted1155_Marketplace();
  await deploy_minted1155_Marketplace();
  // await deploy_lr721();
  // await deploy_lr721_Factory();
  // await deploy_game();
  // await deploy_nonMinted721_Marketplace();
  // await deploy_minted721_Marketplace();

  // const planetStakeInstance = await deploy_planet_stake();
  // // const marketplaceInstance = await deploy_marketplace(landRockerERC721Instance,landRockerERC721Instance);

  // setup data
  // await setup_roles(arInstance,lrtVestingInstance,lrtPreSaleInstance);
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
