# 🎯 Attack Vector Priority Matrix - ZSA Attackathon 2025

## Quick Reference: What to Test First

### 🔴 CRITICAL PRIORITY (Test First - Highest Impact)

| Contract | Attack Vector | Likelihood | Impact | Functions to Test |
|----------|--------------|------------|--------|-------------------|
| **Pool** | Reentrancy in withdraw/borrow | HIGH | CRITICAL | `withdraw()`, `borrow()`, `repay()`, `liquidate()` |
| **Pool** | Flash loan manipulation | HIGH | CRITICAL | `flashLoan()`, `flashLoanSimple()` |
| **AaveOracle** | Price manipulation | MEDIUM | CRITICAL | `setAssetSources()`, `getAssetPrice()` |
| **SavingsDaiOracle** | Stale price exploitation | MEDIUM | CRITICAL | `latestAnswer()` |
| **ACLManager** | Role takeover | LOW | CRITICAL | `grantRole()`, `revokeRole()` |
| **PoolConfigurator** | Unauthorized config change | MEDIUM | CRITICAL | `configureReserveAsCollateral()`, `setReserveBorrowing()` |
| **Proxy (all)** | Implementation takeover | LOW | CRITICAL | `upgradeTo()`, `upgradeToAndCall()` |

### 🟡 HIGH PRIORITY (Test Second)

| Contract | Attack Vector | Likelihood | Impact | Functions to Test |
|----------|--------------|------------|--------|-------------------|
| **RewardsController** | Reward inflation | MEDIUM | HIGH | `claimRewards()`, `handleAction()` |
| **Collector** | Unauthorized withdrawal | LOW | HIGH | `transfer()`, `approve()` |
| **EmissionManager** | Emission manipulation | LOW | HIGH | `setEmissionPerSecond()` |
| **Pool** | Interest rate manipulation | LOW | HIGH | Supply/borrow affecting rates |

### 🟢 MEDIUM PRIORITY (Test Third)

| Contract | Attack Vector | Likelihood | Impact | Functions to Test |
|----------|--------------|------------|--------|-------------------|
| **WrappedTokenGateway** | ETH stuck/stolen | MEDIUM | MEDIUM | `depositETH()`, `withdrawETH()` |
| **PoolAddressesProvider** | Address poisoning | LOW | MEDIUM | `setAddress()`, `setPoolImpl()` |

---

## 🎯 Attack Vector Deep Dive

### 1. REENTRANCY ATTACKS (Highest Priority)

**Target**: Pool contract

**Critical Functions**:
```solidity
- withdraw() / withdrawETH()
- borrow() 
- repay()
- liquidationCall()
- flashLoan()
- flashLoanSimple()
```

**Test Strategy**:
1. Deploy malicious contract with receive/fallback
2. Trigger external call from Pool
3. Re-enter Pool before state updates
4. Drain funds

**PoC Template**:
```solidity
contract ReentrancyAttacker {
    IPool public pool;
    bool attacked;
    
    function attack() external {
        // Initial interaction
        pool.withdraw(asset, amount, address(this));
    }
    
    receive() external payable {
        if (!attacked) {
            attacked = true;
            // Re-enter here
            pool.withdraw(asset, amount, address(this));
        }
    }
}
```

---

### 2. FLASH LOAN EXPLOITS (Highest Priority)

**Target**: Pool contract

**Attack Scenarios**:
- **Scenario A**: Flash loan + Price manipulation
  1. Flash loan large amount
  2. Manipulate oracle price
  3. Borrow against inflated collateral
  4. Repay flash loan
  5. Keep borrowed funds

- **Scenario B**: Flash loan + Reentrancy
  1. Flash loan
  2. Re-enter during callback
  3. Manipulate accounting
  4. Profit

- **Scenario C**: Flash loan fee bypass
  1. Find way to return without fee
  2. Free flash loans = arbitrage

**Test Strategy**:
```solidity
contract FlashLoanAttacker is IFlashLoanReceiver {
    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    ) external returns (bool) {
        // EXPLOIT HERE
        // 1. Use borrowed funds
        // 2. Manipulate protocol state
        // 3. Profit
        
        // Approve payback
        IERC20(assets[0]).approve(address(pool), amounts[0] + premiums[0]);
        return true;
    }
}
```

---

### 3. ORACLE MANIPULATION (Critical Impact)

**Targets**: AaveOracle, SavingsDaiOracle

**Attack Scenarios**:

**Scenario A - Stale Price**:
```solidity
// If oracle doesn't check staleness:
1. Wait for price to be stale
2. Use outdated favorable price
3. Borrow more than should be allowed
4. Default on loan (profit = borrowed - collateral)
```

**Scenario B - Source Manipulation**:
```solidity
// If setAssetSources is vulnerable:
1. Gain access to setAssetSources()
2. Point to malicious price feed
3. Set price to MAX
4. Borrow entire protocol
```

**Scenario C - Chainlink Issues**:
```solidity
// Check for:
- No minAnswer/maxAnswer checks
- No sequencer uptime check (L2)
- No round completeness check
- Negative prices not handled
```

**Test Checklist**:
- [ ] Can stale prices be used?
- [ ] Can price source be changed?
- [ ] Are prices validated (> 0)?
- [ ] Are decimals handled correctly?
- [ ] Can prices be manipulated via the source?

---

### 4. ACCESS CONTROL BYPASS (Protocol Takeover)

**Target**: ACLManager, PoolConfigurator, All Admin Functions

**Critical Checks**:

```solidity
// 1. Role initialization
- Is DEFAULT_ADMIN_ROLE set correctly?
- Can roles be granted in constructor/initialize?
- Is there a backdoor admin?

// 2. Role checks
- Are all critical functions protected?
- Can modifiers be bypassed?
- Are there public functions that should be restricted?

// 3. Role management
- Can attacker grant themselves roles?
- Can attacker revoke admin roles?
- Are there privilege escalation paths?
```

**Test Strategy**:
1. Map all privileged functions
2. Try calling as non-admin
3. Look for initialization issues
4. Check for missing modifiers
5. Test role grant/revoke logic

---

### 5. PROXY VULNERABILITIES (Complete Takeover)

**Targets**: All proxy contracts

**Attack Scenarios**:

**Scenario A - Uninitialized Implementation**:
```solidity
// If implementation is not initialized:
1. Call initialize() on implementation (not proxy)
2. Become admin of implementation
3. selfdestruct implementation
4. Proxy points to dead code
```

**Scenario B - Re-initialization**:
```solidity
// If initialize() can be called twice:
1. Call initialize() after deployment
2. Set yourself as admin
3. Control protocol
```

**Scenario C - Storage Collision**:
```solidity
// If implementation storage overlaps proxy storage:
1. Modify implementation variables
2. Accidentally modify proxy admin slot
3. Take over proxy
```

**Scenario D - Unauthorized Upgrade**:
```solidity
// If upgradeTo() is unprotected:
1. Deploy malicious implementation
2. Call upgradeTo(maliciousImpl)
3. Drain all funds
```

**Test Checklist**:
- [ ] Is implementation initialized?
- [ ] Can initialize() be called twice?
- [ ] Is upgradeTo() properly protected?
- [ ] Are storage slots correct?
- [ ] Can admin be changed?

---

### 6. ACCOUNTING EXPLOITS (Fund Theft)

**Target**: Pool, RewardsController

**Attack Scenarios**:

**Scenario A - Rounding Errors**:
```solidity
// Look for division before multiplication:
shares = (amount * totalShares) / totalAssets;  // Can lose precision
// vs
shares = (amount / totalAssets) * totalShares;  // Worse

// Exploit:
1. Make many small deposits
2. Each loses 1 wei to rounding
3. 1M deposits = steal 1M wei from pool
```

**Scenario B - Integer Overflow in Unchecked**:
```solidity
unchecked {
    userBalance += amount;  // If this overflows, balance wraps
}
// Exploit: Overflow to get huge balance
```

**Scenario C - Share Manipulation**:
```solidity
// First depositor attack:
1. Be first depositor
2. Deposit 1 wei
3. Transfer large amount directly to pool
4. Next depositor gets 0 shares due to rounding
5. First depositor steals their deposit
```

---

### 7. LIQUIDATION EXPLOITS (Bad Debt Creation)

**Target**: Pool liquidation logic

**Attack Scenarios**:

**Scenario A - Self Liquidation**:
```solidity
1. Borrow to liquidation threshold
2. Liquidate your own position
3. Get liquidation bonus
4. Profit from bonus
```

**Scenario B - Bad Debt Creation**:
```solidity
1. Find way to borrow without proper collateral
2. Price drops
3. Position becomes unliquidatable (bad debt)
4. Protocol loses funds
```

**Test Checklist**:
- [ ] Can user self-liquidate?
- [ ] Can liquidation be front-run?
- [ ] Is liquidation bonus exploitable?
- [ ] Can bad debt be created?
- [ ] Are liquidation thresholds enforced?

---

### 8. REWARD MANIPULATION (Token Theft)

**Target**: RewardsController, EmissionManager

**Attack Scenarios**:

**Scenario A - Multiple Claims**:
```solidity
1. Accrue rewards
2. Claim rewards
3. If state not updated, claim again
4. Drain reward pool
```

**Scenario B - Index Manipulation**:
```solidity
1. Manipulate reward index calculation
2. Get higher rewards than deserved
3. Drain reward pool
```

**Scenario C - Transfer Hook Exploit**:
```solidity
1. Trigger reward accrual
2. Transfer tokens to manipulate balance
3. Claim inflated rewards
```

---

## 🔍 SYSTEMATIC TESTING PROCESS

### For Each Contract:

#### Step 1: Static Analysis (30 min)
```bash
# Run Slither
slither src/ContractName --print human-summary

# Check for common issues
slither src/ContractName --detect reentrancy-eth
slither src/ContractName --detect uninitialized-state
```

#### Step 2: Manual Review (2-4 hours)
- [ ] Read entire contract
- [ ] Mark all state-changing functions
- [ ] Mark all external calls
- [ ] Check all access controls
- [ ] Look for patterns from this matrix

#### Step 3: PoC Development (2-8 hours)
- [ ] Write test for vulnerability
- [ ] Prove it works on fork
- [ ] Calculate exact impact
- [ ] Document steps

#### Step 4: Documentation (1-2 hours)
- [ ] Write bug report
- [ ] Take screenshots
- [ ] Explain root cause
- [ ] Suggest fix

---

## 📊 IMPACT CALCULATION

### For Fund Theft:
```
Impact = min(
    Amount that can be stolen,
    Total Value Locked (TVL) of protocol
)
```

### For Oracle Manipulation:
```
Impact = (Total Borrowable with fake price) - (Real Collateral Value)
```

### For Access Control:
```
Impact = Total protocol TVL (full control)
```

---

## 🎯 DAILY TESTING PLAN

### Week 1: Core Pool
- **Day 1**: Pool reentrancy (withdraw, borrow, repay)
- **Day 2**: Pool flash loans
- **Day 3**: Pool liquidations
- **Day 4**: Pool accounting/rounding
- **Day 5**: Pool access control
- **Day 6-7**: Document findings

### Week 2: Oracles & Configuration
- **Day 8**: AaveOracle price manipulation
- **Day 9**: SavingsDaiOracle attacks
- **Day 10**: PoolConfigurator exploits
- **Day 11**: ACLManager bypass attempts
- **Day 12-13**: Cross-contract attacks
- **Day 14**: Document findings

### Week 3: Periphery & Rewards
- **Day 15**: RewardsController exploits
- **Day 16**: EmissionManager manipulation
- **Day 17**: Collector theft vectors
- **Day 18**: WrappedTokenGateway issues
- **Day 19-20**: Proxy vulnerabilities
- **Day 21**: Document findings

### Week 4: Polish & Submit
- **Day 22-23**: Verify all PoCs
- **Day 24-25**: Complete all documentation
- **Day 26-27**: Take screenshots
- **Day 28**: Final review and submission

---

## ⚠️ REMEMBER

1. **Test on fork only** - Never touch mainnet
2. **Document everything** - Screenshots, steps, impact
3. **Focus on critical** - Only submit high-impact bugs
4. **Reproducible PoC required** - Must work reliably
5. **Professional reports** - Clear, detailed, actionable

---

## 🚀 QUICK START

To start testing TODAY:

1. Pick: **Pool contract reentrancy**
2. Read: `Pool.sol` withdraw function
3. Write: PoC based on template
4. Test: Run on mainnet fork
5. Document: If successful, write report

**Time estimate**: 4-6 hours for first finding

Good luck! 🎯

