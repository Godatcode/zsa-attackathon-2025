# 🔍 ZSA Attackathon 2025 - Comprehensive Audit Checklist

## Critical Vulnerabilities Focus (As per Competition Rules)

Only vulnerabilities meeting these criteria:
- ✅ Direct theft or loss of funds
- ✅ Irreversible protocol state corruption or fund lockout
- ✅ Unauthorized privilege escalation or protocol takeover
- ✅ Critical oracle manipulation leading to massive loss
- ✅ Bypassing core access controls or withdrawal limits
- ✅ Reentrancy, overflow, or logic flaws resulting in complete fund drain

---

## 🎯 HIGH PRIORITY CONTRACTS

### 1. Pool (0x5ae329203e00f76891094dcfedd5aca082a50e1b) - CRITICAL
**Why Critical**: Core lending pool, handles all user funds

#### Attack Vectors to Test:
- [ ] **Reentrancy Attacks**
  - [ ] Supply function reentrancy
  - [ ] Withdraw function reentrancy
  - [ ] Borrow function reentrancy
  - [ ] Repay function reentrancy
  - [ ] Liquidation reentrancy
  - [ ] Flash loan callback reentrancy

- [ ] **Flash Loan Exploits**
  - [ ] Flash loan fee bypass
  - [ ] Flash loan reentrancy
  - [ ] Flash loan + price manipulation combo
  - [ ] Flash loan receiver validation bypass

- [ ] **Accounting Issues**
  - [ ] Interest calculation overflow/underflow
  - [ ] Share/amount conversion errors
  - [ ] Rounding errors that can be exploited
  - [ ] Reserve accounting manipulation

- [ ] **Liquidation Logic**
  - [ ] Liquidation threshold bypass
  - [ ] Self-liquidation exploits
  - [ ] Liquidation bonus manipulation
  - [ ] Bad debt creation

- [ ] **Access Control**
  - [ ] Emergency pause bypass
  - [ ] Admin function access
  - [ ] Configurator bypass

---

### 2. AaveOracle (0x8105f69D9C41644c6A0803fDA7D03Aa70996cFD9) - CRITICAL
**Why Critical**: Price manipulation = massive theft potential

#### Attack Vectors to Test:
- [ ] **Price Manipulation**
  - [ ] Chainlink oracle manipulation
  - [ ] Stale price exploitation
  - [ ] Price source switching attack
  - [ ] Fallback oracle manipulation

- [ ] **Oracle Update Issues**
  - [ ] setAssetSources() access control
  - [ ] Unauthorized price source changes
  - [ ] Zero address price source

- [ ] **Price Calculation**
  - [ ] Integer overflow in price conversion
  - [ ] Incorrect decimal handling
  - [ ] BASE_CURRENCY manipulation

---

### 3. SavingsDaiOracle (0xb9E6DBFa4De19CCed908BcbFe1d015190678AB5f) - CRITICAL
**Why Critical**: DAI-specific oracle, manipulation = loss of funds

#### Attack Vectors to Test:
- [ ] **Price Feed Manipulation**
  - [ ] Chainlink aggregator manipulation
  - [ ] Stale price detection bypass
  - [ ] Price deviation exploits

- [ ] **sDAI-specific Issues**
  - [ ] Conversion rate manipulation
  - [ ] Pot integration issues

---

### 4. ACLManager (0xdA135Cd78A086025BcdC87B038a1C462032b510C) - CRITICAL
**Why Critical**: Access control bypass = protocol takeover

#### Attack Vectors to Test:
- [ ] **Role Management**
  - [ ] Role grant/revoke bypass
  - [ ] DEFAULT_ADMIN_ROLE takeover
  - [ ] Role enumeration issues

- [ ] **Permission Checks**
  - [ ] isPoolAdmin() bypass
  - [ ] isEmergencyAdmin() bypass
  - [ ] isRiskAdmin() bypass
  - [ ] isAssetListingAdmin() bypass
  - [ ] isBridge() bypass

- [ ] **Role Hierarchy**
  - [ ] Role inheritance issues
  - [ ] Missing role checks

---

### 5. PoolConfigurator (0xf7b656c95420194b79687fc86d965fb51da4799f) - CRITICAL
**Why Critical**: Can break entire protocol configuration

#### Attack Vectors to Test:
- [ ] **Reserve Configuration**
  - [ ] Unauthorized reserve parameter changes
  - [ ] LTV/Liquidation threshold manipulation
  - [ ] Reserve cap bypass
  - [ ] Borrow cap manipulation

- [ ] **Asset Management**
  - [ ] Unauthorized asset listing
  - [ ] Asset freezing bypass
  - [ ] Pause mechanism issues

- [ ] **Access Control**
  - [ ] onlyPoolAdmin modifier bypass
  - [ ] onlyRiskOrPoolAdmin bypass
  - [ ] onlyAssetListingOrPoolAdmin bypass

---

### 6. RewardsController (0x0ee554f6a1f7a4cb4f82d4c124ddc2ad3e37fde1) - HIGH
**Why Critical**: Reward token manipulation = theft

#### Attack Vectors to Test:
- [ ] **Reward Calculation**
  - [ ] Reward accrual manipulation
  - [ ] Index update exploits
  - [ ] User balance manipulation

- [ ] **Claim Exploits**
  - [ ] Multiple claim attacks
  - [ ] Claim on behalf exploit
  - [ ] Reward dilution

---

### 7. Collector (0xf1e57711eb5f897b415de1aefcb64d9bae58d312) - HIGH
**Why Critical**: Treasury funds, direct theft target

#### Attack Vectors to Test:
- [ ] **Fund Withdrawal**
  - [ ] Unauthorized approve()
  - [ ] Unauthorized transfer()
  - [ ] setFundsAdmin() takeover

- [ ] **Access Control**
  - [ ] Admin bypass
  - [ ] Reentrancy on withdrawal

---

### 8. EmissionManager (0xf09e48dd4CA8e76F63a57ADd428bB06fee7932a4) - HIGH
**Why Critical**: Controls reward emissions

#### Attack Vectors to Test:
- [ ] **Emission Configuration**
  - [ ] setEmissionPerSecond manipulation
  - [ ] setDistributionEnd bypass
  - [ ] Unauthorized emission admin changes

---

### 9. Proxy Contracts - HIGH
**Why Critical**: Upgradeability = potential takeover

#### InitializableAdminUpgradeabilityProxy (Multiple instances)
- [ ] **Initialization**
  - [ ] Re-initialization attack
  - [ ] Uninitialized implementation
  - [ ] Initialize front-running

- [ ] **Upgrade Logic**
  - [ ] Unauthorized upgradeTo()
  - [ ] upgradeToAndCall() reentrancy
  - [ ] Admin takeover

- [ ] **Storage Collision**
  - [ ] Implementation storage collision
  - [ ] Proxy storage collision

#### InitializableImmutableAdminUpgradeabilityProxy (Multiple instances)
- [ ] **Immutable Admin Issues**
  - [ ] Constructor bypass
  - [ ] Admin address manipulation

---

### 10. WrappedTokenGatewayV3 (0xBD7D6a9ad7865463DE44B05F04559f65e3B11704) - MEDIUM
**Why Important**: ETH/WETH conversion point

#### Attack Vectors to Test:
- [ ] **ETH Handling**
  - [ ] depositETH() reentrancy
  - [ ] withdrawETH() reentrancy
  - [ ] ETH stuck in contract

- [ ] **WETH Wrapping**
  - [ ] Wrap/unwrap manipulation
  - [ ] Balance accounting

---

## 🔬 SYSTEMATIC TESTING APPROACH

### Phase 1: Automated Analysis
- [ ] Run Slither on all contracts
- [ ] Run Mythril on high-priority contracts
- [ ] Run Echidna fuzzing on critical functions

### Phase 2: Manual Code Review
- [ ] Read Pool.sol line by line
- [ ] Read Oracle contracts
- [ ] Read ACLManager
- [ ] Read Proxy implementations
- [ ] Check all external calls
- [ ] Check all state-changing functions

### Phase 3: Exploit Development
For each potential vulnerability:
- [ ] Write PoC test in Foundry
- [ ] Verify exploit works on fork
- [ ] Calculate exact impact
- [ ] Take screenshots
- [ ] Document steps

### Phase 4: Documentation
For each confirmed vulnerability:
- [ ] Write formal bug report
- [ ] Include root cause analysis
- [ ] Document impact assessment
- [ ] Provide fix recommendations
- [ ] Include complete PoC code
- [ ] Add 15+ screenshots

---

## 📊 COMMON VULNERABILITY PATTERNS

### Reentrancy Patterns to Check:
```solidity
// Pattern 1: External call before state update
externalContract.call();
balance[user] = 0;  // ❌ VULNERABLE

// Pattern 2: Check-Effect-Interaction violation
require(balance[user] > 0);
externalContract.call();  // ❌ VULNERABLE
balance[user] = 0;
```

### Access Control Patterns to Check:
```solidity
// Pattern 1: Missing modifier
function criticalFunction() public {  // ❌ VULNERABLE
    // no access check
}

// Pattern 2: Incorrect modifier
modifier onlyAdmin() {
    require(msg.sender == admin);  // Is admin properly set?
    _;
}
```

### Integer Overflow Patterns to Check:
```solidity
// Even with 0.8.x, check for:
// 1. Unchecked blocks
unchecked {
    value++;  // ❌ Can overflow
}

// 2. Type conversions
uint256 large = type(uint256).max;
uint128 small = uint128(large);  // ❌ Truncation
```

### Oracle Manipulation Patterns:
```solidity
// Pattern 1: No staleness check
int256 price = oracle.latestAnswer();  // ❌ Could be stale

// Pattern 2: No validation
function setOracle(address newOracle) {  // ❌ No zero-address check
    oracle = newOracle;
}
```

---

## 🎯 PRIORITY TESTING ORDER

1. **Week 1**: Pool contract (all attack vectors)
2. **Week 1-2**: Oracle contracts (price manipulation)
3. **Week 2**: ACLManager + PoolConfigurator (access control)
4. **Week 2-3**: Proxy contracts (upgradeability)
5. **Week 3**: RewardsController + EmissionManager
6. **Week 3**: Collector + WrappedTokenGateway
7. **Week 4**: Cross-contract attack vectors
8. **Week 4**: Documentation and submission prep

---

## 📝 SUBMISSION CHECKLIST

For each finding:
- [ ] Severity confirmed as CRITICAL
- [ ] Bug report written (formal format)
- [ ] PoC code complete and tested
- [ ] PoC demonstrates clear exploit
- [ ] Screenshots taken (15+ images minimum)
- [ ] Impact quantified ($ amount if possible)
- [ ] Fix recommendation provided
- [ ] All files organized in submission zipfile

---

## 🚨 RED FLAGS TO INVESTIGATE

When reviewing code, immediately investigate:
- ❗ Any `call()`, `delegatecall()`, `transfer()` before state updates
- ❗ Any `unchecked` blocks with arithmetic
- ❗ Any type conversions (uint256 → uint128, etc.)
- ❗ Any external calls in loops
- ❗ Any missing access control modifiers
- ❗ Any oracle price usage without staleness checks
- ❗ Any initialization functions (check re-initialization)
- ❗ Any approve() with type(uint256).max
- ❗ Any selfdestruct or delegatecall to user input
- ❗ Any assembly blocks
- ❗ Any commented-out security checks

---

## 📚 REFERENCE LINKS

- Solidity 0.8.x Docs: https://docs.soliditylang.org/en/v0.8.10/
- Aave V3 Docs: https://docs.aave.com/developers/
- Chainlink Docs: https://docs.chain.link/
- Foundry Book: https://book.getfoundry.sh/
- OpenZeppelin Contracts: https://docs.openzeppelin.com/contracts/4.x/

---

## 🎯 SUCCESS METRICS

- Minimum 1 critical vulnerability found and verified
- Complete PoC with reproducible steps
- Professional bug report
- Clear screenshots and documentation
- Submission follows all rules

**GOAL**: Find critical, high-impact vulnerabilities that result in direct theft or protocol takeover.

