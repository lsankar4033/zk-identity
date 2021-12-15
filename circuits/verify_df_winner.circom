pragma circom 2.0.0; // NOTE: may need to revert to 1.x for web?

include "./mimcsponge.circom";
include "./ecdsa.circom";

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

  signal input merkle_branch;
  signal input merkle_root;

  signal output valid; // NOTE: could have this be nullifierHash too

  // sig verify
  component sig_verify = ECDSAVerify(86, 3); // 3 registers of 86 bits each (TBD)

  // TODO: merkle verify

  // nullifier checks: nullifier = mimc_hash(sig), nullifier_hash = mimc_hash(nullifier)
  component nullifier_check = MiMCSponge(1, 220, 1);
  component nullifier_hash_check = MiMCSponge(1, 220, 1);
}

component main = VerifyDfWinner(10); // NOTE: levels TBD! Once we construct the tree, we'll know what htis should be
