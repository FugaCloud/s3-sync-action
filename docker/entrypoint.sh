#!/bin/bash

if [ -z "${ACCESS_KEY_ID}" ]; then
  echo "ACCESS_KEY_ID is not set. Quitting."
  exit 1
fi

if [ -z "${SECRET_ACCESS_KEY}" ]; then
  echo "SECRET_ACCESS_KEY is not set. Quitting."
  exit 1
fi

if [ -z "${BUCKET}" ]; then
  echo "BUCKET is not set. Quitting."
  exit 1
fi

if [ -z "${DEST_DIR}" ]; then
  DEST_DIR=""
else
  DEST_DIR=${DEST_DIR#/}
  DEST_DIR=${DEST_DIR%/}
  DEST_DIR=${DEST_DIR}
fi

if [ -z "${SOURCE_DIR}" ]; then
  SOURCE_DIR=./
fi

export RCLONE_CONFIG_TARGETS3_TYPE="s3"
export RCLONE_CONFIG_TARGETS3_ACCESS_KEY_ID="${ACCESS_KEY_ID}"
export RCLONE_CONFIG_TARGETS3_SECRET_ACCESS_KEY="${SECRET_ACCESS_KEY}"

if [ -n "${ENDPOINT}" ]; then
  export RCLONE_CONFIG_TARGETS3_PROVIDER="other"
  export RCLONE_CONFIG_TARGETS3_ENDPOINT="${ENDPOINT}"
else
  export RCLONE_CONFIG_TARGETS3_PROVIDER="AWS"
fi

if [ -n "${REGION}" ]; then
  export RCLONE_CONFIG_TARGETS3_REGION="${REGION}"
fi

rclone sync "${SOURCE_DIR}" "targets3:${BUCKET}/${DEST_DIR}" $* || { echo 'Failed syncing the directory to Object Storage' ; exit 1; }

export RCLONE_CONFIG_TARGETS3_TYPE=""
export RCLONE_CONFIG_TARGETS3_PROVIDER=""
export RCLONE_CONFIG_TARGETS3_ENDPOINT=""
export RCLONE_CONFIG_TARGETS3_REGION=""
export RCLONE_CONFIG_TARGETS3_ACCESS_KEY_ID=""
export RCLONE_CONFIG_TARGETS3_SECRET_ACCESS_KEY=""