// SPDX-License-Identifier: MIT
 
pragma solidity ^0.8.16;

contract MerkleTree {

  bytes32[] public hashes;
  mapping(uint256 => bytes32[]) public treeList;
  
  function createTree(address[] memory winners) internal returns (bytes32[] memory) {
    for (uint i = 0; i < winners.length; i++) {
      hashes.push(keccak256(abi.encodePacked(winners[i])));
    }

    uint n = winners.length;
    uint offset = 0;

    while (n > 0) {
      for (uint i = 0; i < n - 1; i += 2) {
        hashes.push(keccak256(abi.encodePacked(hashes[offset+i], hashes[offset+i+1])));
      } 

      offset += n;
      n = n / 2;
    }

   return hashes;
  }

    function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf, uint index) internal pure returns (bool) {
        bytes32 hash = leaf;
        
        for (uint i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];

            if (index % 2 == 0) {
                hash = keccak256(abi.encodePacked(hash, proofElement));
            } else {
                hash = keccak256(abi.encodePacked(proofElement, hash));
            }

            index = index / 2;
        }

        return hash == root;
    }

  function getRoot() public view returns (bytes32) {
    return hashes[hashes.length - 1];
  }

    function getTree() external view returns (bytes32[] memory) {
      return hashes;
  }
}

