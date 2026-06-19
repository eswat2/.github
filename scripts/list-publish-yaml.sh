#!/usr/bin/env bash
# ---------------------------------------------------------------------
# check for publish workflows ...

set -o errexit
set -o nounset
set -o pipefail

source $HOME/bin/utils/log.sh
CACHE=${HOME}/.pub-cache.json

LIST=false

parse_arguments() {
  if [[ $# -gt 0 ]]; then
    while [[ $# -gt 0 ]]; do
      case $1 in
      --list | 42)
        log::output "--list | 42" green
        LIST=true
        shift
        ;;
      *)
        log::output "-- INVALID option... [ $1 ]" red
        exit
        ;;
      esac
    done
  fi
}

main() {
  parse_arguments "$@"

  log::section "publish.yml"

  cd $HOME/github

  PRIORITY="eswat2 eswat42 proto-tailwindcss-clrs proto-tailwindcss-pxls"
  REPOS=$(ls */*/.github/workflows/publish.yml | cut -d "/" -f 2 | sed 's/loader-wc/loader/g')

  echo ${PRIORITY} | tr ' ' '\n' > .tmp
  echo ${REPOS} | tr ' ' '\n' >> .tmp
  DATA=($(cat .tmp | awk '!x[$0]++'))

  if [ ${LIST} == true ]
  then
    for repo in "${DATA[@]}"
    do
      log::key_value ${repo} ": " true
    done
  else
    log::output "cache -- ${CACHE}" blue
  fi

  jo -a ${DATA[*]} > ${CACHE}
}

main "$@"
