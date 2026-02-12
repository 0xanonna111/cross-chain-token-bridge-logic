const { ethers } = require("ethers");

/**
 * Utility to sign a bridge message for the validator
 */
async function signBridgeRelease(validatorWallet, userAddress, amount, nonce) {
    const messageHash = ethers.solidityPackedKeccak256(
        ["address", "uint256", "uint256"],
        [userAddress, amount, nonce]
    );
    
    const signature = await validatorWallet.signMessage(ethers.toBeArray(messageHash));
    return signature;
}

module.exports = { signBridgeRelease };
