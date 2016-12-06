#!/usr/bin/env bash

#
# Given a command line, finds the number of arguments meant for the script
#
# This means the number of arguments before the double dash.
#
function n_args() {
  n=0

  for arg in "$@"
  do
    if [[ "$arg" == "--" ]]
    then
      break
    else
      n=$((n + 1))
    fi
  done

  echo $n
}

#
# Runs a command in a quiet manner
#
function quiet() {
  err=$("$@" 2>&1)

  if [[ "$?" != "0" ]]
  then
    echo -e "*** Error: \n$err"
    exit 1
  fi
}

#
# Runs a command
#
function run() {
  echo "running '$*'..."

  quiet "$@"
}
