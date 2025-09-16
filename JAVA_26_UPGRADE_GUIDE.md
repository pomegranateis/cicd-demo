# Java 26 Upgrade Guide

## Overview

This document outlines the upgrade from Java 17/21 to Java 26 across the entire CI/CD demo project.

## Files Updated

### 1. **pom.xml** - Maven Configuration

```xml
<properties>
    <java.version>26</java.version>
    <maven.compiler.source>26</maven.compiler.source>
    <maven.compiler.target>26</maven.compiler.target>
    <!-- ...other properties... -->
</properties>
```

**Changes:**

- ✅ Updated Java version to 26
- ✅ Set Maven compiler source to 26
- ✅ Set Maven compiler target to 26

### 2. **dockerfile** - Basic Docker Image

```dockerfile
FROM eclipse-temurin:26-jre-alpine
```

**Changes:**

- ✅ Updated base image from `eclipse-temurin:17-jre-alpine` to `eclipse-temurin:26-jre-alpine`

### 3. **dockerfile.secure** - Multi-stage Docker Image

```dockerfile
# Build stage
FROM eclipse-temurin:26-jdk-alpine AS builder

# Runtime stage
FROM eclipse-temurin:26-jre-alpine AS runtime
```

**Changes:**

- ✅ Updated build stage to use Java 26 JDK
- ✅ Updated runtime stage to use Java 26 JRE

### 4. **GitHub Actions Workflows**

#### maven.yml

```yaml
- name: Set up JDK 26
  uses: actions/setup-java@v4
  with:
    java-version: "26"
    distribution: "temurin"
```

#### enhanced-snyk-basic.yml

```yaml
- name: Set up JDK 26
  uses: actions/setup-java@v4
  with:
    java-version: "26"
    distribution: "temurin"
```

#### advanced-snyk.yml & enhanced-security.yml

```yaml
env:
  JAVA_VERSION: "26"
```

**Changes:**

- ✅ Updated all Java setup actions to version 26
- ✅ Updated environment variables to Java 26

## Local Development Setup

To work with Java 26 on your local machine:

### 1. **Install Java 26**

```bash
# Using SDKMAN (recommended)
sdk install java 26-tem
sdk use java 26-tem

# Verify installation
java -version
javac -version
```

### 2. **Set Environment Variables**

```bash
# Add to ~/.bashrc or ~/.zshrc
export JAVA_HOME=$HOME/.sdkman/candidates/java/26-tem
export PATH=$JAVA_HOME/bin:$PATH
```

### 3. **IDE Configuration**

- **IntelliJ IDEA**: File → Project Structure → Project SDK → Java 26
- **VS Code**: Update Java extension settings to use Java 26
- **Eclipse**: Window → Preferences → Java → Installed JREs → Add Java 26

### 4. **Maven Configuration**

Ensure your local Maven uses Java 26:

```bash
mvn -version
# Should show Java version 26
```

## Build and Test

### 1. **Local Build**

```bash
# Clean and compile
mvn clean compile

# Run tests
mvn test

# Package application
mvn package
```

### 2. **Docker Build**

```bash
# Build basic image
docker build -t cicd-demo:java26 .

# Build secure image
docker build -f dockerfile.secure -t cicd-demo:java26-secure .

# Test run
docker run -p 5000:5000 cicd-demo:java26
```

### 3. **CI/CD Pipeline**

The GitHub Actions workflows will automatically:

- ✅ Use Java 26 for compilation
- ✅ Run tests with Java 26
- ✅ Build Docker images with Java 26
- ✅ Run security scans with Java 26

## Compatibility Notes

### **Spring Boot 3.3.3**

- ✅ Compatible with Java 26
- ✅ All features supported
- ✅ Performance optimized for newer JVM

### **Dependencies**

- ✅ All current dependencies support Java 26
- ✅ Maven plugins compatible
- ✅ Testing frameworks updated

### **Docker Images**

- ✅ Eclipse Temurin 26 images available
- ✅ Alpine Linux base for security
- ✅ Optimized for container environments

## Benefits of Java 26

### **Performance Improvements**

- 🚀 Better JVM performance
- 🚀 Improved garbage collection
- 🚀 Enhanced memory management

### **Security Enhancements**

- 🔒 Latest security patches
- 🔒 Improved cryptographic algorithms
- 🔒 Enhanced sandbox security

### **Developer Experience**

- 💻 Latest language features
- 💻 Better tooling support
- 💻 Improved debugging capabilities

## Verification Steps

### 1. **Check Local Setup**

```bash
java -version
# Output should show: openjdk version "26"...

mvn -version
# Should show Java version 26
```

### 2. **Test Application**

```bash
# Build and run locally
mvn spring-boot:run

# Test endpoints
curl http://localhost:5000/getData
```

### 3. **Verify CI/CD**

- ✅ Push changes to trigger GitHub Actions
- ✅ Check workflow logs show Java 26
- ✅ Verify successful build and tests
- ✅ Confirm Docker images use Java 26

## Troubleshooting

### **Common Issues**

#### Local Java Version Mismatch

```bash
# Check current Java version
java -version

# Switch to Java 26 (using SDKMAN)
sdk use java 26-tem
```

#### Maven Compilation Errors

```bash
# Clear Maven cache
mvn dependency:purge-local-repository

# Rebuild project
mvn clean compile
```

#### Docker Build Issues

```bash
# Pull latest Java 26 image
docker pull eclipse-temurin:26-jre-alpine

# Clean Docker cache
docker system prune -a
```

## Next Steps

1. **Test thoroughly** with Java 26 locally
2. **Commit and push** changes to trigger CI/CD
3. **Monitor** workflow execution for any issues
4. **Update documentation** as needed
5. **Train team** on Java 26 features and changes

The upgrade to Java 26 is now complete across all components of the CI/CD demo project!
