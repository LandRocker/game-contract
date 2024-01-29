const hre = require("hardhat");
const { ethers } = require("hardhat");

async function deploy_landRockerERC721() {
  console.log("Deploying LandRockerERC721 contract...");

  const LandRockerERC721 = await ethers.getContractFactory("LandRockerERC721");
  const landRockerERC721Instance = await LandRockerERC721.deploy();//"0x87BB4b82842d008280521d79fC2889bc5D277853");
  //   "landRocker",
  //   "LR721",
  //   "0x87BB4b82842d008280521d79fC2889bc5D277853",
  //   "0xCDb23d2e3475A646Fb49E36120e0de1d229dB5b8",
  //   200,
  //   "https://srvs20.landrocker.io/game_service/bc/get/uniq/token/data?token_id="
  // );
  await landRockerERC721Instance.deployed();

  console.log(
    "LandRockerERC721 Contract deployed to:",
    landRockerERC721Instance.address
  );

  console.log(
    "---------------------------------------------------------",
  );   

  return landRockerERC721Instance;
}
module.exports = deploy_landRockerERC721;
