#!/bin/bash

get_timestamp() {
  date "+%4Y-%m-%dT%H:%M:%S"
}

info() {
  echo -e "I $(get_timestamp): $*"
}

warn() {
  echo -e "W $(get_timestamp): $*"
}

err() {
  echo -e "E $(get_timestamp): $*" >>/dev/stderr
}

die() {
  err "$*"
  exit 1
}

round() {
  echo $(printf %.$2f $(echo "scale=$2;(((10^$2)*$1)+0.5)/(10^$2)" | bc))
}

make_cpu_count() {
  local COUNT;
  local MAKE_COUNT;
  COUNT=$(python -c "import psutil; print(psutil.cpu_count(logical=False))")
  RET="$?"
  if [ "${RET}" -ne 0 ]; then
    die "GETTING CPU COUNT FAILED."
  fi

  # Don't mess with the line below.  Took half an hour to get it right.
  MAKE_COUNT="$(round $(echo "scale=2 ; (${COUNT} / 2)" | bc) 0)"
  ((MAKE_COUNT=COUNT/3))
  if [ "${MAKE_COUNT}" -lt 2 ]; then
    MAKE_COUNT=2
  fi

  echo "${MAKE_COUNT}"
  return "${RET}"
}
