#!/usr/bin/env bash

check_version() {
  v="${1}"
  [ -n "$(kops --version | grep -E "^Kops v${v}(-dev)?$")" ]
}

cleanup() {
  rm -rf ./versions
  rm -rf ./.kops-version
  rm -rf ./min_required.kops
}
