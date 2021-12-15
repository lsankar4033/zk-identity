pragma circom 2.0.0; // NOTE: may need to revert to 1.x for web?

include "./merkle.circom";
include "./ecdsa.circom";

include "../node_modules/circomlib/circuits/poseidon.circom";

/*
 * Prove: I know (sig, msg, pubkey, nullifier, nullifierHash, merkle_branch, merkle_root) s.t.:
 * - sig == ecdsa_verify(msg, pubkey)
 * - merkle_verify(pubkey, merkle_branch, merkle_root)
 *   - tree built with mimc hashes
 * - nullifier = mimc_hash(sig)
 * - nullifierHash = mimc_hash(nullifier)
 */
template VerifyDfWinner(levels) {
  signal input sig;
  signal input msg;
  signal input pubkey;

  signal input pubkey

  signal input nullifier;
  signal input nullifierHash;

  signal input merklePathElements[levels];
  signal input merklePathIndices[levels];
  signal input merkleRoot;

  // sig verify
  component sigVerify = ECDSAVerify(86, 3); // 3 registers of 86 bits each (TBD)

  // merkle verify
  component treeChecker = MerkleTreeChecker(levels);
  treeChecker.leaf <== pubkey;
  treeChecker.root <== merkleRoot;
  for (var i = 0; i < levels; i++) {
    treeChecker.pathElements[i] <== merklePathElements[i];
    treeChecker.pathIndices[i] <== merklePathIndices[i];
  }

  // nullifier checks: nullifier = mimc_hash(sig), nullifier_hash = mimc_hash(nullifier)
  component nullifierCheck = Poseidon(1);
  component nullifierHashCheck = Poseidon(1);
}

component main = VerifyDfWinner(10); // NOTE: levels TBD based on actual data
