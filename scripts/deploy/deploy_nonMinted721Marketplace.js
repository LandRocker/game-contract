const hre = require("hardhat");
const { ethers } = require("hardhat");

async function deploy_nonMinted721_Marketplace() {
  console.log("Deploying NonMinted721Marketplace contract...");

  const NonMinted721Marketplace = await ethers.getContractFactory(
    "NonMinted721Marketplace"
  );
  const nonMinted721MarketplaceInstance = await upgrades.deployProxy(
    NonMinted721Marketplace,
    [
      "0x32D291263DFd5afbe301E4621aCdDB63B203cEF6", //landRockerERC721FactoryInstance
      "0xe05743AD21de241B6D25FCA0C8174e0CF1705D24", //landRockerERC721Instance
      "0x843840d993f5B6c65350a20990F2e304046454Bb", //arInstance
      "0xab4486f450E79011D6540D1fE9c4130d864966aa", //lrtInstance
      "0xC0819a5F95e958e27E15C5578fd011494fC5Ef16", //landRockerInstance
      "0x51D39dEaD7975b06788F55DC63574FC384b12907", //lrtVestingInstance
    ],
    {
      kind: "uups",
      initializer: "initializeNonMinted721Marketplace",
    }
  );

  await nonMinted721MarketplaceInstance.deployed();
  console.log(
    "NonMinted721Marketplace Contract deployed to:",
    nonMinted721MarketplaceInstance.address
  );
  console.log("---------------------------------------------------------");

  return nonMinted721MarketplaceInstance.address;
}
module.exports = deploy_nonMinted721_Marketplace;
