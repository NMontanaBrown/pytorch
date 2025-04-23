#!/bin/bash
# Script to update CMake minimum required versions in third-party libraries
# Run this script after git clone and git submodule update --init --recursive

set -e

# Update edge CMakeLists.txt
if [ -f "test/edge/CMakeLists.txt" ]; then
  echo "Updating test/edge/CMakeLists.txt"
  sed -i.bak 's/cmake_minimum_required(VERSION 3.1)/cmake_minimum_required(VERSION 3.5 FATAL_ERROR)/' test/edge/CMakeLists.txt
  rm -f test/edge/CMakeLists.txt.bak
fi

# Update gloo CMakeLists.txt
if [ -f "third_party/gloo/CMakeLists.txt" ]; then
  echo "Updating third_party/gloo/CMakeLists.txt"
  sed -i.bak 's/cmake_minimum_required(VERSION 2.8.12 FATAL_ERROR)/cmake_minimum_required(VERSION 3.5 FATAL_ERROR)/' third_party/gloo/CMakeLists.txt
  rm -f third_party/gloo/CMakeLists.txt.bak
fi

# Update NNPACK CMakeLists.txt
if [ -f "third_party/NNPACK/CMakeLists.txt" ]; then
  echo "Updating third_party/NNPACK/CMakeLists.txt"
  sed -i.bak 's/CMAKE_MINIMUM_REQUIRED(VERSION 3\.[0-4] FATAL_ERROR)/CMAKE_MINIMUM_REQUIRED(VERSION 3.5 FATAL_ERROR)/' third_party/NNPACK/CMakeLists.txt
  rm -f third_party/NNPACK/CMakeLists.txt.bak
fi

# Update FP16 CMakeLists.txt
if [ -f "third_party/FP16/CMakeLists.txt" ]; then
  echo "Updating third_party/FP16/CMakeLists.txt"
  sed -i.bak 's/CMAKE_MINIMUM_REQUIRED(VERSION 3\.[0-4] FATAL_ERROR)/CMAKE_MINIMUM_REQUIRED(VERSION 3.5 FATAL_ERROR)/' third_party/FP16/CMakeLists.txt
  rm -f third_party/FP16/CMakeLists.txt.bak
fi

# Update pthreadpool CMakeLists.txt
if [ -f "third_party/pthreadpool/CMakeLists.txt" ]; then
  echo "Updating third_party/pthreadpool/CMakeLists.txt"
  sed -i.bak 's/CMAKE_MINIMUM_REQUIRED(VERSION 3\.[0-4] FATAL_ERROR)/CMAKE_MINIMUM_REQUIRED(VERSION 3.5 FATAL_ERROR)/' third_party/pthreadpool/CMakeLists.txt
  rm -f third_party/pthreadpool/CMakeLists.txt.bak
fi

# Update benchmark CMakeLists.txt
if [ -f "third_party/benchmark/CMakeLists.txt" ]; then
  echo "Updating third_party/benchmark/CMakeLists.txt"
  sed -i.bak 's/cmake_minimum_required (VERSION 3.[0-4])/cmake_minimum_required (VERSION 3.5.1)/' third_party/benchmark/CMakeLists.txt
  rm -f third_party/benchmark/CMakeLists.txt.bak
fi

# Update any other CMakeLists.txt files with version < 3.5
find third_party -name CMakeLists.txt -exec grep -l "cmake_minimum_required.*VERSION [0-2]" {} \; | while read file; do
  echo "Updating $file"
  sed -i.bak 's/cmake_minimum_required.*VERSION [0-2][^)]*)/cmake_minimum_required(VERSION 3.5 FATAL_ERROR)/' "$file"
  rm -f "$file.bak"
done

find third_party -name CMakeLists.txt -exec grep -l "CMAKE_MINIMUM_REQUIRED.*VERSION [0-2]" {} \; | while read file; do
  echo "Updating $file"
  sed -i.bak 's/CMAKE_MINIMUM_REQUIRED.*VERSION [0-2][^)]*)/CMAKE_MINIMUM_REQUIRED(VERSION 3.5 FATAL_ERROR)/' "$file"
  rm -f "$file.bak"
done

echo "CMake versions updated in third-party libraries"