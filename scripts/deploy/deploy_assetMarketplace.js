const hre = require("hardhat");
const { ethers } = require("hardhat");

async function deploy_Asset_Marketplace() {
  console.log("Deploying AssetMarketplace contract...");

  const AssetMarketplace = await ethers.getContractFactory("AssetMarketplace");
  const assetMarketplaceInstance = await upgrades.deployProxy(AssetMarketplace,
    ["0x843840d993f5B6c65350a20990F2e304046454Bb",  //arInstance
    "0xab4486f450E79011D6540D1fE9c4130d864966aa",  //lrtInstance
    "0xC0819a5F95e958e27E15C5578fd011494fC5Ef16",   //landRockerInstance
    "0x51D39dEaD7975b06788F55DC63574FC384b12907"],  //lrtVestingInstance 
    {
      kind: "uups",
      initializer: "initializeAssetMarketplace",
    }
  );  

  await assetMarketplaceInstance.deployed();
  console.log("AssetMarketplace Contract deployed to:", assetMarketplaceInstance.address);
    console.log("---------------------------------------------------------");

  // await hre.run("laika-sync", {
  //   contract: "LRTPreSale",
  //   address: lrtPreSaleInstance.address,
  // });

  return assetMarketplaceInstance.address;
}
module.exports = deploy_Asset_Marketplace;
