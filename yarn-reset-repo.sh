#!/bin/bash

# --- Recommended Yarn Commands (Run these first if possible) ---
# It's often good practice to let Yarn try to clean things up itself.
# You might want to run these commands in your monorepo root before using this script:

echo "INFO: Consider running 'yarn cache clean' in your monorepo root first."
echo "INFO: For Yarn Modern (Berry), you might also consider 'yarn install --immutable' to check consistency."
read -p "Do you want to skip running this script and try those commands first? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Exiting. Please run the recommended Yarn commands."
    exit 0
fi

echo "🔍 Starting search for Yarn artifacts to delete..."

# --- Files and Directories to Delete ---
# Add or remove patterns as needed for your specific monorepo structure.

# Common Yarn classic and Berry artifacts
declare -a targets=(
    "node_modules"
    "yarn.lock"
    ".yarn/cache"
    ".yarn/patches"
    ".yarn/install-state.gz"
    ".yarn/build-state.yml"
    ".yarn/unplugged"
    ".pnp.cjs"
    ".pnp.loader.mjs"
)

# For monorepos, node_modules can be in many places.
# We'll use 'find' for these.

echo "------------------------------------------------------------------"
echo "Searching for 'node_modules' directories..."
echo "------------------------------------------------------------------"
# Find all directories named node_modules
# Using -type d for directories and -print0 / read -d $'\0' for safe handling of names
find . -name "node_modules" -type d -prune -print0 | while IFS= read -r -d $'\0' dir; do
    # MODIFICATION HERE: Added 'REPLY' and '< /dev/tty'
    read -p "❓ Delete directory: '$dir'? (y/N) " -n 1 -r REPLY < /dev/tty
    echo # Move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Deleting '$dir'..."
        rm -rf "$dir"
        if [ $? -eq 0 ]; then
            echo "✅ Successfully deleted '$dir'."
        else
            echo "❌ ERROR: Could not delete '$dir'."
        fi
    else
        echo "Skipping '$dir'."
    fi
done

echo "------------------------------------------------------------------"
echo "Searching for other Yarn specific files/directories in the root..."
echo "------------------------------------------------------------------"
# Process other targets, assuming they are mostly in the root or .yarn directory
for target_name in "${targets[@]}"; do
    # Skip node_modules as it's handled above
    if [[ "$target_name" == "node_modules" ]]; then
        continue
    fi

    # Find files or directories matching the target name
    # We'll search from the current directory downwards, but some of these
    # like yarn.lock are usually only at the root.
    # For .yarn/* items, we specifically look for them.

    find_path="." # Search from current directory
    if [[ "$target_name" == ".yarn/"* ]]; then
      # If it's a .yarn subdirectory, search for that specific path
      # relative to where .yarn directories might be.
      # This simple script will assume .yarn is at the root.
      # For complex monorepos with nested .yarn, 'find' might need adjustment.
      potential_path="./$target_name"
      if [ -e "$potential_path" ]; then # Check if it exists (file or directory)
          read -p "❓ Delete: '$potential_path'? (y/N) " -n 1 -r
          echo
          if [[ $REPLY =~ ^[Yy]$ ]]; then
              echo "Deleting '$potential_path'..."
              rm -rf "$potential_path"
              if [ $? -eq 0 ]; then
                  echo "✅ Successfully deleted '$potential_path'."
              else
                  echo "❌ ERROR: Could not delete '$potential_path'."
              fi
          else
              echo "Skipping '$potential_path'."
          fi
      else
          echo "INFO: '$potential_path' not found."
      fi
    elif [ -e "./$target_name" ]; then # Check if yarn.lock or other root files exist
        read -p "❓ Delete file/directory: './$target_name'? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Deleting './$target_name'..."
            rm -rf "./$target_name"
            if [ $? -eq 0 ]; then
                echo "✅ Successfully deleted './$target_name'."
            else
                echo "❌ ERROR: Could not delete './$target_name'."
            fi
        else
            echo "Skipping './$target_name'."
        fi
    else
        echo "INFO: './$target_name' not found in the current directory."
    fi
done

echo "------------------------------------------------------------------"
echo "🎉 Yarn artifact cleanup process finished."
echo "You may now want to run 'yarn install' to reinstall dependencies."
echo "------------------------------------------------------------------"