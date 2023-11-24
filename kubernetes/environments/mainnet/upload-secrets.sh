#!/usr/bin/env bash

set -e

FILENAME="./.env"

while IFS='=' read -r key value; do
  if [[ -z $key || $key == \#* ]]; then
    continue
  fi

  key=$(echo "$key" | awk '{gsub(/^ +| +$/,"")} {print $0}')
  value=${value#\"}; value=${value%\"}

  SECRET_KEY=$key
  SECRET_VALUE=$value
  SECRET_EXISTS=$(gcloud secrets versions access latest --secret=$SECRET_KEY || true)

  DELETE_EXISTING_SECRET=false
  CREATE_SECRET=false

  if [ "$SECRET_EXISTS" ]; then
    if [ "$SECRET_EXISTS" = "$SECRET_VALUE" ]; then
      DELETE_EXISTING_SECRET=false
      CREATE_SECRET=false
      echo "Secret ($SECRET_KEY) exists and equal value."
    else
      DELETE_EXISTING_SECRET=true
      CREATE_SECRET=true
      echo "Secret ($SECRET_KEY) exists but not equal value."
    fi
  else
    CREATE_SECRET=true
    echo "Secret ($SECRET_KEY) not exists."
  fi

  if [ $DELETE_EXISTING_SECRET = true ]; then
    echo "yes" | gcloud secrets delete "$SECRET_KEY" > /dev/null 2>&1
    echo "Existing secret ($SECRET_KEY) has been deleted."
  fi

  if [ $CREATE_SECRET = true ]; then
    printf '%s' "$SECRET_VALUE" | gcloud secrets create "$SECRET_KEY" --data-file=-
    echo "Secret ($SECRET_KEY) has been created."
  fi
done < "$FILENAME"
