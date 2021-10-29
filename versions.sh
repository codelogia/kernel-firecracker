#!/bin/bash

set -o errexit -o nounset -o pipefail

output="versions.txt"
owner="torvalds"
repo="linux"
per_page=100
page=1

true > "${output}"

while true; do
  url="https://api.github.com/repos/${owner}/${repo}/tags?per_page=${per_page}&page=${page}"
  res=$(curl "${url}" | jq -r '.[].name | select(. | test("^v[0-9].[0-9]+$"))')
  if [ -z "${res}" ]; then
    break
  fi
  echo "${res}" >> "${output}"
  page=$((page + 1))
done
