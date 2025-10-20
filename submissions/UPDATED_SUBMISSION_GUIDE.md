# 📦 UPDATED Submission Guide - Official Requirements

## ⚠️ READ THIS - Requirements Changed!

The competition organizers provided updated submission requirements. Follow this guide exactly.

---

## 📋 Official Requirements

### 1. Each Bug = Separate Submission

- One ZIP file per bug
- One Devpost upload per bug
- One email per bug

### 2. File Naming Convention

Format: `<TeamOrSoloName>_Bug<Number>_ZSA.zip`

Examples:
- `Whitehat_Bug1_ZSA.zip`
- `YourName_Bug1_ZSA.zip`
- `CryptoHunter_Bug1_ZSA.zip`

### 3. ZIP Structure (EXACT FORMAT)

```
YourName_Bug1_ZSA.zip
├── BugReport.pdf              ⭐ Must be PDF (not .md)
├── PoC/                       ⭐ Proof of concept folder
│   ├── README.md
│   ├── foundry.toml
│   ├── src/
│   └── test/
├── metadata.json              ⭐ Bug metadata
├── screenshots/               ⭐ All visual evidence
├── logs/                      ⭐ Test execution logs
└── [any other supporting files]
```

### 4. Submission Process

**For Each Bug**:

1. **Create ZIP** with exact structure
2. **Upload to Devpost** (separate entry per bug)
3. **Email to**: `zsa.esports@gmail.com`
4. **Email Subject**: `Submission: YourName_Bug1_ZSA`
5. **Attach**: The ZIP file

---

## ✅ Bug1 Folder Ready: `Bug1_Updated/`

I've created the correct structure for you at:
```
submissions/Bug1_Updated/
```

---

## 🎯 Steps to Complete Bug1 Submission

### Step 1: Convert Report to PDF (Required)

Your markdown report needs to be PDF:

```bash
# Source file:
submissions/Bug1_OracleStaleness/Report Folder/Formal_Bug_Report.md

# Target location:
submissions/Bug1_Updated/BugReport.pdf
```

**How to Convert**:
- See `Bug1_Updated/CONVERT_TO_PDF.md` for options
- Recommended: Use VSCode with "Markdown PDF" extension
- Or use Pandoc: `pandoc Formal_Bug_Report.md -o BugReport.pdf`

### Step 2: Add Screenshots (15+)

```bash
# Add to:
cd submissions/Bug1_Updated/screenshots/

# Add files like:
01_all_tests_passing.png
02_test1_output.png
03_test3_attack_with_profit.png
... (15+ total)
```

### Step 3: Generate Test Logs

```bash
cd submissions/Bug1_Updated/PoC

# Full test log
forge test --match-contract OracleStalenessPOC -vv --fork-url $MAINNET_RPC_URL > ../logs/complete_test_output.log 2>&1

# Individual test logs (optional but recommended)
forge test --match-test test_AttackScenario -vvv --fork-url $MAINNET_RPC_URL > ../logs/test3_attack_scenario.log 2>&1
```

### Step 4: Update metadata.json

Edit `submissions/Bug1_Updated/metadata.json`:

```json
{
  "submission_info": {
    "team_name": "YourActualName",     // ← Update this
    "researcher": "Your Full Name",    // ← Update this
    "contact_email": "your@email.com", // ← Update this
    ...
  }
}
```

### Step 5: Create ZIP

```bash
cd /Users/arkaghosh/Documents/GitHub/zsa-attackathon-2025/submissions

# Create ZIP (replace YourName with your actual name/team)
cd Bug1_Updated
zip -r ../YourName_Bug1_ZSA.zip .

# Go back and verify
cd ..
ls -lh YourName_Bug1_ZSA.zip

# Check contents
unzip -l YourName_Bug1_ZSA.zip | head -30
```

### Step 6: Verify ZIP Structure

The ZIP should contain (when unzipped):
```
.
├── BugReport.pdf
├── PoC/
│   ├── README.md
│   ├── foundry.toml
│   ├── src/
│   └── test/
├── metadata.json
├── screenshots/
│   ├── 01_...png
│   ├── 02_...png
│   └── ... (15+ files)
└── logs/
    └── complete_test_output.log
```

### Step 7: Submit to Devpost

1. Go to competition Devpost page
2. Create new submission
3. Title: "Bug1: Oracle Staleness Vulnerability"
4. Upload: `YourName_Bug1_ZSA.zip`
5. Fill in details
6. Submit

### Step 8: Email Submission

**To**: `zsa.esports@gmail.com`

**Subject**: `Submission: YourName_Bug1_ZSA`

**Body**:
```
Dear ZSA Attackathon Organizers,

I am submitting Bug1: Oracle Staleness vulnerability in Spark Protocol's AaveOracle contract.

Submission Details:
- Bug ID: Bug1
- Severity: CRITICAL (CVSS 9.8)
- Contract: AaveOracle (0x8105f69D9C41644c6A0803fDA7D03Aa70996cFD9)
- Impact: $19,469 profit per 100 ETH attack
- Status: Verified with working PoC (4/4 tests passed)

Attached: YourName_Bug1_ZSA.zip

Contents:
- BugReport.pdf: Complete formal bug report
- PoC/: Working proof of concept with all tests
- metadata.json: Structured vulnerability information
- screenshots/: 15+ images of test results and code
- logs/: Complete test execution logs

The vulnerability allows attackers to exploit stale Chainlink prices during market volatility to borrow more than their collateral is worth, creating protocol bad debt.

All testing performed on local forks only. No mainnet exploitation occurred.

Also submitted via Devpost.

Best regards,
[Your Name]
[Date]
```

**Attachment**: `YourName_Bug1_ZSA.zip`

---

## ✅ Submission Checklist

Before submitting:

### Files
- [ ] `BugReport.pdf` created (not .md)
- [ ] `PoC/` folder complete with tests
- [ ] `metadata.json` updated with your info
- [ ] `screenshots/` has 15+ images
- [ ] `logs/` has test output files

### ZIP
- [ ] Named correctly: `YourName_Bug1_ZSA.zip`
- [ ] Contains all required files
- [ ] Extracts correctly
- [ ] Size is reasonable (< 50MB)

### Submission
- [ ] Uploaded to Devpost
- [ ] Email sent to zsa.esports@gmail.com
- [ ] Email subject correct: `Submission: YourName_Bug1_ZSA`
- [ ] ZIP attached to email
- [ ] Kept backup copy

---

## 🔧 Quick Commands Summary

```bash
# 1. Go to working directory
cd /Users/arkaghosh/Documents/GitHub/zsa-attackathon-2025/submissions/Bug1_Updated

# 2. Convert report to PDF (use one of the methods in CONVERT_TO_PDF.md)
# ... create BugReport.pdf ...

# 3. Add screenshots
# ... add 15+ images to screenshots/ ...

# 4. Generate logs
cd PoC
forge test --match-contract OracleStalenessPOC -vv --fork-url $MAINNET_RPC_URL > ../logs/complete_test_output.log 2>&1
cd ..

# 5. Update metadata.json
# ... edit file with your info ...

# 6. Create ZIP
cd ..
cd Bug1_Updated
zip -r ../YourName_Bug1_ZSA.zip .
cd ..

# 7. Verify
unzip -l YourName_Bug1_ZSA.zip

# 8. Submit via Devpost + Email
```

---

## 📊 What's Different from Before

### Old vs New Structure

❌ **OLD** (what I created initially):
```
Bug1_OracleStaleness/
├── Foundry Folder/
├── Screenshots Folder/
└── Report Folder/
```

✅ **NEW** (what they want):
```
YourName_Bug1_ZSA/
├── BugReport.pdf
├── PoC/
├── metadata.json
├── screenshots/
└── logs/
```

### Key Changes
1. Report must be **PDF** (not Markdown)
2. Need **metadata.json** file
3. Need **logs/** folder with test outputs
4. Simpler folder structure (no "Folder" suffix)
5. Submit to **Devpost** + email (not just email)

---

## 🎯 Estimated Time

- Convert to PDF: 5-10 minutes
- Add screenshots: 30-60 minutes (if not done)
- Generate logs: 5 minutes
- Update metadata: 2 minutes
- Create ZIP: 2 minutes
- Submit: 10 minutes

**Total**: ~1-2 hours

---

## 📞 Need Help?

Check these files:
- `Bug1_Updated/CONVERT_TO_PDF.md` - How to create PDF
- `Bug1_Updated/PoC/README.md` - PoC documentation
- `Bug1_Updated/screenshots/README.md` - Screenshot guide
- `Bug1_Updated/logs/README.md` - Log generation

---

## 🚀 For Future Bugs (Bug2, Bug3)

When you find another bug:

```bash
cd /Users/arkaghosh/Documents/GitHub/zsa-attackathon-2025/submissions

# Copy the template structure
cp -r Bug1_Updated Bug2_[BugName]

# Replace content with new bug
# Follow same process
# Submit separately
```

---

**Remember**: Each bug is submitted independently to both Devpost and email!

**Good luck! 🎯🏆**

---

**Updated**: October 20, 2025  
**Status**: Structure ready for Bug1  
**Next**: Convert to PDF, add screenshots, create ZIP, submit

