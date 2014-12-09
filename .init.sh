#!/bin/bash

set -e

BUNDLE_PATH=/tmp/.bundle-$(basename $(pwd))
export BUNDLE_JOBS="${BUNDLE_JOBS:=4}"
if [ ! -z "$SNAP_CI" ]
then
  BUNDLE_PATH=$HOME/.bundle
fi

mkdir -p $BUNDLE_PATH
rm -rf vendor/bundle
ln -sf $BUNDLE_PATH vendor/bundle

export NOKOGIRI_USE_SYSTEM_LIBRARIES=1

while read line; do
  [[ -n ${SNAP_CI} || -n ${GO_SERVER_URL} ]] || echo -ne "Doing $((C++)) things...\r"
done < <(bundle check || bundle install --local --path vendor/bundle --clean)

echo
echo "Done!"
