#!/bin/sh

set -eu

# Create a directory to store the IDEs in.
mkdir -p /ides

# Download the required IntelliJ version.
curl -L --output "idea-$INPUT_VERSION.zip" "https://www.jetbrains.com/intellij-repository/releases/com/jetbrains/intellij/idea/ideaIU/$INPUT_VERSION/ideaIU-$INPUT_VERSION.zip"

# Extract the zip.
unzip -d "/ides/$INPUT_VERSION" "idea-$INPUT_VERSION.zip"

# Set the correct JAVA_HOME path in case this is overwritten by a setup-java action.
JAVA_HOME="/opt/java/openjdk"

# Execute the verifier.
echo "Running verification..."
java -jar /verifier.jar check-plugin "$INPUT_PLUGIN" "/ides/$INPUT_VERSION" 2>&1 > "log-$INPUT_VERSION.txt"

# Output the log
cat "log-$INPUT_VERSION.txt"

# Validate the log
egrep "^Plugin (.*) against .*: Compatible$" "log-$INPUT_VERSION.txt"
