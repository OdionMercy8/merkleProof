// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MerkleTrees is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint256 totalSupply = 50;

    mapping(address => bool) whitelisted;

    bytes32 rootHash =
        0xd38a533706a576a634c618407eb607df606d62179156c0bed7ab6c2088b01de9;

    constructor() ERC721("Odion", "OD") {}

    function verified(bytes32[] memory proof) public view returns (bool) {
        require(!whitelisted[msg.sender], "alraedy claimed");
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        return MerkleProof.verify(proof, rootHash, leaf);
    }

    function checkAdress(string memory tokenURI, bytes32[] memory proof)
        public
        returns (uint256)
    {
        bool prove = verified(proof);
        require(prove != true, "not listed");
        uint256 newItemId = _tokenIds.current();
        require(newItemId <= totalSupply, "exceeds total supply");
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);

        _tokenIds.increment();
        whitelisted[msg.sender] = true;

        return newItemId;
    }
}
