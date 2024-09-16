#!/bin/bash

# Define the directory containing the images
image_dir="."

# Initialize the associative array for storing image URLs
declare -A image_urls

# Loop through all images in the directory, sorted alphabetically
for image in $(find "$image_dir" -type f \( -name '*.jpg' -o -name '*.png' -o -name '*.jpeg' -o -name '*.tiff' -o -name '*.bmp' \) | sort); do
    echo "Processing image: $image"

    # Fetch the commit hash and message for the image
    log_output=$(git log --pretty=format:"%H %s" -- "$image")
    echo "Git log output for $image:"
    echo "$log_output"

    # Process each line of the git log output
    while IFS= read -r line; do
        # Split the line into commit_hash and commit_message
        IFS=' ' read -r commit_hash commit_message <<< "$line"
        
        # Print the extracted commit hash and message
        echo "Commit hash: $commit_hash"
        echo "Commit message: $commit_message"

        # Store the commit message (URL) for the image
        image_urls["$image"]="$commit_message"
    done <<< "$log_output"
done

# Create the HTML content
html_content="<html><body><h1>Wallpapers Collection</h1><p>Here is a collection of wallpapers. Click on an image to view its source.</p>"

# Build the image list in HTML
for image in "${!image_urls[@]}"; do
    url="${image_urls[$image]}"
    html_content+="<div><a href=\"$url\"><img src=\"$image\" alt=\"\" style=\"width: 100%; height: auto;\"></a></div>"
done

html_content+="</body></html>"

# Save the HTML content to README.md
echo "$html_content" > README.md

echo "README.md has been generated."
