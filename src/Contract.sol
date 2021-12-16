// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.10;

contract ProofOfDfWinner // is Verifier, ERC721Mintable
{
    function mint(bytes proof, bytes nullifier) external {
        // verify proof
        // check that nullifier hasn't been used
        // mint NFT
    }
}
