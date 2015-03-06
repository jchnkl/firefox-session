#!/bin/bash

# Path to the base profile
# PROFILE_BASE=~/.mozilla/firefox/base

# Path where new profiles should be stored
# PROFILE_DIRECTORY=~/.mozilla/firefox

if [ -z ${PROFILE_BASE} ]; then
  echo "Please set PROFILE_BASE"
  exit 1
fi

if [ ! -d ${PROFILE_BASE} ]; then
  echo "${PROFILE_BASE} does not exist"
  exit 1
fi

if [ -z ${PROFILE_DIRECTORY} ]; then
  echo "Please set PROFILE_DIRECTORY"
  exit 1
fi

if [ ! -d ${PROFILE_DIRECTORY} ]; then
  echo "${PROFILE_DIRECTORY} does not exist"
  exit 1
fi

if [ -z "$1" ]; then
  echo "Usage: $0 <profile name>"
  exit 1
fi

if [ -z ${UID} ]; then
  echo "UID not set!"
  exit 1
fi

if [ ! -x "$(which unionfs)" ]; then
  echo "Could not found unionfs executable"
  exit 1
fi

if [ ! -x "$(which fusermount)" ]; then
  echo "Could not found fusermount executable"
  exit 1
fi

PROFILE="$1"

PROFILE_MNT=/tmp/firefox-session/${UID}/${PROFILE}

mkdir -p ${PROFILE_MNT}

PROFILE_STORE=${PROFILE_DIRECTORY}/${PROFILE}

mkdir -p ${PROFILE_STORE}

unionfs -o cow ${PROFILE_STORE}=RW:${PROFILE_BASE}=RO ${PROFILE_MNT}

trap "fusermount -u ${PROFILE_MNT}" EXIT

firefox -new-instance -profile ${PROFILE_MNT}
