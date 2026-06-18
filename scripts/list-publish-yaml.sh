#!/usr/bin/env bash
# ---------------------------------------------------------------------
# check for publish workflows ...

set -o errexit
set -o nounset
set -o pipefail

source $HOME/bin/utils/log.sh
CACHE=${HOME}/.pub-cache.json

main() {
  log::section "publish.yml"

  cd $HOME/github

  PRIORITY="eswat2 eswat42 proto-tailwindcss-clrs proto-tailwindcss-pxls"
  REPOS=$(ls */*/.github/workflows/publish.yml | cut -d "/" -f 2 | sed 's/loader-wc/loader/g')

  echo ${PRIORITY} | tr ' ' '\n' > .tmp
  echo ${REPOS} | tr ' ' '\n' >> .tmp
  DATA=($(cat .tmp | awk '!x[$0]++'))

  for repo in "${DATA[@]}"
  do
    log::key_value ${repo} ": " true
  done

  jo -a ${DATA[*]} > ${CACHE}
}

main "$@"
