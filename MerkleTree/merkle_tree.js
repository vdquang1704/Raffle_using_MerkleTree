const { MerkleTree } = require("merkletreejs")
const keccak256 = require("keccak256");
const Web3 = require("Web3")

let whiteListAddresses = [
 0x306366DE0bF312786C0af82089Fc914eF578fe0c, // acc1
 0x8e3A72320835dD974763a90552c0073f5E7b34d3, // acc4
 0x3D4Ea27C73cB51239Aea089008482dE99f1216ED, // acc5
 0xc032D5B5Ec015F6E03b4Cc3345D1B49131Af5063, // acc6
 0x85CB33e7E3dcc71c9B4f77Bd421b0BEdab826f29, // acc3
 0xdD870fA1b7C4700F2BD7f44238821C26f7392148 // accRemix
]

// Tao mang chua cac la cua cay merkle, sau do hash tat ca cac la lai.
const leafNodes = whiteListAddresses.map(addr => Web3.utils.keccak256(addr.toString()))
const merkleTree = new MerkleTree(leafNodes, keccak256, { sortPairs: true });

console.log(leafNodes)
console.log(merkleTree)

// Lay root hash cua cay merkle
const rootHash = merkleTree.getHexRoot();
console.log("WhiteList Merkle Tree\n", merkleTree.toString());
console.log("RootHash: ", rootHash);

// Lay 1 node bat ky de xac thuc tren cay merkle
const claimingAddress = leafNodes[5]

// Ly nhung la hang xom cua diem node ma ta can xac thuc
const hexProof = merkleTree.getHexProof(claimingAddress);
console.log(hexProof); 

// Xac thuc
console.log(merkleTree.verify(hexProof, claimingAddress, rootHash))


