#!/usr/bin/env bash
# ---------------------------------------------------------------------
# check the status of publish workflows ...

set -o errexit
set -o nounset
set -o pipefail

source "${HOME}/bin/utils/log.sh"

OWNER="eswat2"
REPOS=(
  "eswat2"
  "eswat42"
  "proto-tailwindcss-clrs"
  "proto-tailwindcss-pxls"
  "analog-clock-components"
  "funnel-gfx-wc"
  "proto-autos-wc"
  "proto-icons-wc"
  "proto-ikon-loader"
  "proto-ikons-wc"
  "proto-logo-wc"
  "proto-sudoku-wc"
  "proto-tinker-wc"
)

main() {
  log::section "Publish Workflows"
  log::blank
  printf "${TERM__BOLD}%25s    %-10s %s${TERM__RESET}\n" "REPO" "RESULT" "TITLE"
  # printf '%s%s\n' "${TERM__HRULE}" "${TERM__HRULE:0:23}"

  for repo in "${REPOS[@]}"; do
    raw=$(gh run list \
      --repo "$OWNER/$repo" \
      --limit 1 \
      --json status,conclusion,displayTitle \
      --jq '.[0] | "\(.conclusion)\t\(.status)\t\(.displayTitle)"' \
      2>/dev/null)

    if [[ -z "$raw" ]]; then
      printf "%-35s  ${TERM__DIM}no runs found${TERM__RESET}\n" "$repo"
      continue
    fi

    IFS=$'\t' read -r conclusion status title <<< "$raw"

    if [[ ${#title} -gt 35 ]]; then
      title_short="${title:0:31}..."
    else
      title_short="$title"
    fi

    if [[ "$conclusion" == "success" ]]; then
      icon="${TERM__OK}"; color="${TERM__GREEN}"; label="success"
    elif [[ "$conclusion" == "failure" ]]; then
      icon="${TERM__NOT_ICON}"; color="${TERM__RED}"; label="failure"
    elif [[ "$status" == "in_progress" ]]; then
      icon="${TERM__WARN_ICON}"; color="${TERM__YELLOW}"; label="running"
    elif [[ "$status" == "queued" ]]; then
      icon="${TERM__WARN_ICON}"; color="${TERM__YELLOW}"; label="queued"
    else
      icon=" "; color="${TERM__DIM}"; label="${conclusion:-$status}"
    fi

    printf "%25s  %s ${color}%-10s${TERM__RESET} ${TERM__BLUE}%s${TERM__RESET}\n" \
      "$repo" "$icon" "$label" "$title_short"
  done

  log::blank
}

main "$@"
