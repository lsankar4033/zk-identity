const path = require("path");

const chai = require("chai");
const circom_tester = require("circom_tester");

const assert = chai.assert;
const wasm_tester = circom_tester.wasm;

// NOTE: below two functions taken from vocdoni/keccak256-circom
// Move into their own utils file when I start doing tests on other circuits
function bytesToBits(b) {
  const bits = [];
  for (let i = 0; i < b.length; i++) {
    for (let j = 0; j < 8; j++) {
      if ((Number(b[i])&(1<<j)) > 0) {
        // bits.push(Fr.e(1));
        bits.push(1);
      } else {
        // bits.push(Fr.e(0));
        bits.push(0);
      }
    }
  }
  return bits
}

function bitsToBytes(a) {
  const b = [];

  for (let i=0; i<a.length; i++) {
    const p = Math.floor(i/8);
    if (b[p]==undefined) {
      b[p] = 0;
    }
    if (a[i]==1) {
      b[p] |= 1<<(i%8);
    }
  }
  return b;
}

describe("Keccak 32byte input and output test", function () {
  this.timeout(100000);

  let circuit
  before(async () => {
    circuit= await wasm_tester(path.join(__dirname, "circuits", "keccak_256_256.circom"));
    await circuit.loadConstraints();
    console.log("n_constraints", circuit.constraints.length);
  });

  // NOTE: test case from vocdoni/keccak256-circom
  it("adheres to sanity test", async () => {
    const input = [116, 101, 115, 116, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    const expectedOut = [37, 17, 98, 135, 161, 178, 88, 97, 125, 150, 143,
      65, 228, 211, 170, 133, 153, 9, 88, 212, 4, 212, 175, 238, 249,
    210, 214, 116, 170, 85, 45, 21];

    const inIn = bytesToBits(input);

    const witness = await circuit.calculateWitness({ "in": inIn }, true);

    const stateOut = witness.slice(1, 1+(32*8));
    const stateOutBytes = bitsToBytes(stateOut);
    assert.deepEqual(stateOutBytes, expectedOut);
  });
});

describe("Keccak 64byte input, 32byte output (Eth pubkey->address) test", function () {

});
