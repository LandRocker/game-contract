const hre = require("hardhat");
const { ethers } = require("hardhat");

async function deploy_minted1155_Marketplace() {
  console.log("Deploying Minted1155Marketplace contract...");

  const Minted1155Marketplace = await ethers.getContractFactory("Minted1155Marketplace");
  const minted1155MarketplaceInstance = await upgrades.deployProxy(
    Minted1155Marketplace,
    [
      "0x7b09c8217008A535e9d8AEE685e4e46CB5709767", //landRockerERC1155Instance
      "0x843840d993f5B6c65350a20990F2e304046454Bb", //arInstance
      "0xab4486f450E79011D6540D1fE9c4130d864966aa", //lrtInstance
      "0xC0819a5F95e958e27E15C5578fd011494fC5Ef16", //landRockerInstance
    ],
    {
      kind: "uups",
      initializer: "initializeMinted1155Marketplace",
    }
  );
 
  await minted1155MarketplaceInstance.deployed();
  console.log("Minted1155Marketplace Contract deployed to:", minted1155MarketplaceInstance.address);
    console.log("---------------------------------------------------------");

  // await hre.run("laika-sync", {
  //   contract: "LRTPreSale",
  //   address: lrtPreSaleInstance.address,
  // });

  return minted1155MarketplaceInstance.address;
}
module.exports = deploy_minted1155_Marketplace;
