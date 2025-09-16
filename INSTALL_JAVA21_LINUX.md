# Installing Java 21 on Linux - Multiple Options

## Option 1: Install SDKMAN First (Recommended)

SDKMAN is a tool for managing multiple Java versions. Install it first:

```bash
# Install SDKMAN
curl -s "https://get.sdkman.io" | bash

# Reload your shell
source ~/.bashrc
# OR restart your terminal

# Verify SDKMAN is installed
sdk version

# Now install Java 21
sdk install java 21-tem
sdk use java 21-tem

# Verify Java installation
java -version
```

## Option 2: Direct Installation (Ubuntu/Debian)

If you prefer not to use SDKMAN, install Java 21 directly:

```bash
# Update package manager
sudo apt update

# Install OpenJDK 21
sudo apt install -y openjdk-21-jdk

# Set JAVA_HOME (add to ~/.bashrc for persistence)
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

# Verify installation
java -version
javac -version
```

## Option 3: Manual Download and Installation

Download directly from Eclipse Temurin:

```bash
# Create directory for Java
sudo mkdir -p /opt/java

# Download Java 21 (adjust URL for latest version)
cd /tmp
wget https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.4%2B7/OpenJDK21U-jdk_x64_linux_hotspot_21.0.4_7.tar.gz

# Extract to /opt/java
sudo tar -xzf OpenJDK21U-jdk_x64_linux_hotspot_21.0.4_7.tar.gz -C /opt/java

# Set up environment variables
echo 'export JAVA_HOME=/opt/java/jdk-21.0.4+7' >> ~/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc

# Reload environment
source ~/.bashrc

# Verify installation
java -version
```

## Option 4: Using Snap (Alternative)

```bash
# Install Java 21 using snap
sudo snap install openjdk

# Set JAVA_HOME
echo 'export JAVA_HOME=/snap/openjdk/current' >> ~/.bashrc
source ~/.bashrc

# Verify
java -version
```

## Quick Setup Script

Create and run this script for automatic installation:

```bash
# Create setup script
cat > install_java21.sh << 'EOF'
#!/bin/bash

echo "Installing Java 21..."

# Update system
sudo apt update

# Install OpenJDK 21
sudo apt install -y openjdk-21-jdk

# Get the actual JAVA_HOME path
JAVA_HOME_PATH=$(readlink -f /usr/bin/java | sed "s:bin/java::")

# Set environment variables
echo "export JAVA_HOME=${JAVA_HOME_PATH}" >> ~/.bashrc
echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> ~/.bashrc

# Reload environment
source ~/.bashrc

echo "Java 21 installation completed!"
echo "Current Java version:"
java -version

echo ""
echo "To use in current terminal, run:"
echo "source ~/.bashrc"
EOF

# Make executable and run
chmod +x install_java21.sh
./install_java21.sh
```

## Verification Commands

After installation, verify with these commands:

```bash
# Check Java version
java -version

# Check Java compiler
javac -version

# Check JAVA_HOME
echo $JAVA_HOME

# Check Maven uses correct Java
mvn -version
```

## Expected Output

You should see something like:

```
openjdk version "21.0.4" 2024-07-16
OpenJDK Runtime Environment (build 21.0.4+7-Ubuntu-1ubuntu2)
OpenJDK 64-Bit Server VM (build 21.0.4+7-Ubuntu-1ubuntu2, mixed mode, sharing)
```

## Troubleshooting

### If Java is not in PATH:

```bash
# Find Java installation
sudo find /usr -name "java" -type f 2>/dev/null | grep bin

# Add to PATH manually
export PATH=/usr/lib/jvm/java-21-openjdk-amd64/bin:$PATH
```

### If multiple Java versions exist:

```bash
# List installed Java versions
sudo update-alternatives --list java

# Configure default Java
sudo update-alternatives --config java
```

### For Maven to use Java 21:

```bash
# Check Maven's Java version
mvn -version

# If wrong Java, ensure JAVA_HOME is set correctly
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
```

## Quick Command Summary

Choose the easiest option for your system:

**Option 1 (SDKMAN):**

```bash
curl -s "https://get.sdkman.io" | bash
source ~/.bashrc
sdk install java 21-tem
```

**Option 2 (Direct Install):**

```bash
sudo apt update && sudo apt install -y openjdk-21-jdk
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
```

After installation, you can build and run your project with Java 21!
