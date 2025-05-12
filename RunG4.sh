#!/bin/bash
tically obtain the current folder name as the project name
project_name=$(basename "$(pwd)")

# Display the current project name (optional)
echo "Processing project: ${project_name}"

# Remove the build folder if it already exists
rm -rf "build"

# Create the build folder
mkdir "build"

# Enter the build folder
cd "build" || { echo "Unable to enter build folder"; exit 1; }

# Run cmake to generate build files (pointing to the project root)
cmake ".." || { echo "cmake failed"; exit 1; }

# Run make to compile the project
make || { echo "make failed"; exit 1; }

# Execute the compiled binary
./"${project_name}" || { echo "Unable to execute ${project_name}"; exit 1; }