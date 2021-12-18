pragma circom 2.0.1;

include "./vocdoni/keccak256-circom/keccak.circom";

/*
 * Helper for verifying an eth address refers to the correct public key point
 *
 * NOTE: uses https://github.com/vocdoni/keccak256-circom, a highly experimental keccak256 implementation
 */
template PubkeyToAddress(n, k) {
    signal input pubkey[2][k];
    signal input address;

    signal output result;

    // NOTE: may want to assert that n*k is 512?

    // aggregate pubkey to a *single* bit array
    // - init an array of 2*n*k
    // - for each register in x, then y, Num2Bits its stuff and stick em into the new array

    // keccak256 this bit array (of size 512)

    // take the last 160 bits (20 bytes)
    // bits2num? or not, depending on what's optimal op wise
}
