#!/bin/bash

# Purpose: This script creates Google Kubernetes Engine (GKE) clusters for staging and production environments.
# Usage:
#   Before running, make the script executable:
#     chmod +x create_clusters.sh
#   Run the script:
#     ./create_clusters.sh
#
# Prerequisites:
#   - Google Cloud SDK must be installed and configured with appropriate permissions.
#   - Ensure you're authenticated with your Google Cloud account where you have permission to create clusters.

# Function to check if gcloud is installed
function check_gcloud_installed() {
    if ! command -v gcloud &> /dev/null; then
        echo "gcloud could not be found, please install and configure it first."
        exit 1
    fi
}

# Main execution starts here
# Check if gcloud is available on the system
check_gcloud_installed

echo "Creating GKE cluster for staging..."
gcloud container clusters create "staging-cluster" \
    --zone "us-central1-a" \
    --num-nodes "3" \
    --machine-type "e2-standard-4" || { echo "Failed to create staging cluster"; exit 1; }

echo "Creating GKE cluster for production..."
gcloud container clusters create "production-cluster" \
    --zone "us-central1-a" \
    --num-nodes "5" \
    --machine-type "e2-standard-4" || { echo "Failed to create production cluster"; exit 1; }

echo "Clusters created successfully."
