#!/bin/bash

err() {
  echo "E: $*" >>/dev/stderr
}

die() {
  err "$*"
  exit 1
}

cpu_count() {
  COUNT=$(python -c "import psutil; print(psutil.cpu_count(logical=False))")
  RET=$?
  if [ "${CPUCOUNT_RECURSIVE}" -eq 0 ]; then
    if [ "${RET}" -ne 0 ]; then
      sudo apt -y install python3-psutil python-is-python3 > /dev/null 2>/dev/null
      CPUCOUNT_RECURSIVE=1
      cpu_count
      return
    fi
  else
    if [ "${RET}" -ne 0 ]; then
      die "GETTING CPU COUNT FAILED."
    fi
  fi
  echo "${COUNT}"
}

CPUCOUNT_RECURSIVE=0