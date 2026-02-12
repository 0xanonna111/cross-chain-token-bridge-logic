// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Bridge is Ownable {
    using ECDSA for bytes32;

    address public validator;
    mapping(bytes32 => bool) public processedMessages;

    event Locked(address indexed user, uint256 amount, uint256 nonce, uint256 targetChainId);
    event Released(address indexed user, uint256 amount, uint256 nonce);

    constructor(address _validator) Ownable(msg.sender) {
        validator = _validator;
    }

    /**
     * @dev Step 1: Lock tokens on Source Chain
     */
    function bridgeAsset(address token, uint256 amount, uint256 nonce, uint256 targetChainId) external {
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        emit Locked(msg.sender, amount, nonce, targetChainId);
    }

    /**
     * @dev Step 2: Release/Mint tokens on Destination Chain
     * Verification of validator signature is mandatory to prevent unauthorized minting.
     */
    function releaseAsset(
        address user,
        uint256 amount,
        uint256 nonce,
        bytes memory signature
    ) external {
        bytes32 messageHash = keccak256(abi.encodePacked(user, amount, nonce));
        bytes32 ethSignedMessageHash = messageHash.toEthSignedMessageHash();

        require(!processedMessages[ethSignedMessageHash], "Already processed");
        require(ethSignedMessageHash.recover(signature) == validator, "Invalid signature");

        processedMessages[ethSignedMessageHash] = true;
        
        // Logic to transfer local asset or mint wrapped asset goes here
        emit Released(user, amount, nonce);
    }

    function updateValidator(address _newValidator) external onlyOwner {
        validator = _newValidator;
    }
}
