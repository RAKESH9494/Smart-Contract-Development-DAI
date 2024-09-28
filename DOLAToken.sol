// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./BDOLAToken.sol";
import "./ROIToken.sol";

// DOLA Token with a pegging mechanism
contract DOLAToken is ERC20, Ownable(msg.sender){

    BDOLAToken public collateralToken;
    ROIToken public pegToken;
    uint256 public constant collateralizationRatio = 200; // 200% Collateralization

    constructor(address _collateralToken, address _pegToken) ERC20("DOLA", "DOLA") {
        collateralToken = BDOLAToken(_collateralToken);
        pegToken = ROIToken(_pegToken);
    }

    // Mint DOLA tokens if the user deposits BDOLA as collateral
    function mintDOLA(uint256 _collateralAmount) external{
        require(_collateralAmount > 0, "Collateral amount should be greater than zero");

        // Transfer BDOLA from the user to the contract
        collateralToken.transferToken(msg.sender, address(this), _collateralAmount);

        uint256 dolaToMint = (_collateralAmount* getPegValue()) / collateralizationRatio;
        _mint(msg.sender, dolaToMint * (10 ** uint256(decimals())));

    }

    // Burn DOLA tokens and return collateral to the user
    function burnDOLA(uint256 _dolaAmount) external {
        require(balanceOf(msg.sender) >= _dolaAmount, "Insufficient DOLA balance");

        // Burn DOLA tokens
        _burn(msg.sender, _dolaAmount* (10 ** uint256(decimals())));

        // Calculate collateral to return
        uint256 collateralToReturn = (_dolaAmount * collateralizationRatio) / getPegValue();
        require(collateralToken.balanceOf(address(this)) >= collateralToReturn, "Insufficient collateral in contract");

        // Transfer BDOLA back to the user
        collateralToken.transferToken(address(this),msg.sender, collateralToReturn);
    }

    function getPegValue() public  view returns (uint){
        return pegToken.getPegValue();
    }

    function setPegValue( uint _newPegValue) public{
        pegToken.setPegValue(_newPegValue);
    }
}
