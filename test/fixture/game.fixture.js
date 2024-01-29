const { ethers } = require("hardhat");
const deploy_game = require("./deploy_scripts/deploy_Game");
const deploy_access_restriction = require("./deploy_scripts/deploy_access_restriction");
const deploy_lrt = require("./deploy_scripts/deploy_lrt");
const deploy_lrt_distributor = require("./deploy_scripts/deploy_lrt_distributor");

let ADMIN_ROLE = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("ADMIN_ROLE"));

let APPROVED_CONTRACT_ROLE = ethers.utils.keccak256(
  ethers.utils.toUtf8Bytes("APPROVED_CONTRACT_ROLE")
);
let SCRIPT_ROLE = ethers.utils.keccak256(
  ethers.utils.toUtf8Bytes("SCRIPT_ROLE")
);

let DISTRIBUTOR_ROLE = ethers.utils.keccak256(
  ethers.utils.toUtf8Bytes("DISTRIBUTOR_ROLE")
);

let WERT_ROLE = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("WERT_ROLE"));
async function gameFixture() {
  const [
    owner,
    admin,
    distributor,
    wert,
    approvedContract,
    script,
    addr1,
    addr2,
    treasury,
  ] = await ethers.getSigners();

  const arInstance = await deploy_access_restriction(owner);
  const lrtInstance = await deploy_lrt(arInstance);







  await arInstance.grantRole(ADMIN_ROLE, admin.address);
  await arInstance.grantRole(APPROVED_CONTRACT_ROLE, approvedContract.address);
  await arInstance.grantRole(WERT_ROLE, wert.address);
  await arInstance.grantRole(SCRIPT_ROLE, script.address);
  await arInstance.grantRole(DISTRIBUTOR_ROLE, distributor.address);

  

  const gameInstance = await deploy_game(arInstance, lrtInstance);

  await gameInstance.connect(script).addPlanet(0, 113097, 5655); //%5
  await gameInstance.connect(script).addPlanet(1, 113097, 11310); //10%
  await gameInstance.connect(script).addPlanet(2, 113097, 16965); //15%
  await gameInstance.connect(script).addPlanet(3, 113097, 33929); //30%

  await gameInstance.connect(script).setWhiteList(addr1.address, 0, true);
  await gameInstance.connect(script).setWhiteList(addr2.address, 0, true);
  await gameInstance.connect(script).setWhiteList(addr1.address, 1, true);
  await gameInstance.connect(script).setWhiteList(addr2.address, 1, true);
  await gameInstance.connect(script).setWhiteList(addr1.address, 2, true);
  await gameInstance.connect(script).setWhiteList(addr2.address, 2, true);
  await gameInstance.connect(script).setWhiteList(addr1.address, 3, true);
  await gameInstance.connect(script).setWhiteList(addr2.address, 3, true);

  await lrtInstance
    .connect(distributor)
    .transferToken(gameInstance.address, ethers.utils.parseUnits("400"));

  return {
    gameInstance,
    arInstance,
    owner,
    admin,
    distributor,
    wert,
    approvedContract,
    script,
    addr1,
    addr2,
    treasury,
  };
}

module.exports = {
  gameFixture,
};
