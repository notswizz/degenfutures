# DegenFutures 

## Overview
The `DegenFutures` is a Solidity smart contract designed to handle transactions involving Ethereum (ETH) for a prediction market related to the NFL Super Bowl. Users can contribute to or withdraw from the contract at a dynamically changing price.

## State Variables
- `price`: The current price to contribute to the contract, initially set to 0.003 ETH in wei.
- `owner`: The address of the contract owner.
- `walletAddresses`: An array that stores the addresses of all the contributors.
- `totalWallets`: A counter for the total number of contributing wallets.
- `contributorCounts`: A mapping to track the number of contributions made by each address.
- `isActiveContributor`: A mapping to keep track of whether an address is an active contributor.
- `trades`: An array of `Trade` structs that record all trades.

## Struct
- `Trade`: Records a transaction, capturing details like transaction number, action type ("contribute" or "burn"), wallet address, contract balance, and the new price post-trade.

## Events
- `Contributed`: Emitted when a contribution is made.
- `Burned`: Emitted when a contribution is "burned" or sold.
- `FundsWithdrawn`: Emitted when the contract owner withdraws funds.

## Constructor
- Sets the `owner` as the address deploying the contract and initializes `totalWallets` to 0.

## Functions

### Public Functions
1. `contribute()`: Allows users to contribute ETH to the contract.
2. `burn()`: Allows contributors to "burn" or sell their shares.
3. `transfer()`: Allows the contract owner to transfer contributor counts between addresses.
4. `getAllTrades()`: Returns an array of all trades.
5. `getAllWalletAddresses()`: Returns an array of all wallet addresses.
6. `withdraw()`: Allows the contract owner to withdraw all ETH from the contract.

### Internal Functions
1. `executeTrade()`: Handles the core logic for both "contribute" and "burn" operations.
2. `removeAddressFromArray()`: Used in the `burn()` function to remove an address from the `walletAddresses` array.

## Access Control
- Several functions have prerequisites for execution. For example, only the owner can execute `transfer()` and `withdraw()`. An address must have contributed at least once to execute `burn()`.
