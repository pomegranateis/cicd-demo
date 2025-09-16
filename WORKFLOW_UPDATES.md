# Snyk GitHub Actions - Updated Configuration

## Fixed Issues

### 1. Deprecated Artifact Actions

**Problem**: Using deprecated `actions/upload-artifact@v3` and `actions/download-artifact@v3`

**Solution**: Updated to v4 with new syntax:

```yaml
# OLD (deprecated)
- uses: actions/upload-artifact@v3
  with:
    name: results
    path: file.json

# NEW (current)
- uses: actions/upload-artifact@v4
  with:
    name: results
    path: file.json

# For download-artifact@v4
- uses: actions/download-artifact@v4
  with:
    merge-multiple: true # New option to merge all artifacts
```

### 2. Deprecated CodeQL Action

**Problem**: Using deprecated `github/codeql-action/upload-sarif@v2`

**Solution**: Updated to v3:

```yaml
# OLD (deprecated)
- uses: github/codeql-action/upload-sarif@v2
  with:
    sarif_file: snyk.sarif

# NEW (current)
- uses: github/codeql-action/upload-sarif@v3
  with:
    sarif_file: snyk.sarif
```

### 3. Missing SARIF Files

**Problem**: `Path does not exist: snyk-container.sarif`

**Solution**: Added file existence checks:

```yaml
# Check if SARIF file exists before upload
- name: Upload SARIF to GitHub Security
  uses: github/codeql-action/upload-sarif@v3
  if: always() && hashFiles('snyk-*.sarif') != ''
  with:
    sarif_file: snyk-results.sarif
```

### 4. GitHub API Permissions

**Problem**: `HttpError: Resource not accessible by integration`

**Solution**: Added proper permissions to all workflows:

```yaml
permissions:
  contents: read # Read repository contents
  security-events: write # Upload SARIF to Security tab
  issues: write # Create security issues (optional)
  actions: read # Read workflow artifacts
```

### 5. GitHub Script Action

**Problem**: Using outdated `actions/github-script@v6`

**Solution**: Updated to v7 with explicit token:

```yaml
# OLD
- uses: actions/github-script@v6
  with:
    script: |
      // script here

# NEW
- uses: actions/github-script@v7
  with:
    github-token: ${{ secrets.GITHUB_TOKEN }}
    script: |
      // script here
```

## Updated Workflow Files

All workflow files have been updated with:

1. **Permissions block** at the top level
2. **Artifact actions v4** with new syntax
3. **CodeQL action v3** for SARIF uploads
4. **GitHub Script v7** with explicit token
5. **File existence checks** for SARIF uploads
6. **Proper error handling** for missing files

## Key Changes Summary

| Component         | Old Version   | New Version    | Key Changes                           |
| ----------------- | ------------- | -------------- | ------------------------------------- |
| upload-artifact   | v3            | v4             | Same syntax, better performance       |
| download-artifact | v3            | v4             | Added `merge-multiple: true` option   |
| codeql-action     | v2            | v3             | SARIF upload compatibility            |
| github-script     | v6            | v7             | Requires explicit `github-token`      |
| Permissions       | Not specified | Added block    | Required for Security tab integration |
| SARIF checks      | None          | File existence | Prevents missing file errors          |

## Workflow Status

✅ **maven.yml** - Basic enhanced Snyk integration
✅ **enhanced-snyk-basic.yml** - Step 6.2 implementation  
✅ **advanced-snyk.yml** - Comprehensive security scanning
✅ **enhanced-security.yml** - Production-ready workflow

All workflows now comply with GitHub Actions best practices and current API requirements.

## Testing the Workflows

To test the updated workflows:

1. Ensure `SNYK_TOKEN` is set in repository secrets
2. Push changes to master branch or create a pull request
3. Check Actions tab for workflow execution
4. Verify SARIF upload in Security tab
5. Review any created artifacts

## Troubleshooting

If you still encounter issues:

1. **Permissions**: Ensure repository has proper GitHub Actions permissions
2. **Token**: Verify SNYK_TOKEN is valid and has appropriate scope
3. **SARIF**: Check that Snyk generates valid SARIF output
4. **Artifacts**: Confirm artifact naming doesn't conflict with existing ones
