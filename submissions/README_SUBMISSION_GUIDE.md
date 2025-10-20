# 📦 ZSA Attackathon 2025 - Submission Guide

## 🎯 Overview

This folder contains a structured submission system for multiple bugs. Each bug has its own folder that can be zipped independently for submission.

---

## 📁 Folder Structure

```
submissions/
├── README_SUBMISSION_GUIDE.md    # This file
├── Bug1_OracleStaleness/         # First bug (Oracle Staleness)
│   ├── Foundry Folder/           # PoC tests and setup
│   ├── Screenshots Folder/       # Minimum 15 images
│   └── Report Folder/            # Bug report + PoC report
├── Bug2_[NextBug]/               # Template for second bug (when found)
│   ├── Foundry Folder/
│   ├── Screenshots Folder/
│   └── Report Folder/
└── Bug3_[NextBug]/               # Template for third bug (when found)
    ├── Foundry Folder/
    ├── Screenshots Folder/
    └── Report Folder/
```

---

## 🏗️ Creating a New Bug Submission

When you find a new bug, follow this process:

### Step 1: Create Bug Folder

```bash
cd /Users/arkaghosh/Documents/GitHub/zsa-attackathon-2025/submissions

# Create new bug folder (replace X and BugName)
mkdir -p BugX_[BugName]/{"Foundry Folder","Screenshots Folder","Report Folder"}

# Example:
mkdir -p Bug2_PoolReentrancy/{"Foundry Folder","Screenshots Folder","Report Folder"}
```

### Step 2: Add Your Content

**Foundry Folder**:
- Copy your PoC tests
- Include setup README
- Ensure it's runnable independently

**Screenshots Folder**:
- Add minimum 15 screenshots
- Include README_SCREENSHOTS.md guide
- Name files descriptively (01_, 02_, etc.)

**Report Folder**:
- `Formal_Bug_Report.md` - Main bug report
- `Proof_of_Concept_Report.md` - Detailed analysis

---

## 📦 How to Submit Each Bug

### For Bug1 (Oracle Staleness) - READY TO SUBMIT

#### Step 1: Finalize Content

1. **Add Screenshots** to `Bug1_OracleStaleness/Screenshots Folder/`
   - Minimum 15 images
   - Follow the guide in `README_SCREENSHOTS.md`
   - Name them: 01_..., 02_..., etc.

2. **Verify Reports** in `Bug1_OracleStaleness/Report Folder/`
   - ✅ `Formal_Bug_Report.md` (complete)
   - ✅ `Proof_of_Concept_Report.md` (complete)

3. **Verify PoC** in `Bug1_OracleStaleness/Foundry Folder/`
   - ✅ `poc-standalone/` (working)
   - ✅ `README_SETUP.md` (instructions)

#### Step 2: Create ZIP

```bash
cd /Users/arkaghosh/Documents/GitHub/zsa-attackathon-2025/submissions

# Navigate into the bug folder
cd Bug1_OracleStaleness

# Create ZIP with proper name
# Format: TeamName_Bug(Level)_ZSA
zip -r ../YourTeamName_Bug1_ZSA.zip .

# Verify contents
cd ..
unzip -l YourTeamName_Bug1_ZSA.zip
```

**Important**: 
- Zip from INSIDE the bug folder (using `.`)
- This ensures the ZIP contains the three subfolders directly
- Name format: `TeamName_Bug1_ZSA.zip`

#### Step 3: Submit

**Via Email**:
- **To**: `zsa.esports@gmail.com`
- **Subject**: `ZSA Attackathon 2025 — Critical Vulnerability — [YourHandle]`
- **Attach**: `YourTeamName_Bug1_ZSA.zip`
- **Body**: Brief description of the vulnerability

**Example Email**:
```
Dear ZSA Attackathon Organizers,

I am submitting Bug1: Oracle Staleness vulnerability in AaveOracle.

Severity: CRITICAL (CVSS 9.8)
Impact: $19,469 profit per attack
Status: Verified with working PoC

Attached: Complete submission with PoC, screenshots, and reports.

Best regards,
[Your Name]
```

---

## ✅ Submission Checklist (Per Bug)

Before creating ZIP, verify:

### Foundry Folder
- [ ] PoC code is complete and runnable
- [ ] README_SETUP.md with clear instructions
- [ ] All tests pass when run
- [ ] No hardcoded API keys or secrets

### Screenshots Folder
- [ ] Minimum 15 screenshots included
- [ ] All screenshots are clear and readable
- [ ] Files named descriptively (01_, 02_, etc.)
- [ ] Key findings are visible
- [ ] README_SCREENSHOTS.md guide included

### Report Folder
- [ ] Formal_Bug_Report.md is complete
- [ ] Proof_of_Concept_Report.md is detailed
- [ ] All sections filled in
- [ ] Impact calculations included
- [ ] Fix recommendations provided

### ZIP File
- [ ] Named correctly: `TeamName_BugX_ZSA.zip`
- [ ] Contains three subfolders directly
- [ ] ZIP can be extracted successfully
- [ ] Total size is reasonable (< 50MB)

---

## 🎯 Bug Numbering Convention

**Bug1**: First critical finding (Oracle Staleness) ✅  
**Bug2**: Second finding (if found)  
**Bug3**: Third finding (if found)  
...and so on

**Naming Examples**:
- `TeamName_Bug1_ZSA.zip` - Oracle Staleness
- `TeamName_Bug2_ZSA.zip` - Pool Reentrancy
- `TeamName_Bug3_ZSA.zip` - ACL Manager Bypass

---

## 📊 Current Status

### Bug1: Oracle Staleness ✅
- **Status**: Ready for submission (needs screenshots)
- **Severity**: CRITICAL
- **PoC**: Working (4/4 tests pass)
- **Reports**: Complete
- **Next**: Add screenshots and ZIP

### Bug2: [Future]
- **Status**: Not started
- **Target**: Pool reentrancy (promising)
- **Priority**: High

### Bug3: [Future]
- **Status**: Not started
- **Target**: TBD
- **Priority**: Medium

---

## 🔧 Troubleshooting

### Issue: ZIP structure is wrong
**Solution**: Make sure to `cd` INTO the bug folder before zipping
```bash
cd Bug1_OracleStaleness
zip -r ../YourTeamName_Bug1_ZSA.zip .
```

### Issue: ZIP is too large
**Solution**: Check screenshot sizes, compress if needed, remove unnecessary files

### Issue: Tests don't run from ZIP
**Solution**: Include complete `poc-standalone/` folder with all dependencies

---

## 💡 Best Practices

1. **One Bug Per ZIP**: Each vulnerability gets its own submission
2. **Independent**: Each ZIP should be self-contained
3. **Professional**: Use clear names and organization
4. **Verified**: Test that your PoC runs before submitting
5. **Complete**: Include all required materials

---

## 📞 Support Files

Each bug folder has its own README files:

- `Foundry Folder/README_SETUP.md` - How to run the PoC
- `Screenshots Folder/README_SCREENSHOTS.md` - Screenshot requirements
- `Report Folder/Formal_Bug_Report.md` - Main submission document
- `Report Folder/Proof_of_Concept_Report.md` - Technical details

---

## 🎓 Quick Reference

### To Submit Bug1:
```bash
cd submissions/Bug1_OracleStaleness
# Add your screenshots to Screenshots Folder/
cd ..
cd Bug1_OracleStaleness
zip -r ../YourTeamName_Bug1_ZSA.zip .
cd ..
# Email YourTeamName_Bug1_ZSA.zip to zsa.esports@gmail.com
```

### To Create Bug2:
```bash
cd submissions
mkdir -p Bug2_PoolReentrancy/{"Foundry Folder","Screenshots Folder","Report Folder"}
# Add your content
# Follow same process as Bug1
```

---

## 🏆 Success Metrics

**Bug1 (Oracle Staleness)**:
- ✅ Critical vulnerability found
- ✅ Working PoC (4/4 tests pass)
- ✅ Professional documentation
- ✅ Quantified impact ($19,469/attack)
- ⏳ Screenshots needed (15+)
- ⏳ Final ZIP creation
- ⏳ Email submission

**You're 90% done with Bug1!**

---

## 🚀 Next Steps

1. **Complete Bug1** (1 hour):
   - Take 15+ screenshots
   - Create ZIP file
   - Submit via email

2. **Find Bug2** (Optional, 3-5 days):
   - Analyze Pool reentrancy
   - Create similar submission structure
   - Submit separately

3. **Find Bug3** (Optional, 3-5 days):
   - Analyze other high-priority contracts
   - Create similar submission structure
   - Submit separately

---

**Remember**: Each bug is submitted independently!  
You can submit Bug1 now and Bug2/3 later if you find them.

**Good luck! 🎯🚀**

---

**Last Updated**: October 20, 2025  
**Status**: Bug1 ready for final screenshots and submission

