# Cross-Chain Token Bridge Logic

This repository contains the core smart contract logic for a cross-chain bridge. It demonstrates the "Lock/Mint" pattern used by many interoperability protocols to move liquidity across disparate networks.

## Architecture
1. **Source Chain (Locking)**: User calls `bridgeAsset`, locking their tokens in the Bridge contract.
2. **Off-Chain Relay**: A validator or oracle (not included) monitors the `Locked` event.
3. **Destination Chain (Minting)**: The Bridge contract on the target chain receives a signed message and mints a "Wrapped" version of the asset for the user.



## Key Components
- **Bridge.sol**: Handles the locking, burning, and verification logic.
- **WrappedToken.sol**: A mintable/burnable ERC-20 that represents the bridged asset on the destination chain.

## Security Considerations
- **Signature Verification**: Uses ECDSA to verify that minting commands come from authorized bridge validators.
- **Nonce Tracking**: Prevents replay attacks where a single bridge event is processed multiple times.
