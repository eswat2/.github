#!/usr/bin/env bash
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

log::section "Publish Runs"
printf '\n'
printf "${TERM__BOLD}%-35s  %-11s %s${TERM__RESET}\n" "REPO" "RESULT" "TITLE"
printf '%s%s\n' "${TERM__HRULE}" "${TERM__HRULE:0:28}"

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

  if [[ ${#title} -gt 25 ]]; then
    title_short="${title:0:25}..."
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

  printf "%-35s  %s ${color}%-10s${TERM__RESET} %s\n" \
    "$repo" "$icon" "$label" "$title_short"
done

printf '\n'
