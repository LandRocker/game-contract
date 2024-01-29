const hre = require("hardhat");
const { ethers } = require("hardhat");

async function deploy_landRocker() {
  console.log("Deploying LandRocker contract...");

  //deploy private sale contract
  const LandRocker = await ethers.getContractFactory("LandRocker");
  const landRockerInstance = await upgrades.deployProxy(
    LandRocker,
    [
      "0x843840d993f5B6c65350a20990F2e304046454Bb"
    ],
    {
      kind: "uups",
      initializer: "initializeLandRocker",
    }
  );
  
  await landRockerInstance.deployed();

  console.log(
    "LandRocker Contract deployed to:",
    landRockerInstance.address
  );

  console.log(
    "---------------------------------------------------------",
  );

  // await hre.run("laika-sync", {
  //   contract: "LandRocker",
  //   address: landRockerInstance.address,
  // });

  return landRockerInstance.address;
}
module.exports = deploy_landRocker;
