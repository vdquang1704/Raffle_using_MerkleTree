// SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "./Merkle Tree/MerkleTree.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Raffle is MerkleTree {
  address owner;
  address payable[] private players;
  address[] public winners;
  uint public raffleId;
  uint256 private countTree;

  enum RAFFLE_STATE {
    OPEN,
    CLOSED
  }

  RAFFLE_STATE public raffle_state;
  mapping(address => bool) public winnerClaimed;
  mapping(address => uint) private rewards;

  event getWinner(address indexed winner);
  event getReward(address indexed winner);

  constructor() {
    owner = msg.sender;
    raffleId = 0;
    raffle_state = RAFFLE_STATE.CLOSED;
  }

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  function getBalance() public view returns (uint) {
    require(raffle_state == RAFFLE_STATE.OPEN, "You can't see the balance");
    return address(this).balance;
  }

  function getPlayers() public view returns(address payable[] memory) {
    require(raffle_state == RAFFLE_STATE.OPEN, "You can't get the players");
    return players;
  }

  function start() public onlyOwner {
    require(raffle_state == RAFFLE_STATE.CLOSED, "Can't start a new raffle");
    raffle_state = RAFFLE_STATE.OPEN;

  }

  function enter() public payable {
    require(raffle_state == RAFFLE_STATE.OPEN, "The raffle is not open, you can't enter");
    require(msg.value >= 0.00001 ether);

    // dia chi cua nhung nguoi tham gia
    players.push(payable(msg.sender));
  }

  function getRandomNumber() internal view returns (uint) {
    return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
  }

  function pickWinner() public onlyOwner {
    require(raffle_state == RAFFLE_STATE.OPEN, "You can't pick the Winner");
    uint randomIndex = getRandomNumber() % players.length;
    require(!winnerClaimed[msg.sender], "Player has already claimed reward !");
    hashes = new bytes32[](0);
    
    winners.push(payable(players[randomIndex]));
    rewards[players[randomIndex]] = address(this).balance;
    raffleId++;

    createTree(winners);
    
    emit getWinner(players[randomIndex]);

    players = new address payable[](0);
  }

  function end() public onlyOwner {
    require(raffle_state == RAFFLE_STATE.OPEN, "Can't end the raffle");
    treeList[countTree] = hashes;
    countTree++;
   
    hashes = new bytes32[](0);
    winners = new address[](0);
    raffle_state = RAFFLE_STATE.CLOSED;
  }

  function winnerReward(bytes32[] memory _merkleProof, uint256 index) external {
    require(raffle_state ==  RAFFLE_STATE.OPEN, "You can't get the reward");
    // Check has address already claimed ?
    require(!winnerClaimed[msg.sender], "Address already claimed");
    bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
    
    // Verify node in merkle tree
    require(verify(_merkleProof, getRoot(), leaf, index), "Invalid Merkle Proof");

    // reward token
    (payable (msg.sender)).transfer(rewards[msg.sender]);
    emit getReward(msg.sender);

    winnerClaimed[msg.sender] = true;
  }
}

