#! /usr/bin/env bash

set -o errexit
set -o nounset

function init() {
  mkdir -p ~/.m2
}

function reset_repo() {
  mvn dependency:purge-local-repository -DactTransitively=false -DreResolve=false 1>/dev/null
  if [ -d ~/.m2/repository ]; then
    du -skc ~/.m2/repository
  fi
}

function use_google() {
  cp google_settings.xml ~/.m2/settings.xml
}

function use_central() {
  rm -rf ~/.m2/settings.xml || true
}


function main() {

  reset_repo
  echo "default maven central"
  time mvn dependency:resolve 1>/dev/null
  echo "---"

  reset_repo
  echo "google mirror"
  use_google
  time mvn dependency:resolve 1>/dev/null
  echo "---"

  reset_repo
  echo "default maven central"
  time mvn dependency:resolve 1>/dev/null
  echo "---"

  reset_repo
  echo "google mirror"
  use_google
  time mvn dependency:resolve 1>/dev/null
  echo "---"

}

main $*
