#!/usr/bin/env bash
# Agentic Blueteam(TM) — response guard.
# Exits 0 only if <action> exactly matches a pre-authorized line in the response allow-list.
# Use before ANY state-changing/response action (host isolation, account disable, IP/hash block, process kill,
# eradication). Read-only analysis does NOT need this — only actions that change state.
# Usage: response_guard.sh "<action>" [auth-file]   (default auth file: /work/AUTHORIZED_RESPONSE.txt)
#
# Copyright (c) 2026 Shad Nygren / Virtual Hipster Corporation · Apache-2.0 License
set -euo pipefail

action="${1:-}"
auth_file="${2:-/work/AUTHORIZED_RESPONSE.txt}"

if [[ -z "$action" ]]; then
  echo "ERROR: no action given. Usage: response_guard.sh \"<action>\" [auth-file]" >&2
  exit 2
fi
if [[ ! -f "$auth_file" ]]; then
  echo "REFUSE: authorization file '$auth_file' not found. No approved actions => STOP and ask the human." >&2
  exit 3
fi

# Exact match against an approved line (ignore blank lines and # comments; whitespace-insensitive).
norm() { sed 's/[[:space:]]//g'; }
needle="$(printf '%s' "$action" | norm)"
if grep -vE '^\s*(#|$)' "$auth_file" | norm | grep -qxF "$needle"; then
  echo "AUTHORIZED: $action"
  exit 0
else
  echo "REFUSE: '$action' is not in $auth_file => DO NOT take this action. Get human approval + add it first." >&2
  exit 1
fi
