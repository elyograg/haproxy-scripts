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

CPUCOUNT_RECURSIVE=0
make_cpu_count() {
  local COUNT;
  local MAKE_COUNT;
  COUNT=$(python -c "import psutil; print(psutil.cpu_count(logical=False))")
  RET="$?"
  if [ "${CPUCOUNT_RECURSIVE}" -eq 0 ]; then
    if [ "${RET}" -ne 0 ]; then
      sudo -E apt -y install python3-psutil python-is-python3 > /dev/null 2>/dev/null
      CPUCOUNT_RECURSIVE=1
      make_cpu_count
      RET="$?"
      return "${RET}"
    fi
  else
    if [ "${RET}" -ne 0 ]; then
      die "GETTING CPU COUNT FAILED."
    fi
  fi

  ((MAKE_COUNT=COUNT/3))
  if [ "${MAKE_COUNT}" -lt 2 ]; then
    MAKE_COUNT=2
  fi

  echo "${MAKE_COUNT}"
  return "${RET}"
}
