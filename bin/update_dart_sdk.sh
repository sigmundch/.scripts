#!/bin/bash
SDK_DIR=$(dirname $DART_EDITOR_HOME)

if [[ "$SDK_DIR" != "$PWD" ]]; then
  echo "Run only from your SDK installation dir: $SDK_DIR"
  exit 1
fi


BASE_URI=http://gsdview.appspot.com/dart-archive/channels
DEV_URI=$BASE_URI/dev/raw
STABLE_URI=$BASE_URI/stable/raw
BE_URI=$BASE_URI/be/raw

location=$DEV_URI
location_name="dev"
version="latest"
desired=""
current=""
#zipname="darteditor-linux-x64.zip"
zipname="darteditor-linux-ia32.zip"
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
  awk '/"revision"/ { print gensub(/.*: "(.*)",/, "\\1", 1) }' $1
}

function compare {
  wget $location/$version/VERSION
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
    wget $location/$version/editor/$zipname
  fi

  if [[ -f $zipname ]]; then
    step "updating tree."
    rm -r dart/
    unzip $zipname >> $SDK_DIR/log.txt
    cp VERSION VERSION.$desired
    mv VERSION LAST_VERSION
    mv $zipname $desired.zip

    step "creating dartium symlink"
    ln -s $SDK_DIR/dart/chromium/chrome $SDK_DIR/dart/dart-sdk/bin/dartium
  else
    step "error in download, stop"
  fi
}

pushd $SDK_DIR >> $SDK_DIR/log.txt
step "compare versions"
compare || update
step "done -- current version: $desired // $(cat LAST_VERSION | xargs echo)"
popd >> $SDK_DIR/log.txt
