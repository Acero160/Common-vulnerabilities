// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/*
1. Yolanda deploys the contract with a balance of "X" ethers.
2. Alice finds the correct word, which is "Top Polkadot", and calls the `solve` function, but she does with the minimum amount required.
3. Bob is looking the mempool and sees Alice's transaction, so he executes the same transaction but pays a much higher gas fee.
4. Bob's transaction is mined or validated before Alice's (even though she was the first to guess the word), and therefore, Bob wins the prize.
*/

contract FindTheWord {

    bytes32 public constant secretHash = 0xf65840f7453890433a4aeb4dea60bafb05399ca1e8d6f6365cd5f0dcfd69c165;
    constructor () payable {}

    function solve (string memory solution) external {
        require(secretHash == keccak256(abi.encodePacked(solution)), "Incorrect answer");

        (bool sent, ) = msg.sender.call{ value: 2 ether }("");
        require(sent, "Failed to send ethers");

    }
}