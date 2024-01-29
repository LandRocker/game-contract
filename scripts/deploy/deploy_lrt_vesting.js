const hre = require("hardhat");
const { ethers } = require("hardhat");

async function deploy_lrt_vesting() {
  console.log("Deploying the LRT Vesting contract...");
  // Access Restriction: 0xB21bb1Ab0012236E3CF889FCcE00a4F3d9aF55c4
  // LRT Token : 0xcA498643614310935da320b0C1104305084DB4C7
  //deploy LRTVesting
  const LRTVesting = await ethers.getContractFactory("LRTVesting");
  const lrtVestingInstance = await LRTVesting.deploy(
    "0xFaCe248D8725D8445Be9a0927E2D733865aeAA02",
    "0x9946F8E0A826CAA042839858ED95180EB6Ce0E9A"
  );

  await lrtVestingInstance.deployed();

  console.log("LRT Vesting Contract deployed to:", lrtVestingInstance.address);
  console.log("---------------------------------------------------------");
  // await hre.run("laika-sync", {
  //   contract: "LRTVesting",
  //   address: lrtVestingInstance.address,
  // });
  return lrtVestingInstance.address;
}
module.exports = deploy_lrt_vesting;
