const fs = require('fs');
const csv = require('csv-parser');
const { MerkleTree } = require('merkletreejs');
const keccak256 = require('keccak256');

function readCSV(filename) {
  return new Promise((resolve, reject) => {
    const results = [];
    fs.createReadStream(filename)
      .pipe(csv())
      .on('data', (data) => results.push(data))
      .on('end', () => resolve(results))
      .on('error', (error) => reject(error));
  });
}

async function generateMerkleTree(csvFile) {
  const data = await readCSV(csvFile);

  const leaves = data.map((row) => {
    const address = row.address.trim();
    const amount = row.amount.trim();
    return keccak256(`${address},${amount}`);
  });

  const merkleTree = new MerkleTree(leaves, keccak256, { sortPairs: true });

  const merkleRoot = merkleTree.getHexRoot();
  console.log('Merkle Root:', merkleRoot);

  const proofs = {};
  data.forEach((row) => {
    const address = row.address.trim();
    const amount = row.amount.trim();
    const leaf = keccak256(`${address},${amount}`);
    const proof = merkleTree.getHexProof(leaf);
    proofs[address] = { proof, amount };
  });

  fs.writeFileSync('proofs.json', JSON.stringify(proofs, null, 2));

  console.log('Proofs saved to proofs.json');
}

const csvFile = process.argv[2];
if (!csvFile) {
  console.error('Please provide a CSV file as an argument.');
  process.exit(1);
}

generateMerkleTree(csvFile).catch((error) => {
  console.error('Error generating Merkle tree:', error);
  process.exit(1);
});