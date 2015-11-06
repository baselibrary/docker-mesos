#!/bin/bash

#enable job control in script
set -e -m

#####   variables  #####

# add command if needed
if [ "${1:0:1}" = '-' ]; then
  set -- mesos "$@"
fi

#run command in background
if [ "$1" = 'mesos' ]; then
  ##### pre scripts  #####
  echo "========================================================================"
  echo "initialize:"
  echo "========================================================================"
  mkdir -p /var/lib/mesos
  
  ##### run scripts  #####
  echo "========================================================================"
  echo "startup:"
  echo "========================================================================"
  exec "$@" &

  ##### post scripts #####
  echo "========================================================================"
  echo "configure:"
  echo "========================================================================"
  
  #bring command to foreground
  fg
else
  exec "$@"
fi
