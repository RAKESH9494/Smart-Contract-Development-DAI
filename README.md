### Overview

Here we have three contracts: `DOLAToken`, `BDOLAToken`, and `ROIToken`. 
The `DOLAToken` contract allows users to mint and burn DOLA tokens by depositing or redeeming BDOLA tokens as collateral. The DOLA token is pegged to an external value (using the ROIToken's peg value). 

### 1. **DOLAToken Contract**

#### Description:
The `DOLAToken` is an ERC-20 token that has a pegging mechanism, using the `ROIToken` for determining the value of the minted tokens. Users must deposit a collateral token (`BDOLAToken`) to mint DOLA, and they can burn DOLA to retrieve their collateral.

#### Components:

  - `ERC20`: Provides standard ERC-20 token functionality inherited from the openzeppelin.
  - `Ownable`: Restricts some functions to only be callable by the contract owner.
  
- **State Variables**:
  - `BDOLAToken public collateralToken`: Refers to the `BDOLAToken` contract, which acts as the collateral.
  - `ROIToken public pegToken`: Refers to the `ROIToken` contract, which holds the peg value that defines the price of the `DOLA` token.
  - `uint256 public constant collateralizationRatio`: This is the ratio (200%) that defines how much collateral is required to mint DOLA.

#### Functions:

- **Constructor**
  ```solidity
  constructor(address _collateralToken, address _pegToken)
  ```
  - Initializes the contract with the addresses of the `BDOLAToken` and `ROIToken` contracts.
  
- **mintDOLA**
  ```solidity
  function mintDOLA(uint256 _collateralAmount) external
  ```
  - Allows a user to mint DOLA by depositing BDOLA as collateral.
  - First, the user must transfer the specified amount of `BDOLAToken` to the contract.
  - The amount of DOLA tokens to be minted is calculated using the formula:
    
    dolaToMint = ( collateralAmount * pegValue )/ (collateralizationRatio)
    
  - Then, it mints the calculated DOLA to the user.

- **burnDOLA**
  ```solidity
  function burnDOLA(uint256 _dolaAmount) external
  ```
  - Allows a user to burn DOLA and get back their BDOLA collateral.
  - It first burns the user's DOLA tokens and calculates how much collateral (BDOLA) should be returned to the user.
  - The formula for collateral return is:
    
    collateralToReturn = ( collateralAmount * collateralizationRatio )/ ( pegValue)
  - It then transfers the calculated amount of BDOLA back to the user.

- **getPegValue**
  ```solidity
  function getPegValue() public view returns (uint)
  ```
  - Returns the current peg value from the `ROIToken`.

- **setPegValue**
  ```solidity
  function setPegValue(uint _newPegValue) public
  ```
  - Allows the owner to set a new peg value via the `ROIToken`.

### 2. **ROIToken Contract**

#### Description:
The `ROIToken` is a simple ERC-20 token contract used as the peg for `DOLAToken`. The peg value is used to calculate the minting and burning amounts in the `DOLAToken` contract.

#### Key Components:
  - `ERC20`: Provides standard ERC-20 functionality.
  - `Ownable`: Restricts specific functions to the owner.

#### State Variables:
- **uint256 public pegValue**: The peg value that is referenced by the `DOLAToken`. The default is set to 100.

#### Functions:

- **Constructor**
  ```solidity
  constructor() ERC20("ROI Token", "ROI")
  ```
  - Initializes the contract and mints 1 million ROI tokens to the contract itself.

- **mintROI**
  ```solidity
  function mintROI(address to, uint256 amount) external onlyOwner
  ```
  - Allows the owner to mint new `ROIToken` tokens to any specified address.

- **burnROI**
  ```solidity
  function burnROI(address from, uint256 amount) external onlyOwner
  ```
  - Allows the owner to burn a specified amount of `ROIToken` tokens from any address.

- **getPegValue**
  ```solidity
  function getPegValue() external view returns (uint256)
  ```
  - Returns the current peg value.

- **setPegValue**
  ```solidity
  function setPegValue(uint256 newPegValue) external onlyOwner
  ```
  - Allows the owner to change the peg value.

### 3. **BDOLAToken Contract (Not Provided but Expected)**

`BDOLAToken` is an ERC-20 token that mints a fixed amount of tokens when the contract is deployed. It allows users to buy tokens from the contract and transfer tokens between addresses.

### Key Components:

- **ERC20**: Provides the standard functionality of an ERC-20 token, including the ability to mint, transfer, and manage token balances.

### Constructor:
```solidity
constructor() ERC20("BDOLA Token", "BDOLA") {
    _mint(address(this), 1000 * (10 ** uint256(decimals()))); 
}
```
  - The constructor initializes the contract by minting 1,000 `BDOLA` tokens to the contract itself (`address(this)`).
  - The number of tokens minted is `1000` multiplied by `10^decimals()`, where `decimals()` typically returns 18, the default for most ERC-20 tokens.

### Functions:

**BuyToken**
  Allows users to buy `BDOLAToken` from the contract.
  
```solidity
function BuyToken(uint _amount) public
```
  - Checks if the contract has enough tokens (`BDOLA`) to sell.
  - If the contract has sufficient tokens, it transfers the specified amount of tokens to the buyer (the caller of the function).
  - The function utilizes the `transferToken` method to perform the token transfer.

**transferToken**
  Handles token transfers between addresses.

```solidity
function transferToken(address from, address to, uint amount) public
```
  - Calls the internal `_transfer` function provided by the `ERC20` contract to move `amount` tokens (scaled up by the token's decimal places) from `from` to `to`.
