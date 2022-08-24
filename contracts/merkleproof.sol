// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract Merkletrees {
    mapping(address => bool) whitelisted;

    function verified(
        bytes32[] memory proof,
        bytes32 merkleroot,
        bytes32 leaf
    ) public view returns (bool) {
        require(!whitelisted[msg.sender], "alraedy claimed");
        //bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        return MerkleProof.verify(proof, merkleroot, leaf);
    }
}
