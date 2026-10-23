#!/usr/bin/env bash

set -e
export TZ="Asia/Yangon"

YEAR=$(date +%Y)
MONTH=$(date +%m)
TODAY=$((10#$(date +%d)))

printf '\n'
printf '  ╭────────────────────────────────────────╮\n'
printf '  │          ☠  G I T   D I R T Y  ☠       │\n'
printf '  │            forge your timeline          │\n'
printf '  ╰────────────────────────────────────────╯\n\n'

printf '  Current date: %s-%s-%02d MMT\n' "$YEAR" "$MONTH" "$TODAY"
printf '  Available days: 1 - %d\n\n' "$TODAY"

read -rp "  ✧ Day: " DAY

if ! [[ "$DAY" =~ ^[0-9]{1,2}$ ]]; then
    printf '\n  ✗ Invalid day.\n\n'
    exit 1
fi

DAY=$((10#$DAY))

if (( DAY < 1 || DAY > TODAY )); then
    printf '\n  ✗ Day must be between 1 and %d.\n\n' "$TODAY"
    exit 1
fi

read -rp "  ✧ Commit message: " MESSAGE

if [[ -z "${MESSAGE//[[:space:]]/}" ]]; then
    printf '\n  ✗ Commit message cannot be empty.\n\n'
    exit 1
fi

# Use the selected day and current Myanmar time.
COMMIT_DATE="$(printf '%s-%s-%02d %s' \
    "$YEAR" \
    "$MONTH" \
    "$DAY" \
    "$(date '+%H:%M:%S')")"

GIT_DATE="$(date -d "$COMMIT_DATE" '+%Y-%m-%d %H:%M:%S %z')"

printf '\n'
printf '  ───────── ☠ REVIEW YOUR CRIME ☠ ─────────\n'
printf '  Day:     %02d\n' "$DAY"
printf '  Message: %s\n' "$MESSAGE"
printf '  Date:    %s MMT\n' "$COMMIT_DATE"
printf '  ─────────────────────────────────────────\n\n'

read -rp "  Proceed? [y/N]: " CONFIRM

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    printf '\n  ✗ Crime cancelled.\n\n'
    exit 0
fi

export GIT_AUTHOR_DATE="$GIT_DATE"
export GIT_COMMITTER_DATE="$GIT_DATE"

git add .
git commit -m "Day $(printf '%02d' "$DAY"): $MESSAGE"

printf '\n  ☠ Commit forged. The timeline has been edited.\n\n'
