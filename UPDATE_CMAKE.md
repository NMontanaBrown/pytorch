# Updating CMake Versions in Third-Party Libraries

If you encounter CMake errors about deprecated versions (like `Compatibility with CMake < 3.5 has been removed`), use the `update_cmake_versions.sh` script to update the CMake minimum version requirements in all third-party dependencies.


## Make the script executable

```bash
chmod +x update_cmake_versions.sh
```

## Run the script

Run the script after cloning the repository and initializing submodules:

```bash
./update_cmake_versions.sh
```

## Complete Installation Flow

```bash
git clone --depth 1 --branch convtranspose_mps_remove_check https://github.com/NMontanaBrown/pytorch.git
cd pytorch
git submodule update --init --recursive
# Create and run the update script
chmod +x update_cmake_versions.sh
./update_cmake_versions.sh
pip install -r requirements.txt
python setup.py develop
```

This script updates the CMake minimum required versions in all third-party dependencies to ensure compatibility with modern CMake versions.