#!/usr/bin/env bash

gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --zone=europe-west1-b \
  --metadata "startup-script-url=https://raw.githubusercontent.com/Otus-DevOps-2017-11/ekobushka_infra/Infra-2/startup_script.sh"
