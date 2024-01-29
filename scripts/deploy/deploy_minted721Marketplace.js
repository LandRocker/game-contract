const hre = require("hardhat");
const { ethers } = require("hardhat");

async function deploy_minted721_Marketplace() {
  console.log("Deploying Minted721Marketplace contract...");

  const Minted721Marketplace = await ethers.getContractFactory(
    "Minted721Marketplace"
  );
  const minted721MarketplaceInstance = await upgrades.deployProxy(
    Minted721Marketplace,
    [
      "0xe05743AD21de241B6D25FCA0C8174e0CF1705D24", //landRockerERC721Instance
      "0x843840d993f5B6c65350a20990F2e304046454Bb", //arInstance
      "0xab4486f450E79011D6540D1fE9c4130d864966aa", //lrtInstance
      "0xC0819a5F95e958e27E15C5578fd011494fC5Ef16", //landRockerInstance
    ],
    {
      kind: "uups",
      initializer: "initilizeMinted721Marketplace",
    }
  );

  await minted721MarketplaceInstance.deployed();
  console.log(
    "Minted721Marketplace Contract deployed to:",
    minted721MarketplaceInstance.address
  );
  console.log("---------------------------------------------------------");

  return minted721MarketplaceInstance.address;
}
module.exports = deploy_minted721_Marketplace;
