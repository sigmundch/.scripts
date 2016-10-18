#!/bin/bash

if [[ "$DART_SDK_HOME" == "" ]]; then
  echo "Please define DART_SDK_HOME to point to your SDK installation dir"
  exit 1
fi

if [[ `which gsutil` == "" ]]; then
  echo "Make sure you have installed gsutil and include it in your path"
  exit 1
fi

# TODO add also support for:
# https://storage.googleapis.com/dart-archive/channels/stable/release/latest/dartium/dartium-linux-x64-release.zip
SDK_DIR=$(dirname $DART_SDK_HOME)
BASE_URI=gs://dart-archive/channels
DEV_URI=$BASE_URI/dev/raw
STABLE_URI=$BASE_URI/stable/raw
BE_URI=$BASE_URI/be/raw

location=$DEV_URI
location_name="dev"
version="latest"
desired=""
current=""
#zipname="darteditor-linux-x64.zip"
#zipname="dartsdk-linux-ia32-release.zip"
zipname="dartsdk-linux-x64-release.zip"
#zipname="darteditor-linux-ia32.zip"
case $1 in
  "dev")
    location=$DEV_URI
    location_name="dev"
    ;;
  "be")
    location=$BE_URI
    location_name="be"
    ;;
  "stable")
    location=$STABLE_URI
    location_name="stable"
    ;;
  "be-version")
    location=$BE_URI
    version=$2
    location_name="be"
    ;;
  "dev-version")
    location=$DEV_URI
    version=$2
    location_name="dev"
    ;;
  "stable-version")
    location=$STABLE_URI
    version=$2
    location_name="stable"
    ;;
  *)
    ;;
esac

i=0;
function step {
  i=$(($i + 1))
  echo -e "[32m$i. $1[0m"
}

function info {
  echo -e "[33m   $1[0m"
}

# needs 'sudo apt-get install gawk'
function read_version {
  awk '/"revision"/ { print gensub(/.*: "(.*)",?/, "\\1", 1) }' $1
}

function compare {
  gsutil cp $location/$version/VERSION .
  desired=$(read_version VERSION)
  current=$(read_version LAST_VERSION)
  info "Current version:     $current"
  info "Version to retrieve: $desired"
  if [[ $desired != $current ]]; then
    return 1
  fi
  step "already up to date. "
  rm VERSION
}

function update {
  if [[ -f "$desired.zip" ]]; then
    step "cached version found"
    cp $desired.zip $zipname
    cp VERSION.$desired VERSION
  else
    step "no cached version found: downloading..."
    gsutil cp $location/$version/sdk/$zipname .
  fi

  if [[ -f $zipname ]]; then
    step "updating tree."
    rm -r dart-sdk/
    unzip $zipname >> $SDK_DIR/log.txt
    cp VERSION VERSION.$desired
    mv VERSION LAST_VERSION
    mv $zipname $desired.zip

    #step "creating dartium symlink"
    #ln -s $SDK_DIR/dart/chromium/chrome $SDK_DIR/dart/dart-sdk/bin/dartium
  else
    step "error in download, stop"
  fi
}

pushd $SDK_DIR >> $SDK_DIR/log.txt
step "compare versions"
compare || update
step "done -- current version: $desired // $(cat LAST_VERSION | xargs echo)"
popd >> $SDK_DIR/log.txt
