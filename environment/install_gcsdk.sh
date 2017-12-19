#!/usr/bin/env bash

# Create an environment variable for the correct distribution
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"

# Add the Cloud SDK distribution URI as a package source
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

# Import the Google Cloud public key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Update and install the Cloud SDK
sudo apt-get update && sudo apt-get install google-cloud-sdk

# Optionally install any of these additional components

sudo apt-get install google-cloud-sdk-app-engine-python
sudo apt-get install google-cloud-sdk-app-engine-java
sudo apt-get install google-cloud-sdk-app-engine-go
sudo apt-get install google-cloud-sdk-datalab
sudo apt-get install google-cloud-sdk-datastore-emulator
sudo apt-get install google-cloud-sdk-pubsub-emulator
sudo apt-get install google-cloud-sdk-cbt
sudo apt-get install google-cloud-sdk-bigtable-emulator
sudo apt-get install kubectl

# Run gcloud init to get started
gcloud init




