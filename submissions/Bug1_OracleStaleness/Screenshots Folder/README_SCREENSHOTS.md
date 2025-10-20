# Screenshots Guide - Bug1 Oracle Staleness

## 📸 Required Screenshots (Minimum 15)

Place all screenshots in this folder with descriptive names.

---

## Screenshot Checklist

### Test Outputs (5 screenshots)

- [ ] `01_all_tests_passing.png` - All 4 tests passing with summary
- [ ] `02_test1_vulnerability_proof.png` - Test 1 output showing vulnerability
- [ ] `03_test2_impact_calculation.png` - Test 2 financial impact
- [ ] `04_test3_attack_scenario.png` - Test 3 complete attack with $19,469 profit
- [ ] `05_test4_recommended_fix.png` - Test 4 showing proper validation

### Code Screenshots (5 screenshots)

- [ ] `06_vulnerable_code_aaveoracle.png` - AaveOracle.sol lines 104-119 (vulnerable function)
- [ ] `07_chainlink_source.png` - Show Chainlink source address used
- [ ] `08_poc_test_code.png` - OracleStalenessPOC.t.sol test implementation
- [ ] `09_attack_simulation_code.png` - test_AttackScenario() function code
- [ ] `10_recommended_fix_code.png` - Fixed version with proper validation

### Evidence Screenshots (5+ screenshots)

- [ ] `11_forge_version.png` - `forge --version` output
- [ ] `12_foundry_config.png` - foundry.toml configuration
- [ ] `13_test_execution_start.png` - Beginning of test run
- [ ] `14_test_execution_logs.png` - Detailed test logs with price data
- [ ] `15_impact_summary.png` - Summary showing $19,469 profit

### Additional Recommended Screenshots

- [ ] `16_project_structure.png` - File tree showing project layout
- [ ] `17_chainlink_docs.png` - Chainlink documentation on staleness checks
- [ ] `18_historical_exploit.png` - Reference to Venus/Cream hacks
- [ ] `19_fix_comparison.png` - Before/after code comparison
- [ ] `20_gas_usage.png` - Gas usage from tests

---

## 📋 How to Take Screenshots

### From Terminal

1. **Run the complete test suite**:
   ```bash
   cd "Foundry Folder/poc-standalone"
   forge test --match-contract OracleStalenessPOC -vv --fork-url $MAINNET_RPC_URL
   ```

2. **Screenshot the output** showing:
   - All 4 tests passed
   - Gas usage
   - Runtime
   - Test logs

3. **Run individual tests** for detailed outputs:
   ```bash
   forge test --match-test test_OracleNoStalenessCheck -vvv --fork-url $MAINNET_RPC_URL
   forge test --match-test test_AttackScenario -vvv --fork-url $MAINNET_RPC_URL
   ```

### From Code Files

1. **Open** `src/AaveOracle_8105/lib/aave-v3-core/contracts/misc/AaveOracle.sol`
   - Navigate to lines 104-119
   - Screenshot the `getAssetPrice()` function
   - Highlight line 112: `int256 price = source.latestAnswer();`

2. **Open** `poc-standalone/test/OracleStalenessPOC.t.sol`
   - Screenshot the test functions
   - Show the attack simulation logic
   - Highlight key assertions

3. **Show the fix** in documentation
   - Screenshot the recommended fix code from bug report
   - Show before/after comparison

---

## 🖼️ Screenshot Requirements

### Quality Standards

- **Resolution**: High enough to read code clearly
- **Format**: PNG or JPG
- **Size**: Reasonable (< 5MB per image)
- **Legibility**: All text must be readable
- **Context**: Include enough context to understand what's shown

### What to Capture

✅ **Good Screenshots**:
- Full terminal output with test results
- Code with syntax highlighting
- Clear error messages or success indicators
- Relevant console logs
- Before/after comparisons

❌ **Avoid**:
- Blurry or low-resolution images
- Cropped text that cuts off important info
- Screenshots without context
- Duplicate screenshots

---

## 📝 Naming Convention

Use clear, descriptive names:

```
01_all_tests_passing.png
02_test1_vulnerability_proof.png
03_test2_impact_calculation.png
...
```

**Pattern**: `[number]_[brief_description].png`

---

## ✅ Verification Checklist

Before finalizing:

- [ ] At least 15 screenshots included
- [ ] All screenshots are clear and readable
- [ ] Test results showing "4 passed" visible
- [ ] Attack scenario with $19,469 profit shown
- [ ] Vulnerable code highlighted
- [ ] PoC test code visible
- [ ] Fix recommendations shown
- [ ] All files properly named
- [ ] No sensitive information (API keys) visible

---

## 🎯 Key Screenshots Priority

**Must Have** (Critical):
1. All 4 tests passing ⭐
2. Attack scenario showing $19,469 profit ⭐
3. Vulnerable code in AaveOracle.sol ⭐
4. PoC test code ⭐
5. Recommended fix ⭐

**Should Have** (Important):
6. Individual test outputs
7. Detailed logs with price data
8. Forge version and setup
9. Impact calculations
10. Code comparisons

**Nice to Have** (Supplementary):
11. Project structure
12. Historical context
13. Documentation references
14. Gas usage
15. Additional evidence

---

## 📞 Tips

- Take screenshots as you run tests
- Capture both overview and detail views
- Include timestamps if possible
- Show the complete command used
- Highlight important lines in code screenshots
- Use screen capture tools with annotation features

**Tools**:
- macOS: Cmd+Shift+4 (select area)
- Windows: Snipping Tool or Win+Shift+S
- Linux: gnome-screenshot or Spectacle

---

**Remember**: Screenshots are proof your PoC works!  
Make them clear, comprehensive, and professional.

