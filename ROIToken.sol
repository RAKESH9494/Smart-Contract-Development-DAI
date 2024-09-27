// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// Simple ERC-20 Token for testing
contract ROIToken is ERC20, Ownable(msg.sender){
    uint256 public pegValue;

    constructor() ERC20("ROI Token","ROI") {
        _mint(address(this), 1000000 * (10 ** uint256(decimals()))); // Mint 1 million tokens to contract
        pegValue = 100;
    }

    function mintROI(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burnROI(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
    }

    function getPegValue() external view returns (uint256) {
        return pegValue;
    }

    function setPegValue(uint256 newPegValue) external onlyOwner {
        pegValue = newPegValue;
    }
}
