# Snyk Workflow Fixes - Maven Wrapper & SARIF Issues

## Issues Identified and Fixed

### 1. **Maven Wrapper Execution Error**

```
ERROR: Cannot run mvnw outside your current directory
```

**Root Cause**:

- Maven wrapper not executable
- Using `mvn` instead of `./mvnw`
- Missing proper working directory setup

**Solutions Applied**:

```yaml
# Added to ALL workflow jobs
- name: Make Maven wrapper executable
  run: chmod +x ./mvnw
# Changed all Maven commands
# Before: mvn clean compile
# After:  ./mvnw clean compile
```

### 2. **Missing SARIF Files Error**

```
ERROR: Path does not exist: snyk-enhanced.sarif
ERROR: Path does not exist: snyk-enhanced-code.sarif
```

**Root Cause**:

- Snyk scans failing due to Maven wrapper issues
- SARIF files not generated when scans fail
- Upload attempts without file existence checks

**Solutions Applied**:

```yaml
# Added file existence checks to ALL SARIF uploads
- name: Upload enhanced results
  uses: github/codeql-action/upload-sarif@v3
  if: always() && hashFiles('snyk-enhanced.sarif') != ''
  with:
    sarif_file: snyk-enhanced.sarif
```

### 3. **Missing JAVA_HOME Environment**

**Root Cause**: Snyk action couldn't find proper Java installation

**Solution Applied**:

```yaml
# Added to ALL Snyk actions
env:
  SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
  JAVA_HOME: ${{ env.JAVA_HOME }}
```

### 4. **Missing File Specifications**

**Root Cause**: Snyk scanning all files instead of just pom.xml

**Solution Applied**:

```yaml
# Added to ALL Snyk scans
with:
  args: >
    --file=pom.xml
    # ...other arguments
```

## Complete Workflow Fixes Applied

### **comprehensive-security Job**

✅ **Fixed**:

- Maven wrapper permissions: `chmod +x ./mvnw`
- Build command: `./mvnw clean compile -DskipTests`
- Container build: `./mvnw clean package -DskipTests`
- Added JAVA_HOME to all Snyk actions
- Added `--file=pom.xml` to dependency scans
- Enhanced SARIF file existence checks

### **conditional-security Job**

✅ **Fixed**:

- Maven wrapper permissions
- Build command: `./mvnw clean compile`
- Added JAVA_HOME environment
- Added `--file=pom.xml` specification

### **enhanced-snyk Job**

✅ **Fixed**:

- Maven wrapper permissions
- Build commands: `./mvnw clean compile` and `./mvnw dependency:tree`
- Added JAVA_HOME to all Snyk actions
- Added `--file=pom.xml` specification
- Enhanced SARIF upload with file existence checks:
  ```yaml
  if: always() && hashFiles('snyk-enhanced.sarif') != ''
  if: always() && hashFiles('snyk-enhanced-code.sarif') != ''
  ```

### **monitor-production Job**

✅ **Fixed**:

- Maven wrapper permissions
- Added JAVA_HOME environment
- Added `--file=pom.xml` specification

## Key Changes Summary

| Issue                  | Before              | After                                        |
| ---------------------- | ------------------- | -------------------------------------------- |
| **Maven Command**      | `mvn clean compile` | `./mvnw clean compile`                       |
| **Permissions**        | Not set             | `chmod +x ./mvnw`                            |
| **Java Environment**   | Missing             | `JAVA_HOME: ${{ env.JAVA_HOME }}`            |
| **File Specification** | Auto-detect         | `--file=pom.xml`                             |
| **SARIF Upload**       | `if: always()`      | `if: always() && hashFiles('*.sarif') != ''` |

## Expected Results After Fix

### **Successful Maven Operations**

- ✅ Maven wrapper will execute from correct directory
- ✅ Dependencies will be resolved properly
- ✅ Project will compile successfully
- ✅ Snyk will have access to dependency information

### **Successful Snyk Scans**

- ✅ Dependency vulnerability scanning will work
- ✅ Code analysis (SAST) will complete
- ✅ Container scanning will function
- ✅ SARIF files will be generated

### **Successful SARIF Uploads**

- ✅ Files will only upload if they exist
- ✅ GitHub Security tab will show results
- ✅ No more "Path does not exist" errors
- ✅ Security alerts will be properly created

## Verification Steps

1. **Push Changes**: Commit and push to trigger workflows
2. **Monitor Logs**: Check Actions tab for successful execution
3. **Verify SARIF**: Check Security tab for uploaded results
4. **Check Artifacts**: Verify scan results are archived

## Troubleshooting Commands

If issues persist, use these commands for debugging:

```bash
# Local verification
./mvnw clean compile
./mvnw dependency:tree
java -version

# Check file permissions
ls -la mvnw
# Should show: -rwxr-xr-x (executable)

# Manual SARIF generation test
./mvnw clean compile
# Then run Snyk locally if available
```

## Additional Improvements Made

### **Error Handling**

- All SARIF uploads now have proper conditionals
- Workflows continue even if individual scans fail
- Better separation of concerns between different scan types

### **Performance**

- Maven dependency caching enabled
- Proper use of Maven wrapper reduces dependency issues
- Explicit file specifications speed up Snyk scans

### **Security**

- All scans properly isolated with matrix strategy
- Consistent Java environment across all jobs
- Proper artifact naming and retention

The workflow should now execute successfully without the Maven wrapper or SARIF file errors!
