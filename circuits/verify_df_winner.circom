pragma circom 2.0.0; // NOTE: may need to revert to 1.x for web?

include "./merkle.circom";
include "./ecdsa.circom";

include "../node_modules/circomlib/circuits/poseidon.circom";

/*
 * Prove: I know (sig, msg, pubkey, nullifier, nullifierHash, merkle_branch, merkle_root) s.t.:
 * - sig == ecdsa_verify(r, s, msghash, pubkey)
 * - merkle_verify(pubkey, merkleRoot, merklePathElements, merklePathIndices)
 * - nullifier = poseidon(sig)
 * - nullifierHash = poseidon(nullifier)
 *
 * We may choose to make all of these constants in the future:
 * levels = levels in the merkle branch
 * n = num bits for bigint number registers
 * k = num registers for bigint numbers
 */
template VerifyDfWinner(n, k, levels) {
  signal input r[k];
  signal input s[k];
  signal input msghash[k];
  signal input pubkey[2][k];

  signal input nullifier;
  signal input nullifierHash;

  signal input merklePathElements[levels];
  signal input merklePathIndices[levels];
  signal input merkleRoot;

  // sig verify
  component sigVerify = ECDSAVerify(n, k);
  for (var i = 0; i < k; i++) {
    sigVerify.r[i] <== r[i];
    sigVerify.s[i] <== s[i];
    sigVerify.msghash[i] <== msghash[i];

    sigVerify.pubkey[0][i] <== pubkey[0][i];
    sigVerify.pubkey[1][i] <== pubkey[1][i];
  }
  sigVerify.result === 1; // or whatever signifies success

  // merkle verify
  component treeChecker = MerkleTreeChecker(levels);
  // TODO: figure out correct leaf given pubkey[2][k]
  /*treeChecker.leaf <== pubkey;*/
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
