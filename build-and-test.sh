#!/bin/bash

# =====================================================
# Smart Campus Navigation - Build and Test Script
# =====================================================

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=============================================${NC}"
echo -e "${BLUE}  Smart Campus Navigation - Build & Test${NC}"
echo -e "${BLUE}=============================================${NC}"
echo

# Function to print colored message
print_msg() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Check Java
print_msg "$YELLOW" "Checking Java..."
if ! command -v java &> /dev/null; then
    print_msg "$RED" "✗ Java not found! Please install Java 11+"
    exit 1
fi
java_version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
print_msg "$GREEN" "✓ Java version: $java_version"
echo

# Check Maven
print_msg "$YELLOW" "Checking Maven..."
if ! command -v mvn &> /dev/null; then
    print_msg "$RED" "✗ Maven not found! Please install Maven 3.8+"
    exit 1
fi
mvn_version=$(mvn -version | head -n 1)
print_msg "$GREEN" "✓ $mvn_version"
echo

# Clean
print_msg "$YELLOW" "Cleaning previous builds..."
mvn clean -q
print_msg "$GREEN" "✓ Clean complete"
echo

# Compile
print_msg "$YELLOW" "Compiling project..."
if mvn compile -q; then
    print_msg "$GREEN" "✓ Compilation successful"
else
    print_msg "$RED" "✗ Compilation failed"
    exit 1
fi
echo

# Run tests
print_msg "$YELLOW" "Running tests..."
if mvn test; then
    print_msg "$GREEN" "✓ All tests passed"
else
    print_msg "$RED" "✗ Some tests failed"
    exit 1
fi
echo

# Generate test coverage report
print_msg "$YELLOW" "Generating code coverage report..."
mvn jacoco:report -q
if [ -f "target/site/jacoco/index.html" ]; then
    print_msg "$GREEN" "✓ Coverage report generated: target/site/jacoco/index.html"
else
    print_msg "$YELLOW" "⚠ Coverage report not found"
fi
echo

# Package
print_msg "$YELLOW" "Packaging application..."
if mvn package -DskipTests -q; then
    print_msg "$GREEN" "✓ Packaging successful"
    
    # Find JAR file
    jar_file=$(ls target/smart-campus-navigation-*.jar 2>/dev/null | head -n 1)
    if [ ! -z "$jar_file" ]; then
        jar_size=$(du -h "$jar_file" | cut -f1)
        print_msg "$GREEN" "✓ JAR created: $jar_file ($jar_size)"
    fi
else
    print_msg "$RED" "✗ Packaging failed"
    exit 1
fi
echo

# Summary
print_msg "$BLUE" "============================================="
print_msg "$GREEN" "  ✓ Build and Test Complete!"
print_msg "$BLUE" "============================================="
echo
print_msg "$GREEN" "Next steps:"
echo -e "  1. Run application: ${YELLOW}./deploy.sh start${NC}"
echo -e "  2. Test API: ${YELLOW}./test-api.sh${NC}"
echo -e "  3. View coverage: ${YELLOW}open target/site/jacoco/index.html${NC}"
echo -e "  4. Run SonarQube: ${YELLOW}mvn sonar:sonar${NC}"
echo

