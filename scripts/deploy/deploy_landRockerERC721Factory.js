const hre = require("hardhat");
const { ethers } = require("hardhat");

async function deploy_landRockerERC721Factory() {
  console.log("Deploying LandRockerERC721Factory contract...");

  const LandRockerERC721Factory = await ethers.getContractFactory("LandRockerERC721Factory");
  const landRockerERC721FactoryInstance = await LandRockerERC721Factory.deploy("0x843840d993f5B6c65350a20990F2e304046454Bb");  //arInstance
  //   "landRocker",
  //   "LR721",
  //   "0x87BB4b82842d008280521d79fC2889bc5D277853",
  //   "0xCDb23d2e3475A646Fb49E36120e0de1d229dB5b8",
  //   1000,
  //   "https://srvs20.landrocker.io/game_service/bc/get/uniq/token/data?token_id="
  // );
  await landRockerERC721FactoryInstance.deployed();

  console.log(
    "LandRockerERC721Factory Contract deployed to:",
    landRockerERC721FactoryInstance.address
  );

  console.log(
    "---------------------------------------------------------",
  );
 
  return landRockerERC721FactoryInstance;
}
module.exports = deploy_landRockerERC721Factory;
