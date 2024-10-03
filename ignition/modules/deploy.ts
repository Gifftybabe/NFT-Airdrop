import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const airdropModule = buildModule("airdropModule", (m) => {

  const airdrop = m.contract("NFTAirdrop");

 

  return { airdrop};
});

export default airdropModule;