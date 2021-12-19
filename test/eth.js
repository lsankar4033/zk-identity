const path = require("path");

const chai = require("chai");
const circom_tester = require("circom_tester");

const assert = chai.assert;
const wasm_tester = circom_tester.wasm;

describe("FlattenPubkey tests", function () {
  this.timeout(100000);

  it("flattens properly when pubkey is a perfect fit in registers", async function () {
    const circuit= await wasm_tester(path.join(__dirname, "circuits", "flatten_pubkey_64_4.circom"));
    await circuit.loadConstraints();
  });

  it("flattens properly when there is 'extra space' in the last register", async function () {
    const circuit= await wasm_tester(path.join(__dirname, "circuits", "flatten_pubkey_86_3.circom"));
    await circuit.loadConstraints();
  });
});

// TODO: test pubkey_to_address

