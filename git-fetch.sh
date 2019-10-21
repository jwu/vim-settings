#!/bin/bash

export ORIGINAL_PATH=`pwd`

for name in *
do
  if [ -d "${name}" ]; then
    cd ${name}

    echo ------------------------------------------
    echo ${name}
    echo ------------------------------------------

    git fetch origin

    echo

    cd ${ORIGINAL_PATH}
  fi
done
