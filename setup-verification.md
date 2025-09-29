# SAST Setup Verification Checklist

## Exercise 1: Basic Setup

### ✅ Steps Completed
1. **Project builds successfully** - ✅ Verified
2. **Tests pass** - ✅ Verified  
3. **GitHub Actions workflow exists** - ✅ Found in `.github/workflows/maven.yml`
4. **Basic Snyk integration configured** - ✅ Present in workflow

### 🔧 Manual Steps Required (You need to do these in GitHub)

1. **Create Snyk Account**:
   - Go to https://snyk.io
   - Sign up with your GitHub account
   - Navigate to Account Settings → Auth Token
   - Copy your API token

2. **Add GitHub Secret**:
   - Go to your GitHub repository
   - Settings → Secrets and variables → Actions
   - New repository secret:
     - Name: `SNYK_TOKEN`
     - Value: [Your Snyk API token]

3. **Test the workflow**:
   - Push a commit or trigger the workflow manually
   - Verify the "SA scan using snyk" job passes

### 📋 Current Workflow Analysis
```yaml
# Current security job in maven.yml:
security:
  needs: test
  name: SA scan using snyk
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@master
    - name: Run Snyk to check for vulnerabilities
      uses: snyk/actions/maven@master
      env:
        SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
```

**Status**: Basic setup is configured and ready for token configuration
