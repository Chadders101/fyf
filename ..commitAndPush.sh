#!/bin/bash

# Prompt for a commit message
echo "Enter commit message: "
read commitMessage

# Add all changes to the staging area
git add .

# Commit the changes with the provided message
git commit -m "$commitMessage"

# Fetch and merge changes from the remote repository to avoid conflicts
git fetch origin
git merge origin/main

# Push the changes to the remote repository
git push origin main

# Print a message indicating the push is complete
echo "Commit and push completed successfully."

# Keep the terminal open
read -p "Press [Enter] key to close this window..."
