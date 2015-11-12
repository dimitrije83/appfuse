#! /usr/bin/env bash

set -o errexit
set -o nounset

BASE_DIR=$(readlink -f `dirname $0`)

# number of times to repeat download from each repo
REPEAT_DOWNLOADS=${REPEAT_DOWNLOADS:="2"} 

function init() {
  mkdir -p ~/.m2
}

function download() {
  mvn dependency:resolve 1>/dev/null
}

function reset_repo() {
  if [ -d ~/.m2/repository ]; then
    rm -rf ~/.m2/repository
  fi
}

function use_repo() {
  local repo=$1
  if [ ${repo} = "google" ]; then
    cp ${BASE_DIR}/google_settings.xml ~/.m2/settings.xml
    echo -n "google mirror: "
  else 
    rm -rf ~/.m2/settings.xml || true
    echo -n "default maven central: "
  fi
}

function time_download() {
  local start=$(date +%s)
  download
  local end=$(date +%s)
  echo -n "$(( $end - $start ))s "
}


function main() {

  init

  use_repo central
  i=0
  while [ $i -lt ${REPEAT_DOWNLOADS} ]; do
    reset_repo
    time_download
    i=$(($i + 1))
  done
  echo ""

  use_repo google
  i=0
  while [ $i -lt ${REPEAT_DOWNLOADS} ]; do
    reset_repo
    time_download
    i=$(( $i + 1 ))
  done
  echo ""

  echo -n "download (w/ cache): "
  time_download
  echo

}

main $*
