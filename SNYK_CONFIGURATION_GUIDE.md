# Snyk Configuration Reference Guide

This document provides a comprehensive reference for all Snyk configurations used in this project.

## Table of Contents
1. [Snyk Action Parameters](#snyk-action-parameters)
2. [Severity Thresholds](#severity-thresholds)
3. [Fail Conditions](#fail-conditions)
4. [Output Formats](#output-formats)
5. [Project Configuration](#project-configuration)
6. [Conditional Scanning](#conditional-scanning)

## Snyk Action Parameters

### Common Parameters

| Parameter | Description | Example Values | Default |
|-----------|-------------|----------------|---------|
| `--severity-threshold` | Minimum severity to report | `low`, `medium`, `high`, `critical` | `low` |
| `--fail-on` | Conditions to fail the build | `all`, `upgradable`, `patchable` | `all` |
| `--file` | Specific file to scan | `pom.xml`, `package.json` | Auto-detected |
| `--project-name` | Custom project name | `my-app-production` | Repository name |
| `--target-reference` | Git reference | `refs/heads/master` | Current ref |
| `--remote-repo-url` | Repository URL | `https://github.com/user/repo.git` | Current repo |

### Output Parameters

| Parameter | Description | Example |
|-----------|-------------|---------|
| `--json-file-output` | Output JSON results to file | `snyk-results.json` |
| `--sarif-file-output` | Output SARIF results to file | `snyk-results.sarif` |
| `--print-deps` | Print dependency tree | N/A |

### Container-Specific Parameters

| Parameter | Description | Example |
|-----------|-------------|---------|
| `--exclude-base-image-vulns` | Exclude base image vulnerabilities | N/A |
| `--platform` | Target platform | `linux/amd64` |
| `--username` | Registry username | `myuser` |
| `--password` | Registry password | `${{ secrets.REGISTRY_PASSWORD }}` |

## Severity Thresholds

### Available Levels
- **low**: All vulnerabilities (most verbose)
- **medium**: Medium, high, and critical vulnerabilities
- **high**: High and critical vulnerabilities only
- **critical**: Only critical vulnerabilities

### Usage Examples
```yaml
# Report only critical vulnerabilities
args: --severity-threshold=critical

# Report medium and above
args: --severity-threshold=medium
```

## Fail Conditions

### Available Options
- **all**: Fail on any vulnerability found
- **upgradable**: Fail only on vulnerabilities with available upgrades
- **patchable**: Fail only on vulnerabilities with available patches

### Usage Examples
```yaml
# Fail on any vulnerability
args: --fail-on=all

# Fail only if upgrades are available
args: --fail-on=upgradable
```

## Output Formats

### SARIF (Static Analysis Results Interchange Format)
- Integrates with GitHub Security tab
- Provides detailed vulnerability information
- Enables code scanning alerts

```yaml
with:
  args: --sarif-file-output=snyk.sarif
```

### JSON Format
- Machine-readable results
- Useful for custom processing
- Contains detailed vulnerability data

```yaml
with:
  args: --json-file-output=snyk.json
```

## Project Configuration

### .snyk File Structure
```yaml
version: v1.0.0

# Ignore specific vulnerabilities
ignore:
  "SNYK-JAVA-VULNERABILITY-ID":
    - "*":
        reason: "Explanation for ignoring"
        expires: "2024-12-31T23:59:59.999Z"

# Language-specific settings
language-settings:
  java:
    include-dev-deps: false
    maven-aggregate-project: true

# Exclude paths from scanning
exclude:
  - "target/**"
  - "**/*.class"
```

### Ignore Patterns
```yaml
# Ignore in all paths
"VULNERABILITY-ID":
  - "*":
      reason: "Global ignore reason"

# Ignore in specific paths only
"VULNERABILITY-ID":
  - "src/test/**":
      reason: "Test-only dependency"
```

## Conditional Scanning

### Event-Based Conditions
```yaml
# Only on pull requests or master branch
if: github.event_name == 'pull_request' || github.ref == 'refs/heads/master'

# Only on scheduled runs
if: github.event_name == 'schedule'

# Only on push to master
if: github.ref == 'refs/heads/master' && github.event_name == 'push'
```

### File Change Conditions
```yaml
# Use paths-filter action to detect changes
- uses: dorny/paths-filter@v2
  id: changes
  with:
    filters: |
      dependencies:
        - 'pom.xml'
        - '.snyk'
      code:
        - 'src/**'
```

## Command Types

### Dependency Scanning (Default)
```yaml
uses: snyk/actions/maven@master
# Scans for known vulnerabilities in dependencies
```

### Code Analysis (SAST)
```yaml
uses: snyk/actions/maven@master
with:
  command: code test
# Static analysis of source code
```

### Container Scanning
```yaml
uses: snyk/actions/docker@master
with:
  image: "my-app:latest"
# Scans Docker images for vulnerabilities
```

### Monitoring
```yaml
uses: snyk/actions/maven@master
with:
  command: monitor
# Continuous monitoring of project dependencies
```

## Environment Variables

### Required
- `SNYK_TOKEN`: Authentication token for Snyk API

### Optional
- `SNYK_CFG_ORG`: Snyk organization ID
- `SNYK_CFG_SEVERITY_THRESHOLD`: Default severity threshold
- `SNYK_INTEGRATION_NAME`: Integration name for reporting

## Best Practices

### 1. Use Matrix Strategy for Multiple Scans
```yaml
strategy:
  matrix:
    scan-type: [dependencies, code, container]
```

### 2. Upload Results to GitHub Security
```yaml
- name: Upload results
  uses: github/codeql-action/upload-sarif@v3
  with:
    sarif_file: snyk.sarif
```

### 3. Archive Results for Review
```yaml
- name: Archive results
  uses: actions/upload-artifact@v4
  with:
    name: snyk-results
    path: snyk.sarif
```

### 4. Use Appropriate Thresholds by Environment
- **Development**: `--severity-threshold=low`
- **Staging**: `--severity-threshold=medium`
- **Production**: `--severity-threshold=high`

### 5. Configure Proper Failure Conditions
- **CI/CD**: `--fail-on=upgradable`
- **Security Audit**: `--fail-on=all`
- **Monitoring**: Don't fail, just report

## Troubleshooting

### Common Issues

#### Authentication Errors
- Ensure `SNYK_TOKEN` is set in repository secrets
- Verify token has appropriate permissions

#### Build Failures
- Ensure project is compiled before scanning
- Check dependency resolution issues

#### SARIF Upload Failures
- Verify SARIF file is generated
- Check file path and permissions

### Debug Options
```yaml
# Enable debug logging
env:
  SNYK_DEBUG: true

# Increase verbosity
with:
  args: --debug
```

## Integration Examples

### Basic Integration
```yaml
- name: Run Snyk
  uses: snyk/actions/maven@master
  env:
    SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
```

### Advanced Integration
```yaml
- name: Run Snyk with full configuration
  uses: snyk/actions/maven@master
  env:
    SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
  with:
    args: >
      --severity-threshold=medium
      --fail-on=upgradable
      --project-name=${{ github.repository }}-${{ github.ref }}
      --sarif-file-output=snyk.sarif
      --json-file-output=snyk.json
```

This reference guide should help you understand and configure Snyk for your specific security requirements.
