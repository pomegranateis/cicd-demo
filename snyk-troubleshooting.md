# 🔧 Snyk Authentication Troubleshooting Guide

## 🚨 Issue: Authentication Failed (Timeout)

You're seeing this error:
```
ERROR   Unspecified Error (SNYK-CLI-0000)
         authentication failed (timeout)
```

## 🔍 Root Cause Analysis

This error typically occurs due to one of these reasons:
1. **Missing SNYK_TOKEN** - Secret not configured in GitHub
2. **Invalid Token** - Token is expired, malformed, or incorrect
3. **Network Issues** - Temporary connectivity problems
4. **Token Format Issues** - Extra spaces or characters in the token

## 🛠️ Step-by-Step Resolution

### Step 1: Verify Snyk Account Setup ✅

1. **Create/Access Snyk Account:**
   ```bash
   # Visit: https://snyk.io
   # Sign up or login (preferably with GitHub account)
   ```

2. **Generate Fresh API Token:**
   ```bash
   # In Snyk dashboard:
   # 1. Click your profile (top right)
   # 2. Go to "Account Settings"
   # 3. Navigate to "Auth Token" section
   # 4. Click "Show" to reveal token
   # 5. Copy the token (should be UUID format)
   ```

3. **Verify Token Format:**
   ```
   ✅ Correct: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
   ❌ Incorrect: token with spaces, newlines, or extra characters
   ```

### Step 2: Configure GitHub Secret 🔐

1. **Navigate to Repository Settings:**
   ```bash
   # In your GitHub repository:
   # Settings → Secrets and variables → Actions
   ```

2. **Add/Update Secret:**
   ```bash
   # Click "New repository secret" or edit existing
   # Name: SNYK_TOKEN (exact case sensitive)
   # Value: [paste your token without any extra characters]
   # Click "Add secret"
   ```

3. **Verify Secret Exists:**
   - Should see `SNYK_TOKEN` in the list
   - Green checkmark indicates it's properly saved

### Step 3: Test the Configuration 🧪

1. **Option A: Manual Workflow Trigger**
   ```bash
   # Go to Actions tab in your repository
   # Select "Java CI with Maven" workflow
   # Click "Run workflow" button
   # Watch the "SA scan using snyk" job
   ```

2. **Option B: Push a Small Change**
   ```bash
   # Make any small change to trigger CI/CD
   git add .
   git commit -m "Test Snyk authentication"
   git push origin main
   ```

3. **Option C: Use Test Workflow**
   Create `.github/workflows/snyk-test.yml`:
   ```yaml
   name: Snyk Test
   on: 
     workflow_dispatch:
   jobs:
     test-snyk:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v4
         - name: Set up JDK 17
           uses: actions/setup-java@v4
           with:
             java-version: "17"
             distribution: "temurin"
         - name: Test Snyk Authentication
           uses: snyk/actions/maven@master
           env:
             SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
           with:
             args: --version
   ```

### Step 4: Alternative Solutions 🔄

If Snyk continues to fail, consider these alternatives:

1. **Use Different Snyk Action Version:**
   ```yaml
   - name: Run Snyk Scan
     uses: snyk/actions/maven@v1  # Try v1 instead of master
     env:
       SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
   ```

2. **Install Snyk CLI Manually:**
   ```yaml
   - name: Install and Test Snyk
     run: |
       npm install -g snyk
       snyk auth ${{ secrets.SNYK_TOKEN }}
       snyk test --maven
   ```

3. **Enable GitHub Dependabot** (GitHub's built-in security scanning):
   Create `.github/dependabot.yml`:
   ```yaml
   version: 2
   updates:
     - package-ecosystem: "maven"
       directory: "/"
       schedule:
         interval: "weekly"
       open-pull-requests-limit: 10
   ```

4. **Use GitHub's CodeQL** (for code analysis):
   Create `.github/workflows/codeql.yml`:
   ```yaml
   name: "CodeQL"
   on:
     push:
       branches: [ "main", "master" ]
     pull_request:
       branches: [ "main", "master" ]
   jobs:
     analyze:
       name: Analyze
       runs-on: ubuntu-latest
       strategy:
         matrix:
           language: [ 'java' ]
       steps:
         - name: Checkout repository
           uses: actions/checkout@v4
         - name: Initialize CodeQL
           uses: github/codeql-action/init@v2
           with:
             languages: ${{ matrix.language }}
         - name: Autobuild
           uses: github/codeql-action/autobuild@v2
         - name: Perform CodeQL Analysis
           uses: github/codeql-action/analyze@v2
   ```

## ✅ Expected Success Indicators

When authentication works correctly, you should see:

1. **In Workflow Logs:**
   ```
   ✅ Snyk CLI version: x.x.x
   ✅ Testing for known issues...
   ✅ Organization: your-org-name
   ```

2. **Vulnerability Findings:**
   ```
   ✓ Vulnerabilities found:
   - commons-collections@3.2.1 (High severity)
   - commons-compress@1.18 (Medium severity)
   ```

3. **In GitHub Security Tab:**
   - SARIF reports uploaded
   - Security alerts visible
   - Vulnerability details with remediation advice

## 🔍 Debug Commands

If you have local access, test these commands:

```bash
# Verify project builds
mvn clean compile test

# Check vulnerable dependencies
mvn dependency:tree | grep -E "(commons-collections|commons-compress)"

# Manual Snyk test (if you have CLI)
npm install -g snyk
snyk auth [YOUR_TOKEN]
snyk test --maven

# Test with specific severity
snyk test --maven --severity-threshold=medium
```

## 📚 Additional Resources

- [Snyk Documentation](https://docs.snyk.io/)
- [GitHub Actions with Snyk](https://github.com/snyk/actions)
- [Snyk Error Catalog](https://docs.snyk.io/scan-with-snyk/error-catalog#snyk-cli-0000)
- [GitHub Secrets Documentation](https://docs.github.com/en/actions/security-guides/encrypted-secrets)

## 🎯 Next Steps

1. **If authentication succeeds:** Proceed to review vulnerability findings
2. **If still failing:** Try the alternative solutions above
3. **For production use:** Consider multiple security tools for comprehensive coverage

---

**Remember:** The goal is to demonstrate SAST integration. If Snyk doesn't work, the alternative tools (Dependabot, CodeQL) achieve similar educational objectives!
