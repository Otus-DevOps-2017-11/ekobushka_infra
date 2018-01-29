#!/usr/bin/env bash

# Изменить на свое имя проекта
PROJECT_NAME="infra-188905"
IMAGE_FAMILY="reddit-full"

gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family=$IMAGE_FAMILY \
  --image-project=$PROJECT_NAME \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --zone=europe-west1-b
