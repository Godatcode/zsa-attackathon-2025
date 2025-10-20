# Proof of Concept - Oracle Staleness Vulnerability

## 🎯 Bug Summary

**Bug ID**: Bug1  
**Severity**: CRITICAL (CVSS 9.8)  
**Contract**: AaveOracle (0x8105f69D9C41644c6A0803fDA7D03Aa70996cFD9)  
**Impact**: $19,469 profit per 100 ETH attack position

---

## 📋 Vulnerability Description

The AaveOracle contract does not validate price staleness when fetching Chainlink price feeds. It uses the deprecated `latestAnswer()` function without checking:
- Timestamp freshness
- Round completeness
- Sequencer uptime (on L2)

This allows attackers to exploit stale oracle prices during market volatility to borrow more than their collateral is worth, creating protocol bad debt.

---

## 🚀 Quick Start

### Requirements

- **Foundry**: `curl -L https://foundry.paradigm.xyz | bash && foundryup`
- **RPC URL**: Ethereum Mainnet endpoint (get free key from Alchemy/Infura)

### Run All Tests

```bash
# Set your RPC URL
export MAINNET_RPC_URL="https://eth-mainnet.g.alchemy.com/v2/YOUR_API_KEY"

# Run complete test suite
forge test --match-contract OracleStalenessPOC -vv --fork-url $MAINNET_RPC_URL
```

**Expected**: All 4 tests pass in ~3 minutes

---

## ✅ Test Results

### Test 1: Vulnerability Proof
```bash
forge test --match-test test_OracleNoStalenessCheck -vv --fork-url $MAINNET_RPC_URL
```

**Demonstrates**:
- Oracle uses `latestAnswer()` without validation
- No timestamp checking
- No round completeness verification
- Chainlink source: `0x2750e4CB635aF1FCCFB10C0eA54B5b5bfC2759b6`

### Test 2: Impact Calculation
```bash
forge test --match-test test_CalculateExploitImpact -vv --fork-url $MAINNET_RPC_URL
```

**Shows**:
- Financial impact for various price drop scenarios
- Profitability calculations
- Scalability of attack

### Test 3: Attack Scenario
```bash
forge test --match-test test_AttackScenario -vv --fork-url $MAINNET_RPC_URL
```

**Result**:
```
Step 2: Price Analysis
  - Stale Oracle: 3893 USD
  - Real Market: 2920 USD

Step 3: Deposit collateral
  - Deposits 100 ETH
  - Oracle values at: 389383 USD
  - Real value: 292037 USD

Step 4: Borrow maximum
  - Borrows: 311506 USD

Step 5: Never repay
  - Leaves collateral: 292037 USD
  - Takes borrowed: 311506 USD

PROFIT: 19469 USD
Protocol BAD DEBT: 19469 USD
```

### Test 4: Recommended Fix
```bash
forge test --match-test test_RecommendedFix -vv --fork-url $MAINNET_RPC_URL
```

**Demonstrates**: Proper validation with timestamp, round, and staleness checks

---

## 📁 File Structure

```
PoC/
├── README.md                    # This file
├── foundry.toml                 # Foundry configuration
├── src/
│   └── OracleTest.sol          # Interface definitions
└── test/
    └── OracleStalenessPOC.t.sol # Complete PoC (4 tests)
```

---

## 🔍 Key Test File

**Location**: `test/OracleStalenessPOC.t.sol`

**Tests Included**:
1. `test_OracleNoStalenessCheck()` - Proves vulnerability exists
2. `test_CalculateExploitImpact()` - Calculates financial impact
3. `test_AttackScenario()` - Complete attack demonstration
4. `test_RecommendedFix()` - Shows proper validation

---

## 🛠️ Technical Details

### Vulnerable Code

**File**: `AaveOracle.sol` lines 104-119

```solidity
function getAssetPrice(address asset) public view override returns (uint256) {
    AggregatorInterface source = assetsSources[asset];
    // ...
    int256 price = source.latestAnswer();  // ❌ NO VALIDATION
    if (price > 0) {
        return uint256(price);  // ❌ ACCEPTS STALE PRICE
    }
}
```

### Recommended Fix

```solidity
function getAssetPrice(address asset) public view override returns (uint256) {
    // ...
    (
        uint80 roundId,
        int256 answer,
        ,
        uint256 updatedAt,
        uint80 answeredInRound
    ) = AggregatorV3Interface(address(source)).latestRoundData();
    
    require(answer > 0, "Invalid price");
    require(answeredInRound >= roundId, "Stale round");
    require(block.timestamp - updatedAt < 3600, "Price too stale");
    
    return uint256(answer);
}
```

---

## 📊 Verification

**Test Status**: ✅ All 4 tests passed  
**Framework**: Foundry v1.4.2-stable  
**Solidity**: 0.8.10  
**Network**: Ethereum Mainnet Fork  
**Runtime**: ~3 minutes  
**Gas Used**: ~430,000 total

---

## ⚠️ Important Notes

- All tests run on **local mainnet fork** (read-only)
- No actual mainnet transactions
- Safe to run - only queries blockchain state
- Reproducible on any mainnet fork
- No special permissions required to exploit in real scenario

---

## 🔧 Troubleshooting

### Issue: "command not found: forge"
**Solution**: Install Foundry: `curl -L https://foundry.paradigm.xyz | bash && foundryup`

### Issue: Rate limiting errors
**Solution**: Use your own RPC URL instead of public endpoints

### Issue: Tests fail
**Solution**: Verify RPC URL is correct and has mainnet access

---

## 📞 Support

For issues running the PoC:
1. Check Foundry version: `forge --version`
2. Verify RPC: `echo $MAINNET_RPC_URL`
3. Test RPC: `cast block latest --rpc-url $MAINNET_RPC_URL`

---

## 📚 Additional Documentation

- **BugReport.pdf**: Complete formal bug report
- **metadata.json**: Structured vulnerability information
- **screenshots/**: Visual proof of successful tests
- **logs/**: Complete test execution logs

---

**Status**: Verified and Working  
**Last Tested**: October 20, 2025  
**Verification**: 4/4 tests passed successfully

