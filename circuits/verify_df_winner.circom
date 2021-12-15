/*
 * Prove: I know (sig, msg, pubkey, nullifier, nullifierHash, merkle_branch, merkle_root) s.t.:
 * - sig == ecdsa_verify(msg, pubkey)
 * - merkle_verify(pubkey, merkle_branch, merkle_root)
 * - nullifier = mimc_hash(sig)
 * - nullifierHash = mimc_hash(nullifier)
 */

template VerifyDfWinner() {
  // TODO
}

component main = VerifyDfWinner();
