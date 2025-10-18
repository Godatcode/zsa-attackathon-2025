// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "forge-std/console.sol";

/**
 * @title BaseTest
 * @notice Base test contract for ZSA Attackathon 2025
 * @dev All PoC tests should inherit from this contract
 */
contract BaseTest is Test {
    // Common test addresses
    address public attacker = address(0xBAD);
    address public victim = address(0x1234);
    address public admin = address(0xADDE);
    address public user1 = address(0x1111);
    address public user2 = address(0x2222);
    
    // Mainnet fork setup
    uint256 public mainnetFork;
    
    // Common test constants
    uint256 constant INITIAL_BALANCE = 100_000 ether;
    uint256 constant LARGE_BALANCE = 1_000_000 ether;
    
    function setUp() public virtual {
        // Create mainnet fork - update RPC URL as needed
        // mainnetFork = vm.createFork("https://eth-mainnet.g.alchemy.com/v2/YOUR_KEY");
        // vm.selectFork(mainnetFork);
        
        // Fund test addresses
        vm.deal(attacker, INITIAL_BALANCE);
        vm.deal(victim, INITIAL_BALANCE);
        vm.deal(admin, INITIAL_BALANCE);
        vm.deal(user1, INITIAL_BALANCE);
        vm.deal(user2, INITIAL_BALANCE);
        
        console.log("=== Base Test Setup Complete ===");
        console.log("Attacker:", attacker);
        console.log("Victim:", victim);
    }
    
    // Helper function to log balances
    function logBalances(string memory stage) internal view {
        console.log("\n=== Balances:", stage, "===");
        console.log("Attacker ETH:", attacker.balance);
        console.log("Victim ETH:", victim.balance);
    }
    
    // Helper to advance time
    function advanceTime(uint256 seconds_) internal {
        vm.warp(block.timestamp + seconds_);
        vm.roll(block.number + (seconds_ / 12)); // ~12 sec per block
    }
    
    // Helper to advance blocks
    function advanceBlocks(uint256 blocks) internal {
        vm.roll(block.number + blocks);
        vm.warp(block.timestamp + (blocks * 12));
    }
}

