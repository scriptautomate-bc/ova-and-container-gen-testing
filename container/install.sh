#!/bin/bash
set -e

echo "Starting installation..."

# Update the package index and upgrade existing packages
tdnf update -y

# Install required packages
tdnf install -y git tar jq

echo "Installation complete."
