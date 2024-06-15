#!/bin/bash

# Navigate to the project directory
cd /path/to/your/project

# Fetch and merge changes from the remote repository
git fetch origin
git merge origin/main

# Print a message indicating the pull is complete
echo "Pull completed successfully."

# Keep the terminal open
read -p "Press [Enter] key to close this window..."
