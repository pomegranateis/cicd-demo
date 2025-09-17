# Quick Start Guide: Snyk Container Scanning

## 🚀 Getting Started

### Prerequisites
1. **Snyk Account**: Sign up at https://snyk.io (free tier available)
2. **API Token**: Generate from Snyk dashboard → Settings → API Token
3. **GitHub Secret**: Add `SNYK_TOKEN` to repository secrets

### Setup Steps

#### 1. Add Snyk Token to GitHub
1. Go to your repository → Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Name: `SNYK_TOKEN`
4. Value: Your Snyk API token
5. Click "Add secret"

#### 2. Test the Pipeline
1. Make any code change
2. Commit and push to trigger the workflow
3. Check Actions tab for workflow execution
4. Review results in Security tab

## 🔍 What Gets Scanned

### Container Components
- ✅ Base image vulnerabilities (Alpine Linux)
- ✅ Java runtime vulnerabilities (OpenJDK 17)
- ✅ Application dependencies (Maven dependencies)
- ✅ Container configuration issues

### Scan Triggers
- 🔄 Every push to `master` branch
- 🔄 Every pull request to `master` branch
- 📅 Can be configured for scheduled scans

## 📊 Understanding Results

### Severity Levels
- 🔴 **Critical**: Immediate action required
- 🟠 **High**: Action required (fails build)
- 🟡 **Medium**: Monitor and plan fixes
- 🟢 **Low**: Nice to fix when convenient

### Where to Find Results
1. **GitHub Security Tab**: Detailed vulnerability reports
2. **Actions Log**: Build-time scan results
3. **Snyk Dashboard**: Comprehensive project monitoring

## 🛠️ Common Commands

### Local Docker Testing
```bash
# Build the container
docker build -t cicd-demo:latest .

# Run the container
docker run -d -p 8085:5000 cicd-demo:latest

# Test the application
curl http://localhost:8085/

# Stop and clean up
docker stop $(docker ps -q --filter ancestor=cicd-demo:latest)
docker rmi cicd-demo:latest
```

### Manual Snyk Scanning (if you have Snyk CLI)
```bash
# Scan container image
snyk container test cicd-demo:latest

# Scan for high severity only
snyk container test cicd-demo:latest --severity-threshold=high

# Generate SARIF report
snyk container test cicd-demo:latest --sarif-file-output=report.sarif
```

## 🔧 Troubleshooting

### Common Issues

#### 1. Missing SNYK_TOKEN
**Error**: `Missing Snyk API token`
**Solution**: Add `SNYK_TOKEN` to GitHub repository secrets

#### 2. Docker Build Failures
**Error**: `Docker build failed`
**Solution**: 
- Ensure `mvnw` has execute permissions
- Check if JAR file exists in `target/` directory
- Verify Dockerfile syntax

#### 3. High Severity Vulnerabilities
**Error**: `Build failed due to vulnerabilities`
**Solution**:
- Review vulnerability details in Security tab
- Update base image or dependencies
- Consider adjusting severity threshold temporarily

### Getting Help
1. 📖 Check the full implementation guide: `SNYK_CONTAINER_SCAN_IMPLEMENTATION.md`
2. 🔍 Review workflow logs in Actions tab
3. 🌐 Snyk documentation: https://docs.snyk.io/
4. 💬 GitHub Security tab for detailed findings

## 🎯 Best Practices

### Development Workflow
1. **Regular Updates**: Keep base images and dependencies updated
2. **Review Findings**: Check Security tab after each scan
3. **Prioritize Fixes**: Address critical and high severity issues first
4. **Monitor Trends**: Use Snyk dashboard to track security improvements

### Container Security
1. **Non-root User**: Already implemented in our Dockerfile
2. **Minimal Base Image**: Using Alpine Linux for smaller attack surface
3. **Regular Scans**: Automated scanning on every code change
4. **Health Checks**: Built-in health monitoring for containers

## 📈 Next Steps

### Immediate Actions
- [ ] Add `SNYK_TOKEN` to repository secrets
- [ ] Run first scan by pushing code changes
- [ ] Review any identified vulnerabilities
- [ ] Set up Snyk dashboard monitoring

### Future Enhancements
- [ ] Configure custom security policies
- [ ] Set up vulnerability alerting
- [ ] Integrate with deployment pipeline
- [ ] Add security testing to local development

---

**Need Help?** Check the detailed implementation guide or review the GitHub Actions workflow logs for more information.
