#!/bin/bash

get_timestamp() {
  date "+%4Y-%m-%dT%H:%M:%S"
}

log_info() {
  echo -e "I $(get_timestamp): $*"
}

log_warn() {
  echo -e "W $(get_timestamp): $*"
}

log_err() {
  echo -e "E $(get_timestamp): $*" >>/dev/stderr
}

die() {
  log_err "$*"
  exit 1
}

round() {
  printf "%.$2f" "$(echo "scale=$2;(((10^$2)*$1)+0.5)/(10^$2)" | bc)"
}

make_cpu_count() {
local RET;
RET=0
if [ -z "${MAKE_COUNT}" ]; then
    local COUNT;
    local MAKE_COUNT;
    COUNT=$(python -c "import psutil; print(psutil.cpu_count(logical=False))")
    RET="$?"
    if [ "${RET}" -ne 0 ]; then
      die "GETTING CPU COUNT FAILED."
    fi

    # Don't mess with the line below.  Took FOREVER to get it right.
    MAKE_COUNT="$(round "$(echo "scale=2 ; (${COUNT} / 2)" | bc)" 0)"
    if [ "${MAKE_COUNT}" -lt 3 ]; then
      MAKE_COUNT=3
    fi
  fi

  echo "${MAKE_COUNT}"
  return "${RET}"
}

fetch_from_git() {
  REPO_NAME="$1"
  shift
  echo "Fetching ${REPO_NAME} from git"
  git fetch --all 2>&1
  RET="$?"
  if [ "${RET}" -ne 0 ]; then
    die "Error fetching, aborting"
  else
    git pull --rebase 2>&1
    RET="$?"
    if [ "${RET}" -ne 0 ]; then
      die "Error pulling, aborting"
    fi
  fi
}
