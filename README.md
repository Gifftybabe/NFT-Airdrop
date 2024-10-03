

# NFT Airdrop Smart Contract

This repository contains smart contracts for an NFT Airdrop on the Lisk Sepolia Testnet. The project enables users holding specific NFTs to claim ERC-20 tokens via a Merkle proof system, with an airdrop controlled by the contract owner.

## Overview

### Contracts:

1. **NFTAirdrop**: Manages the airdrop process, allowing users to claim rewards by verifying their eligibility through Merkle proofs and ensuring they hold a specific NFT (BAYC). The contract owner can deposit tokens, update the Merkle root, and withdraw any remaining tokens.
  
2. **AirdropToken**: A simple ERC-20 token contract used for the airdrop. The owner can mint new tokens if needed.

### Features:
- **Merkle Proof Verification**: Ensures users are eligible to claim tokens.
- **NFT Ownership Check**: Only users holding the BAYC NFT are eligible for the airdrop.
- **Secure Token Transfer**: The contract handles token deposits and withdrawals.
- **Ownership Control**: Only the contract owner can manage deposits, withdrawals, and update the Merkle root.

## Deployment Addresses

The contracts have been deployed on the Lisk Sepolia Testnet at the following addresses:

- **NFTAirdrop**: `0xB310147A9D4F60a93885C084085Fea570A1eCf9D`
- **AirdropToken**: `0xbb657262eC16F1DEb97027EebB9b38190544d991`

## Usage

### Prerequisites
- Ensure you have the required ERC-20 tokens deposited in the contract for airdrop.
- Only the contract owner can initiate certain actions like deposits, withdrawals, and Merkle root updates.

### Contract Functions

#### 1. **NFTAirdrop**

- `contractDeposit(uint256 _amount)`: Allows the owner to deposit tokens into the contract.
- `UpdateMerkleRoot(bytes32 _new_merkle_root)`: Updates the Merkle root hash.
- `tokenRemaining()`: Withdraws remaining tokens from the contract back to the owner.
- `claimReward(uint256 _amount, bytes32[] calldata _merkleProof)`: Claims airdrop tokens for eligible users after verifying Merkle proof and BAYC NFT ownership.

#### 2. **AirdropToken**

- `mint(uint _amount)`: Allows the owner to mint additional tokens.

### Events
- `TokenClaimedSuccessfully()`: Emitted when a user successfully claims tokens.
- `contractDepositSuccessfully(address indexed sender, uint256 amount)`: Emitted when the owner deposits tokens into the contract.
