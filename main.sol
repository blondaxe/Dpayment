// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenTransferWithFee {
    address public owner;

    // Event to notify every transfert with fees
    event TransferWithFee(address indexed sender, address indexed recipient, uint256 amount, uint256 feeAmount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function transferWithFee(address tokenAddress, address recipient, uint256 amount) external onlyOwner {
        require(recipient != address(0), "Invalid recipient address");
        require(amount > 0, "Amount must be greater than zero");

        // Transfert tokens to the recipient
        IERC20 token = IERC20(tokenAddress);
        uint256 feeAmount = amount / 100; // Calculate 1% amount of fee
        uint256 transferAmount = amount - feeAmount;

        // Make the transfert
        token.transfer(recipient, transferAmount);

        // Send fee
        token.transfer(address(this), feeAmount);

        emit TransferWithFee(msg.sender, recipient, transferAmount, feeAmount);
    }

    // Fonction to allow the owner to take the tokens
    function recoverTokens(address tokenAddress, uint256 amount) external onlyOwner {
        IERC20(tokenAddress).transfer(owner, amount);
    }
}
