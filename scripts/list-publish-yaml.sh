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
  REPOS=$(ls */*/.github/workflows/publish.yml | cut -d "/" -f 2 | sed 's/loader-wc/loader/g')

  for repo in ${REPOS}
  do
    log::key_value ${repo} ": " true
  done

  jo -a ${REPOS} > ${CACHE}
}

main "$@"
