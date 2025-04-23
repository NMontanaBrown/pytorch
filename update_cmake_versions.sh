#!/bin/bash
# Script to update CMake minimum required versions in specific third-party libraries
# This script ensures specific CMake files are updated to version 3.5

set -e

echo "Starting targeted CMake version update..."

# List of files to update
files_to_update=(
  "third_party/protobuf/cmake/CMakeLists.txt"
  "third_party/psimd/CMakeLists.txt"
  "third_party/NNPACK/CMakeLists.txt"
  "third_party/FP16/CMakeLists.txt"
  "third_party/ittapi/CMakeLists.txt"
  "third_party/tensorpipe/third_party/libuv/CMakeLists.txt"
  "third_party/gloo/CMakeLists.txt"
  "third_party/ideep/mkl-dnn/CMakeLists.txt"
  "test/edge/CMakeLists.txt"
)

# Function to update CMake version in a file
update_cmake_version() {
  local file=$1
  
  if [ -f "$file" ]; then
    echo "Updating $file to require CMake 3.5"
    
    # Create a backup of the original file
    cp "$file" "$file.original"
    
    # Remove any existing cmake_minimum_required line
    grep -v -E "[cC][mM][aA][kK][eE]_[mM][iI][nN][iI][mM][uU][mM]_[rR][eE][qQ][uU][iI][rR][eE][dD]" "$file.original" > "$file.tmp" || true
    
    # Add the new cmake_minimum_required line at the top of the file
    echo 'cmake_minimum_required(VERSION 3.5 FATAL_ERROR)' | cat - "$file.tmp" > "$file"
    
    # Clean up temporary files
    rm -f "$file.tmp" "$file.original"
    
    echo "  Updated $file successfully"
  else
    echo "  Warning: $file not found, skipping"
  fi
}

# Update each file in the list
for file in "${files_to_update[@]}"; do
  update_cmake_version "$file"
done

echo "CMake version update completed successfully!"