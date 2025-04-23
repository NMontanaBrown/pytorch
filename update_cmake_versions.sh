#!/bin/bash
# Script to update CMake minimum required versions in third-party libraries
# Run this script after git clone and git submodule update --init --recursive
# This script ensures all CMake minimum required versions are at least 3.5

set -e

echo "Starting comprehensive CMake version update..."

# Main update function for all CMakeLists.txt files
update_cmake_versions() {
  echo "Updating all CMakeLists.txt files to require exactly CMake 3.5"
  
  # We need to handle different variations of cmake_minimum_required statements:
  # 1. With or without spaces between "cmake_minimum_required" and "("
  # 2. With or without spaces between "VERSION" and the version number
  # 3. Handle both lowercase and uppercase variants
  # 4. Handle version ranges (3.8...3.28)
  
  # Update ALL files with cmake_minimum_required to VERSION 3.5
  echo "  Updating all cmake_minimum_required statements to VERSION 3.5..."
  find third_party -name "CMakeLists.txt" -type f -exec grep -l -i "cmake_minimum_required" {} \; | xargs -I{} sed -i.bak -E 's/[cC][mM][aA][kK][eE]_[mM][iI][nN][iI][mM][uU][mM]_[rR][eE][qQ][uU][iI][rR][eE][dD]\s*\(\s*VERSION\s+[0-9]+(\.[0-9]+)*((\.\.\.|\.\.)[0-9]+(\.[0-9]+)*)?([^)]*)\)/cmake_minimum_required(VERSION 3.5\5)/g' {}
  
  # Special handling for specific files known to have issues
  echo "  Directly updating key problematic files..."
  
  # List of problematic files to check and directly update
  problematic_files=(
    "third_party/NNPACK/CMakeLists.txt"
    "third_party/gloo/CMakeLists.txt"
    "third_party/FP16/CMakeLists.txt"
    "third_party/ittapi/CMakeLists.txt"
    "third_party/protobuf/cmake/CMakeLists.txt"
    "third_party/fmt/CMakeLists.txt"
    "third_party/composable_kernel/CMakeLists.txt"
    "third_party/opentelemetry-cpp/tools/vcpkg/ports/jxrlib/CMakeLists.txt"
    "third_party/mimalloc/CMakeLists.txt"
    "third_party/tensorpipe/third_party/libuv/CMakeLists.txt"
  )
  
  for file in "${problematic_files[@]}"; do
    if [ -f "$file" ]; then
      echo "    Directly updating $file"
      # Replace any cmake_minimum_required with VERSION 3.5 FATAL_ERROR
      cp "$file" "$file.original"
      grep -v -E "[cC][mM][aA][kK][eE]_[mM][iI][nN][iI][mM][uU][mM]_[rR][eE][qQ][uU][iI][rR][eE][dD]" "$file.original" > "$file.tmp" || true
      echo 'cmake_minimum_required(VERSION 3.5 FATAL_ERROR)' | cat - "$file.tmp" > "$file"
      rm -f "$file.tmp" "$file.original"
    fi
  done
  
  # Handle specific problematic dependencies
  update_specific_dependencies
  
  # Clean up backup files
  echo "  Cleaning up backup files..."
  find third_party -name "*.bak" -delete
}

# Update specific dependencies that might need extra handling
update_specific_dependencies() {
  # Handle specific categories of files
  echo "  Updating specific categories of files..."

  # pybind11 directories
  echo "  Updating pybind11 CMakeLists.txt files"
  find third_party -path "*/pybind11*/CMakeLists.txt" -type f -exec sed -i.bak -E 's/[cC][mM][aA][kK][eE]_[mM][iI][nN][iI][mM][uU][mM]_[rR][eE][qQ][uU][iI][rR][eE][dD]\s*\(\s*VERSION\s+[0-9]+\.[0-9]+((\.\.\.|\.\.)[0-9]+(\.[0-9]+)*)?([^)]*)\)/cmake_minimum_required(VERSION 3.5 FATAL_ERROR)/g' {} \;

  # Special handling for conan-related files
  echo "  Updating Conan-related CMakeLists.txt files"
  find third_party -path "*/conan*/CMakeLists.txt" -type f -exec sed -i.bak -E 's/[cC][mM][aA][kK][eE]_[mM][iI][nN][iI][mM][uU][mM]_[rR][eE][qQ][uU][iI][rR][eE][dD]\s*\(\s*VERSION\s+[0-9]+\.[0-9]+((\.\.\.|\.\.)[0-9]+(\.[0-9]+)*)?([^)]*)\)/cmake_minimum_required(VERSION 3.5 FATAL_ERROR)/g' {} \;
  
  # Handle GoogleTest directories specifically
  echo "  Updating GoogleTest CMakeLists.txt files"
  find third_party -path "*/googletest*/CMakeLists.txt" -type f -exec sed -i.bak -E 's/[cC][mM][aA][kK][eE]_[mM][iI][nN][iI][mM][uU][mM]_[rR][eE][qQ][uU][iI][rR][eE][dD]\s*\(\s*VERSION\s+[0-9]+\.[0-9]+((\.\.\.|\.\.)[0-9]+(\.[0-9]+)*)?([^)]*)\)/cmake_minimum_required(VERSION 3.5 FATAL_ERROR)/g' {} \;

  # Handle fmt directories 
  echo "  Updating fmt CMakeLists.txt files"
  find third_party -path "*/fmt*/CMakeLists.txt" -type f -exec sed -i.bak -E 's/[cC][mM][aA][kK][eE]_[mM][iI][nN][iI][mM][uU][mM]_[rR][eE][qQ][uU][iI][rR][eE][dD]\s*\(\s*VERSION\s+[0-9]+\.[0-9]+((\.\.\.|\.\.)[0-9]+(\.[0-9]+)*)?([^)]*)\)/cmake_minimum_required(VERSION 3.5 FATAL_ERROR)/g' {} \;
  
  # Handle vcpkg ports directories specifically
  if [ -d "third_party/opentelemetry-cpp/tools/vcpkg/ports" ]; then
    echo "  Updating vcpkg ports CMakeLists.txt files"
    find third_party/opentelemetry-cpp/tools/vcpkg/ports -name "CMakeLists.txt" -type f -exec sed -i.bak -E 's/[cC][mM][aA][kK][eE]_[mM][iI][nN][iI][mM][uU][mM]_[rR][eE][qQ][uU][iI][rR][eE][dD]\s*\(\s*VERSION\s+[0-9]+\.[0-9]+((\.\.\.|\.\.)[0-9]+(\.[0-9]+)*)?([^)]*)\)/cmake_minimum_required(VERSION 3.5 FATAL_ERROR)/g' {} \;
  fi

  # Handle main third-party projects
  echo "  Updating main third-party project files"
  main_projects=(
    "third_party/composable_kernel/CMakeLists.txt"
    "third_party/onnx/CMakeLists.txt"
    "third_party/gloo/CMakeLists.txt"
    "third_party/NNPACK/CMakeLists.txt"
    "third_party/FP16/CMakeLists.txt"
    "third_party/pthreadpool/CMakeLists.txt"
    "third_party/benchmark/CMakeLists.txt"
    "third_party/nlohmann/CMakeLists.txt"
    "third_party/flatbuffers/CMakeLists.txt"
    "third_party/fbgemm/CMakeLists.txt"
    "third_party/mimalloc/CMakeLists.txt"
    "third_party/tensorpipe/CMakeLists.txt"
    "third_party/kineto/CMakeLists.txt"
    "third_party/ittapi/CMakeLists.txt"
    "third_party/XNNPACK/CMakeLists.txt"
    "third_party/cudnn_frontend/CMakeLists.txt"
    "third_party/googletest/CMakeLists.txt"
    "third_party/opentelemetry-cpp/CMakeLists.txt"
    "third_party/kleidiai/CMakeLists.txt"
    "third_party/sleef/CMakeLists.txt"
    "third_party/psimd/CMakeLists.txt"
    "third_party/cutlass/CMakeLists.txt"
    "third_party/cpp-httplib/CMakeLists.txt"
    "third_party/cpuinfo/CMakeLists.txt"
    "third_party/NVTX/CMakeLists.txt"
  )

  for project in "${main_projects[@]}"; do
    if [ -f "$project" ]; then
      echo "    Directly updating $project"
      cp "$project" "$project.original"
      grep -v -E "[cC][mM][aA][kK][eE]_[mM][iI][nN][iI][mM][uU][mM]_[rR][eE][qQ][uU][iI][rR][eE][dD]" "$project.original" > "$project.tmp" || true
      echo 'cmake_minimum_required(VERSION 3.5 FATAL_ERROR)' | cat - "$project.tmp" > "$project"
      rm -f "$project.tmp" "$project.original"
    fi
  done
  
  # Large-scale update of all remaining files - convert any cmake_minimum_required to version 3.5 FATAL_ERROR
  echo "  Updating all remaining CMakeLists.txt files to 3.5"
  find third_party -name "CMakeLists.txt" -type f -exec grep -l -i "cmake_minimum_required" {} \; | while read -r file; do
    if grep -q -i "cmake_minimum_required" "$file"; then
      echo "    Setting $file to VERSION 3.5 FATAL_ERROR"
      cp "$file" "$file.original"
      grep -v -E "[cC][mM][aA][kK][eE]_[mM][iI][nN][iI][mM][uU][mM]_[rR][eE][qQ][uU][iI][rR][eE][dD]" "$file.original" > "$file.tmp" || true
      echo 'cmake_minimum_required(VERSION 3.5 FATAL_ERROR)' | cat - "$file.tmp" > "$file"
      rm -f "$file.tmp" "$file.original"
    fi
  done
}

# Update test directory if it exists
if [ -f "test/edge/CMakeLists.txt" ]; then
  echo "Updating test/edge/CMakeLists.txt"
  sed -i.bak 's/cmake_minimum_required(VERSION 3.1)/cmake_minimum_required(VERSION 3.5 FATAL_ERROR)/' test/edge/CMakeLists.txt
  rm -f test/edge/CMakeLists.txt.bak
fi

# Main function call
update_cmake_versions

echo "CMake versions updated successfully! All CMakeLists.txt files now require at least CMake 3.5."