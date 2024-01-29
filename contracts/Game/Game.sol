// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.6;
// import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
// import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
// import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
// import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {IAccessRestriction} from "./../access/IAccessRestriction.sol";
import {ILRT} from "./../tokens/erc20/ILRT.sol";

import "hardhat/console.sol";

/**
 * @title LandRocker
 * @dev Contract for managing system fees and treasury addresses.
 */
contract Game is Initializable, UUPSUpgradeable {
    
    struct Miner {
        uint256 minedBlocks;
        uint256 unMinedBlocks;
        bool isWinner;
        bool canMine;
    }

    struct Planet {
        uint256 totalBlocks;
        uint256 userBlockLimit;
        uint256 planetCapacity;
        uint256 userMiningCount;
    }
    IAccessRestriction public accessRestriction;
    ILRT public lrt;
    // IPlanetStake public planetStake;


    mapping(address => mapping(uint256 => mapping(uint256 => Miner))) public miners;

    mapping(uint256 => Planet) public planets;
 

    /**
     * @dev Emitted when payment is received
     * @param from Address payment received from
     * @param amount Amount received
     */
    event Received(address from, uint256 amount);

    event MinerWon(address miner,uint256 planetId,uint256 mission, uint256 winIndex,uint256 rewardAmount);
    event MinerLose(address miner,uint256 planetId,uint256 mission);



    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    /**
     * @dev Modifier to restrict access to the owner.
     */
    modifier onlyOwner() {
        accessRestriction.ifOwner(msg.sender);
        _;
    }

    /**
     * @dev Modifier to check if an address is valid.
     * @param _address The address to check.
     */
    modifier validAddress(address _address) {
        require(_address != address(0), "LandRocker::Not valid address");
        _;
    }

    /**
     * @dev Modifier: Only accessible by authorized scripts
     */
    modifier onlyScript() {
        accessRestriction.ifScript(msg.sender);
        _;
    }

    /**
     * @dev Modifier to restrict access to administrators.
     */
    modifier onlyAdmin() {
        accessRestriction.ifAdmin(msg.sender);
        _;
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
     * @dev Initializes the contract.
     * @param _accessRestriction The address of the access restriction contract.
     */

    function initializeGame(address _accessRestriction,address _lrt) external initializer {
        __UUPSUpgradeable_init();
        accessRestriction = IAccessRestriction(_accessRestriction);
        lrt = ILRT(_lrt);
    }

    function setWhiteList(
        address _miner,
        uint256 _planetId,
        uint256 _mission,
        bool _canMine
    ) external validAddress(_miner) onlyScript {
        Planet memory planet = planets[_planetId];
        require(planet.totalBlocks > 0, "Game:: planet is not exitst");
        Miner storage miner = miners[_miner][_planetId][_mission];
        miner.canMine = _canMine;
        miner.unMinedBlocks = planet.totalBlocks;
    }

    function addPlanet(
        uint256 _planetId,
        uint256 _totalBlocks,
        uint256 _userBlockLimit,
        uint256 _planetCapacity
    ) external onlyScript {
        Planet storage planet = planets[_planetId];
        require(planet.totalBlocks == 0, "Game:: planet is added before");
        planet.totalBlocks = _totalBlocks;
        planet.userBlockLimit = _userBlockLimit;
        planet.planetCapacity = _planetCapacity;
    }

    function mine(
        uint256 _planetId,
        uint256 _mindedBlock,
        uint256 _usedFeul,
        uint256 _timeSpend,
        uint256 _mission,
        address _miner,
        bytes32 _nullifier
    ) external onlyScript  {
        // uint256 startTotalGas = gasleft();

        Planet memory planet = planets[_planetId];
        Miner storage miner = miners[_miner][_planetId][_mission];

        require(planet.totalBlocks > 0, "Game::Planet is not exitst");

        require(
            _mindedBlock + miner.minedBlocks <= planet.userBlockLimit,
            "Game::Miner has reached to miximum limit"
        );
        require(miner.canMine, "Game::Miner has not allow to mine");
        require(!miner.isWinner, "Game::Miner already won once");

        require(planet.userMiningCount + 1 <=planet.planetCapacity,"Game::The planet has burnt");

        uint256 randomIndex = uint256(
            keccak256(
                abi.encodePacked(
                    block.difficulty,
                    block.number,
                    _planetId,
                    _mindedBlock,
                    _usedFeul,
                    _timeSpend,
                    _mission,
                    _miner,
                    _nullifier
                )
            )
        );

        uint256 winIndex = randomIndex % miner.unMinedBlocks;
        // console.log(miner.unMinedBlocks, "miner.unMinedBlocks");
        // console.log(planet.totalBlocks, "planet.totalBlocks");
        // console.log(winIndex, "winIndex");
        // console.log(_mindedBlock, "_mindedBlock");



        if (winIndex < _mindedBlock) {
            console.log("win");
            miner.isWinner = true;
            miner.canMine = false;
            // miner.unMinedBlocks -= _mindedBlock;
            // miner.minedBlocks += _mindedBlock;
            emit MinerWon(_miner, _planetId, winIndex, 1e18,_mission);
            require(lrt.transfer(_miner, 1e18),"fail transfer");
        }
        miner.unMinedBlocks -= _mindedBlock;
        miner.minedBlocks += _mindedBlock;
        planet.userMiningCount++;
        emit MinerLose(_miner, _planetId,_mission);
        if(planet.userMiningCount == planet.planetCapacity) {
            //ToDo: setPlanet to be claimable for a staker
        }
        if(miner.minedBlocks == planet.userBlockLimit) {
            miner.canMine = false;
        }

        // console.log("lose");

        // uint256 perLocationGasUsed = startTotalGas - gasleft();
        // console.log(perLocationGasUsed, "per Location Gas Used");

    }

    /**
     * @dev Authorizes a contract upgrade.
     * @param newImplementation The address of the new contract implementation.
     */
    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}
}
