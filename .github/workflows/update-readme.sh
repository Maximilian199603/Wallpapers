name: Update README with Image Grid

on:
  push:
    paths:
      - '*.jpg'
      - '*.png'
      - '*.jpeg'
      - '*.tiff'
      - '*.bmp'  # Trigger the action when image files are added/modified
  workflow_dispatch:  # Allow manual trigger of the workflow if needed

jobs:
  update-readme:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout repository
      uses: actions/checkout@v3
      with:
        fetch-depth: 0  # Fetch the full history

    - name: Set up Git
      run: |
        git config --global user.name "GitHub Action"
        git config --global user.email "action@github.com"

    - name: Generate README
      run: |
        chmod +x ./generate_readme.sh
        ./generate_readme.sh

    - name: Commit and push changes
      run: |
        git add README.md
        git commit -m "Update README with image grid"
        git push
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}  # GitHub token for authentication
