# degenfutures


This is a Solidity smart contract named DegenFutures. The contract is designed to handle transactions involving Ethereum (ETH) for a kind of prediction market related to the NFL Super Bowl. Users can buy into the contract ("contribute") or sell their share ("burn") at a dynamically changing price. 

State Variables
price: Initially set to 0.003 ETH in wei. This is the current price to contribute to the contract.
owner: Stores the address of the contract owner.
walletAddresses: An array storing the addresses of contributors.
totalWallets: Count of total contributing wallets.
contributorCounts: Mapping to track the number of contributions made by each address.
isActiveContributor: Mapping to track if an address is an active contributor.
trades: An array of Trade structs to record all trades.
Struct
Trade: Records information about a transaction. It keeps track of the transaction number, action type ("contribute" or "burn"), wallet address involved, the contract's balance, and the new price after the trade.

Events
Contributed: Emitted when someone contributes to the contract.
Burned: Emitted when someone "burns" their contribution.
FundsWithdrawn: Emitted when the owner withdraws funds.
Constructor
Initializes the owner to the address that deploys the contract and sets totalWallets to 0.
receive() Function
Allows the contract to receive ETH by calling executeTrade() with "contribute" as an argument.

Functions
Public Functions
contribute(): Allows an address to contribute ETH to the contract, adds it to the contributors list, and updates the price.
burn(): Allows a contributor to sell and "burn" their share, which then decreases the contract's price.
transfer(): Allows the contract's owner to transfer one contributor count from one address to another.
getAllTrades(): Returns all trades that have occurred.
getAllWalletAddresses(): Returns all wallet addresses that have contributed.
withdraw(): Allows the owner to withdraw all ETH from the contract.
Internal Functions
executeTrade(): The core logic for both "contribute" and "burn" operations. Updates the price, wallet counts, and emits events accordingly.
removeAddressFromArray(): Removes an address from the walletAddresses array. Used in the "burn" function to clean up.

Access Control
Several functions have conditions that must be met for the function to execute. For instance, only the owner can execute the transfer() and withdraw() functions. Additionally, an address must have contributed at least once to execute the burn() function.
