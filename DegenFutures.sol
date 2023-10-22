// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DegenFutures {
    uint256 public price = 3000000000000000; // Start price at .003 ETH in wei
    address public owner;
    address[] public walletAddresses;
    uint256 public totalWallets;

    mapping(address => uint256) public contributorCounts;
    mapping(address => bool) public isActiveContributor;

    struct Trade {
        uint256 transactionNumber;
        string action;
        address walletAddress;
        uint256 contractValue;
        uint256 newPrice;
    }

    Trade[] public trades;

    event Contributed(address indexed contributor, uint256 amount);
    event Burned(address indexed contributor, uint256 amount);
    event FundsWithdrawn(address indexed owner, uint256 amount);

    constructor() {
        owner = msg.sender;
        totalWallets = 0;
    }

    receive() external payable {
        executeTrade("contribute");
    }



    function burn() external {
        require(contributorCounts[msg.sender] > 0, "You are not a contributor");
        executeTrade("burn");
    }

    function removeAddressFromArray(address _address) internal {
        for (uint256 i = 0; i < walletAddresses.length; i++) {
            if (walletAddresses[i] == _address) {
                walletAddresses[i] = walletAddresses[walletAddresses.length - 1];
                walletAddresses.pop();
                totalWallets--;
                return;
            }
        }
    }

    function transfer(address original, address destination) external {
        require(msg.sender == owner, "Only the owner can call this function");
        require(original != destination, "Original and destination addresses cannot be the same");
        require(contributorCounts[original] > 0, "Original address does not have enough contributor count to transfer");

        // Transfer one contributor count from original to destination
        contributorCounts[original] -= 1;
        contributorCounts[destination] += 1;

        // Check and update contributor activity status
        isActiveContributor[destination] = true;
        isActiveContributor[original] = (contributorCounts[original] > 0);

        // Replace the original address with the destination address in the walletAddresses array
        for (uint256 i = 0; i < walletAddresses.length; i++) {
            if (walletAddresses[i] == original) {
                walletAddresses[i] = destination;
                break;
            }
        }
    }

    function executeTrade(string memory action) internal {
        uint256 currentPrice = price;

        if (keccak256(abi.encodePacked(action)) == keccak256("contribute")) {
            require(msg.value == price, "Sent amount does not match the current price");

            walletAddresses.push(msg.sender);
            totalWallets++;
            contributorCounts[msg.sender] += 1;
            isActiveContributor[msg.sender] = true;

            price = (price * 110) / 100;

            emit Contributed(msg.sender, msg.value);
        } else {
            require(contributorCounts[msg.sender] > 0, "You are not a contributor");

            uint256 newPrice = (currentPrice * 90) / 100;
            uint256 payout = newPrice - (newPrice / 10);

            payable(msg.sender).transfer(payout);
            price = newPrice;

            contributorCounts[msg.sender] -= 1;
            removeAddressFromArray(msg.sender);

            if (contributorCounts[msg.sender] == 0) {
                isActiveContributor[msg.sender] = false;
            }

            emit Burned(msg.sender, payout);
        }

        trades.push(Trade({
            transactionNumber: trades.length + 1,
            action: action,
            walletAddress: msg.sender,
            contractValue: address(this).balance,
            newPrice: price
        }));
    }

    function getAllTrades() external view returns (Trade[] memory) {
        return trades;
    }

    function getAllWalletAddresses() external view returns (address[] memory) {
        return walletAddresses;
    }

    function withdraw() external {
        require(msg.sender == owner, "Only the owner can withdraw funds");
        uint256 amount = address(this).balance;
        payable(owner).transfer(amount);
        emit FundsWithdrawn(owner, amount);
    }
}
