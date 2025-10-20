# Oracle Staleness Vulnerability - Foundry PoC Setup

## 🎯 Bug Information

**Bug ID**: Bug1 (Critical)  
**Title**: Oracle Staleness - No Timestamp Validation  
**Contract**: AaveOracle (0x8105f69D9C41644c6A0803fDA7D03Aa70996cFD9)  
**Impact**: $19,469 profit per 100 ETH attack  
**Severity**: CRITICAL (CVSS 9.8)

---

## 📋 Requirements

- **Foundry**: `curl -L https://foundry.paradigm.xyz | bash && foundryup`
- **Ethereum Mainnet RPC URL**: Get free key from:
  - Alchemy: https://www.alchemy.com/
  - Infura: https://www.infura.io/
  - QuickNode: https://www.quicknode.com/

---

## 🚀 Quick Start

### Step 1: Install Foundry (if not already installed)

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### Step 2: Navigate to PoC Directory

```bash
cd "Foundry Folder/poc-standalone"
```

### Step 3: Set Your RPC URL

```bash
# Replace with your actual RPC URL
export MAINNET_RPC_URL="https://eth-mainnet.g.alchemy.com/v2/YOUR_API_KEY"
```

### Step 4: Run All Tests

```bash
forge test --match-contract OracleStalenessPOC -vv --fork-url $MAINNET_RPC_URL
```

---

## ✅ Expected Results

All 4 tests should pass:

```
[PASS] test_OracleNoStalenessCheck() (gas: 127359)
[PASS] test_CalculateExploitImpact() (gas: 95352)
[PASS] test_AttackScenario() (gas: 109563)
[PASS] test_RecommendedFix() (gas: 94816)

Suite result: ok. 4 passed; 0 failed; 0 skipped
```

**Runtime**: ~3 minutes (includes mainnet fork setup)

---

## 📊 Test Details

### Test 1: Prove Vulnerability Exists
```bash
forge test --match-test test_OracleNoStalenessCheck -vv --fork-url $MAINNET_RPC_URL
```
**Shows**: Oracle uses `latestAnswer()` without staleness validation

### Test 2: Calculate Financial Impact
```bash
forge test --match-test test_CalculateExploitImpact -vv --fork-url $MAINNET_RPC_URL
```
**Shows**: Impact calculations for various price drop scenarios

### Test 3: Demonstrate Attack Scenario
```bash
forge test --match-test test_AttackScenario -vv --fork-url $MAINNET_RPC_URL
```
**Shows**: Complete attack walkthrough
**Result**: $19,469 profit, $19,469 protocol bad debt

### Test 4: Show Recommended Fix
```bash
forge test --match-test test_RecommendedFix -vv --fork-url $MAINNET_RPC_URL
```
**Shows**: Proper validation implementation

---

## 📁 File Structure

```
Foundry Folder/
├── README_SETUP.md         # This file
└── poc-standalone/
    ├── foundry.toml        # Configuration
    ├── src/
    │   └── OracleTest.sol  # Interface definitions
    └── test/
        └── OracleStalenessPOC.t.sol  # Complete PoC (4 tests)
```

---

## 🔧 Troubleshooting

### Issue: "command not found: forge"
**Solution**: Install Foundry (see Step 1 above)

### Issue: "HTTP error 429" or rate limiting
**Solution**: Use your own RPC URL instead of public endpoints

### Issue: "failed to get storage"
**Solution**: Check your RPC URL is correct and has mainnet access

### Issue: Tests fail
**Solution**: Ensure you're using mainnet fork and RPC is working

---

## 📝 Test Output Summary

When tests pass, you'll see:

```
TEST 3: Attack Scenario Simulation
--------------------------------------------------
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

---

## ⚠️ Important Notes

- **Local Testing Only**: All tests run on mainnet fork (read-only)
- **No Mainnet Interaction**: No actual transactions sent to mainnet
- **Safe to Run**: Tests only query blockchain state
- **Reproducible**: Same results every time on same block

---

## 📞 Support

If you encounter issues running the PoC:
1. Check Foundry is installed: `forge --version`
2. Verify RPC URL is set: `echo $MAINNET_RPC_URL`
3. Test RPC connection: `cast block latest --rpc-url $MAINNET_RPC_URL`
4. Check you're in correct directory

---

**Status**: Verified and Working  
**Last Tested**: October 20, 2025  
**Foundry Version**: 1.4.2-stable

