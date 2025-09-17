#!/bin/bash

echo "🔍 COMPREHENSIVE WORKFLOW VALIDATION"
echo "===================================="

ERRORS=0

# Test 1: Check .snyk file
echo "1. Testing .snyk file..."
if ! python3 -c "import yaml; yaml.safe_load(open('.snyk'))" 2>/dev/null; then
    echo "   ❌ .snyk file has YAML syntax errors"
    ERRORS=$((ERRORS + 1))
else
    echo "   ✅ .snyk file is valid YAML"
fi

# Test 2: Check workflow files
echo "2. Testing workflow YAML files..."
for file in .github/workflows/*.yml; do
    if [ -f "$file" ]; then
        if ! python3 -c "import yaml; yaml.safe_load(open('$file'))" 2>/dev/null; then
            echo "   ❌ $file has YAML syntax errors"
            ERRORS=$((ERRORS + 1))
        else
            echo "   ✅ $file is valid YAML"
        fi
    fi
done

# Test 3: Maven wrapper
echo "3. Testing Maven wrapper..."
if ./mvnw --version >/dev/null 2>&1; then
    echo "   ✅ Maven wrapper works"
else
    echo "   ❌ Maven wrapper failed"
    ERRORS=$((ERRORS + 1))
fi

# Test 4: Docker files
echo "4. Testing Docker files..."
if [ -f "Dockerfile" ]; then
    echo "   ✅ Dockerfile exists"
else
    echo "   ❌ Dockerfile missing"
    ERRORS=$((ERRORS + 1))
fi

if [ -f "Dockerfile.secure" ]; then
    echo "   ✅ Dockerfile.secure exists"
else
    echo "   ❌ Dockerfile.secure missing"
    ERRORS=$((ERRORS + 1))
fi

# Test 5: Check for common workflow issues
echo "5. Checking workflow configurations..."

# Check for Java 21 setup
if grep -q "java-version.*21" .github/workflows/*.yml; then
    echo "   ✅ Java 21 configured in workflows"
else
    echo "   ❌ Java 21 not found in workflows"
    ERRORS=$((ERRORS + 1))
fi

# Check for Maven wrapper usage
if grep -q "./mvnw" .github/workflows/*.yml; then
    echo "   ✅ Maven wrapper used in workflows"
else
    echo "   ❌ Maven wrapper not used in workflows"
    ERRORS=$((ERRORS + 1))
fi

# Check for Snyk token usage
if grep -q "SNYK_TOKEN" .github/workflows/*.yml; then
    echo "   ✅ SNYK_TOKEN configured in workflows"
else
    echo "   ❌ SNYK_TOKEN not found in workflows"
    ERRORS=$((ERRORS + 1))
fi

# Test 6: Check for problematic JAVA_HOME references
echo "6. Checking JAVA_HOME references..."
if grep -q "JAVA_HOME.*env.JAVA_HOME" .github/workflows/*.yml; then
    echo "   ❌ Found problematic JAVA_HOME references"
    ERRORS=$((ERRORS + 1))
else
    echo "   ✅ No problematic JAVA_HOME references found"
fi

echo ""
echo "📊 VALIDATION SUMMARY"
echo "===================="
if [ $ERRORS -eq 0 ]; then
    echo "🎉 ALL TESTS PASSED! Workflows should work correctly."
    echo ""
    echo "✅ Ready to push to GitHub!"
    echo ""
    echo "Next steps:"
    echo "1. git add ."
    echo "2. git commit -m 'Fix Snyk workflow issues'"
    echo "3. git push origin master"
    exit 0
else
    echo "❌ $ERRORS issues found. Fix these before pushing:"
    echo ""
    echo "🚨 DO NOT PUSH YET - ISSUES NEED TO BE RESOLVED"
    exit 1
fi
