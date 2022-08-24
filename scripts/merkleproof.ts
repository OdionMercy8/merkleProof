import { ethers } from "hardhat";

import MerkleTree from 'merkletreejs';
import keccak256 from 'keccak256';

async function main() {
    console.log("deploying....");
    
    const Merkleprove = await ethers.getContractFactory("Merkletrees");
    const merkleprove = await Merkleprove.deploy();

    await merkleprove.deployed();


let whitelistAddresses = [
    "0X5B38DA6A701C568545DCFCB03FCB875F56BEDDC4",
    "0X5A641E5FB72A2FD9137312E7694D42996D689D99",
    "0XDCAB482177A592E424D1C8318A464FC922E8DE40",
    "0X6E21D37E07A6F7E53C7ACE372CEC63D4AE4B6BD0",
    "0X09BAAB19FC77C19898140DADD30C4685C597620B",
    "0XCC4C29997177253376528C05D3DF91CF2D69061A",
    "0xdD870fA1b7C4700F2BD7f44238821C26f7392148" 
  ];


const leafNodes = whitelistAddresses.map(addr => keccak256(addr));
const merkleTree = new MerkleTree(leafNodes, keccak256, { sortPairs: true});

const rootHash = merkleTree.getRoot();
console.log( merkleTree.toString());
console.log("Root Hash: ", rootHash);


const claimingAddress = leafNodes[6];

const hexProof = merkleTree.getHexProof(keccak256("0X09BAAB19FC77C19898140DADD30C4685C597620B"));
console.log(hexProof);


//console.log(merkleTree.verify(hexProof, claimingAddress, rootHash));
const proven =  await merkleprove.verified(hexProof, rootHash, keccak256("0X09BAAB19FC77C19898140DADD30C4685C597620B"));
console.log("its proven....", proven);
     
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});


// const uche = "david";
// uche.toString();


// class Uche {
//   getName() {
//     console.log("developeruche")
//   }

//   toString() {
//     return console.log("Ose")
//   }
// }

// new Uche().