#!/bin/bash

# Check if file argument was provided
if [[ -z "$1" ]]; then
    osascript -e 'display notification "No file provided" with title "Increment and Save" sound name "Basso"'
    exit 1
fi

# Check if file exists
if [[ ! -f "$1" ]]; then
    osascript -e 'display notification "File does not exist" with title "Increment and Save" sound name "Basso"'
    exit 1
fi

# Get original file path
oldFilepath=$(dirname "$1")

# Get original file name
oldFilename=$(basename "$1")

# Get original extension
oldExtension=${oldFilename##*.}

# Convert underscore delimited string into an array
IFS='_' read -r -a underscoreDelimitedArray <<< "$oldFilename"

# Check if filename contains underscores
if [[ ${#underscoreDelimitedArray[@]} -lt 2 ]]; then
    osascript -e 'display notification "Filename must contain underscores and version number" with title "Increment and Save" sound name "Basso"'
    exit 1
fi

# Get the last index of the array (example is v00.ext)
oldVersionAndExtension=${underscoreDelimitedArray[${#underscoreDelimitedArray[@]}-1]}

# Remove the "v"
oldVersionNumberAndExtension=${oldVersionAndExtension##*v}

# Remove the extension
oldVersionNumber=${oldVersionNumberAndExtension%.*}

# Validate that we have a version number
if [[ -z "$oldVersionNumber" || ! "$oldVersionNumber" =~ ^[0-9]+$ ]]; then
    osascript -e 'display notification "Could not find valid version number (e.g., v01)" with title "Increment and Save" sound name "Basso"'
    exit 1
fi

# Convert from octal to decimal
decimalVersionNumber=$((10#$oldVersionNumber))

# Increment the current version number
incrementOldVersionNumber=$((decimalVersionNumber + 1))

# Reformat with a leading 0 if needed (two digits only)
leadingZeroNewVersionNumber=$(printf "%02d" $incrementOldVersionNumber)

# Rebuild the new version number and extension
newVersionNumber="_v${leadingZeroNewVersionNumber}.${oldExtension}"

# Remove the last index in the original array
unset 'underscoreDelimitedArray[${#underscoreDelimitedArray[@]}-1]'

# Create a space delimited string from the array
spaceDelimitedFileName=${underscoreDelimitedArray[@]}

# Replace the space delimiter with an underscore
underscoreDelimitedFileName=${spaceDelimitedFileName// /_}

# Rebuild the new file name
newFilename="${underscoreDelimitedFileName}${newVersionNumber}"

# Duplicate and version up the old file
cp "$oldFilepath/$oldFilename" "$oldFilepath/$newFilename"

# Move the old file to the "_Archive" folder if the folder exists
[[ -d "$oldFilepath/_Archive" ]] && mv "$oldFilepath/$oldFilename" "$oldFilepath/_Archive/$oldFilename"

# Notify completion
osascript -e 'display notification "Process complete!" with title "Increment and Save" sound name "Blow"'