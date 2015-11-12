#! env bash

set -o errexit
set -o nounset

function init() {
  mkdir -p ~/.m2
}

function reset_repo() {
  rm -rf ~/.m2/repository || true
}

function use_google() {
  cp google_settings.xml ~/.m2/settings.xml
}

function use_central() {
  rm -rf ~/.m2/settings.xml || true
}


function main() {
  time mvn dependency:resolve
  reset_repo
  use_google
  time mvn dependency:resolve
}

main $*
