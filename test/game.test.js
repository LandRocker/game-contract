const { expect } = require("chai");
const { ethers } = require("hardhat");
const {
  loadFixture,
  time,
} = require("@nomicfoundation/hardhat-network-helpers");
const { AccessErrorMsg, LRMessage } = require("./messages");
const { gameFixture } = require("./fixture/game.fixture");
const Helper = require("./helper");
function getRandomInt(max) {
  return Math.floor(Math.random() * max);
}

function getRandomWords() {
  const words = [
    "supercalifragilisticexpialidocious",
    "pneumonoultramicroscopicsilicovolcanoconiosis",
    "hippopotomonstrosesquippedaliophobia",
    "sesquipedalian",
    "honorificabilitudinitatibus",
    "floccinaucinihilipilification",
    "antidisestablishmentarianism",
    "pseudopseudohypoparathyroidism",
    "methionylthreonylthreonylglutaminylarginyl",
    "isopropylthioxanthenones",
    "acetylseryltyrosylserylisoleucylthreonyl",
    "trimethylaminuria",
  ];

  const randomWords = [];

  for (let i = 0; i < 12; i++) {
    const randomIndex = Math.floor(Math.random() * words.length);
    randomWords.push(words[randomIndex]);
  }

  return randomWords;
}
function hashWords(words) {
  let hashString = "";

  for (let i = 0; i < words.length; i++) {
    hashString += words[i];
  }

  const hashed = ethers.utils.solidityKeccak256(["string"], [hashString]);

  return hashed;
}
describe("Game", function () {
  let gameInstance,
    arInstance,
    owner,
    admin,
    distributor,
    wert,
    approvedContract,
    script,
    addr1,
    addr2,
    treasury;

  systemFee = 1300;
  const zeroAddress = "0x0000000000000000000000000000000000000000";

  before(async function () {
    ({
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
    } = await loadFixture(gameFixture));
  });

  it("should handle generateBlocksInSphere function", async function () {
    await gameInstance.connect(admin).generateBlocksInSphere(288);
  });

  it("should handle findLocation function", async function () {
    let data = [];
    for (let x = 0; x < 3850; x++) {
      data.push(x);
    }

    console.log(data);
    await gameInstance.connect(admin).findLocation(data, 4000);
  });

  it.only("should handle mine function", async function () {
    const words = getRandomWords();
    const minedBlock = 100;
    const planetId = 0;
    const timeSpent = await Helper.convertToSeconds("minutes", 20);
    const mission = 1;
    const roverPower = 200;
    const usedFuel = 1000;
    const miner1 = addr1.address;
    const miner2 = addr2.address;
    // await gameInstance
    //   .connect(script)
    //   .mine(planetId, minedBlock, usedFuel, timeSpent, mission, miner1, hashes);

    // const miner = await gameInstance.miners(miner1, planetId);

    // console.log(miner.minedBlocks, ",,,");

    // expect(miner.minedBlocks).to.equal(minedBlock);

    // expect(miner.unMinedBlocks).to.equal(107442);
    // expect(miner.canMine).to.equal(false);

    for (let i = 0; i < 400; i++) {
      const hashes = hashWords(words);
      const miner = ethers.Wallet.createRandom().address;

      await gameInstance.connect(script).setWhiteList(miner, 0, true);

      // const result = await gameInstance
      //   .connect(script)
      //   .callStatic.mine(
      //     planetId,
      //     minedBlock,
      //     usedFuel,
      //     timeSpent,
      //     mission,
      //     miner,
      //     hashes
      //   );

      await gameInstance
        .connect(script)
        .mine(
          planetId,
          minedBlock,
          usedFuel,
          timeSpent,
          mission,
          miner,
          hashes
        );

      // if (result == true) {
      //   console.log("winner");
      // }
    }

    console.log();
  });
  ////
  //   const data2 = [];

  //   for (let x = 0; x <= 3; x++) {
  //     for (let y = 0; y <= 3; y++) {
  //       for (let z = 0; z <= 3; z++) {
  //         data2.push({
  //           x,
  //           y,
  //           z,
  //         });
  //       }
  //     }
  //   }

  //   for (let i = 0; i < data2.length; i++) {
  //     const hashLocation = ethers.utils.solidityKeccak256(
  //       ["uint256", "uint256", "uint256"],
  //       [data2[i].x, data2[i].y, data2[i].z]
  //     );
  //     const nonce = ethers.BigNumber.from(hashLocation);
  //     const result = Number(
  //       await gameInstance.submitData(
  //         data2[i].x,
  //         data2[i].y,
  //         data2[i].z,
  //         25,
  //         35
  //       )
  //     );
  //     // console.log(result);
  //     if (result == 1) {
  //       console.log(data2[i].x, data2[i].y, data2[i].z);
  //     }
  //   }
  //   // Convert BigNumber to JavaScript number
  //   // const jsNumberValue = bigNumberValue.toNumber();

  //   // console.log(Number(bigNumberValue));
  // });
});
