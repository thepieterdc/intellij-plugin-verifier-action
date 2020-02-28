#!/bin/sh

set -eu

# Create a directory to store the IDEs in.
mkdir -p /ides

# Set the correct JAVA_HOME path in case this is overwritten by a setup-java
# action.
JAVA_HOME="/opt/java/openjdk"

# Create an empty file to write the versions to. This is a small hack since
# appending to a string is not possible in sh pipes.
directories="/tmp/directories.txt"
echo "" > $directories

# Parse the versions array into a list of download links.
java -cp "/parser.jar" parser.Main | while read -r line; do
    # Find the name of the zip file.
    dir=$(echo "$line" | egrep -o "(ideaIU-.*)")
    dir=$(echo "${dir%.zip}")
    zipfile=$(echo "$dir.zip")

    # Write the name of the directory to the file
    sed -i "$ s+$+/ides/$dir +g" $directories

    # Download the required IntelliJ version.
    curl -L --output "$zipfile" "$line"

    # Extract the zip.
    unzip -d "/ides/$dir" "$zipfile"
done

# Reopen the created file to get the list of directories as a space-separated
# string.
ides=$(cat $directories)

# Execute the verifier.
echo "Running verification..."
verification_log="/tmp/verification.log"
java -jar /verifier.jar check-plugin "$INPUT_PLUGIN" $ides 2>&1 > "$verification_log"

# Output the log.
cat "$verification_log"

## Validate the log
if egrep -q "^Plugin (.*) against .*: .* compatibility problems?$" "$verification_log"; then
    # An error has occurred.
    exit 1
else
    # Everything's fine.
    exit 0
fi