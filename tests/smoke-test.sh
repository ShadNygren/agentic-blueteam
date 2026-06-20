#!/usr/bin/env bash
# Agentic Blueteam(TM) — smoke test.
# Verifies the built image has the core toolchain + skills + response guard wired up. Run inside the container.
# Copyright (c) 2026 Shad Nygren / Virtual Hipster Corporation · Apache-2.0 License
set -uo pipefail

pass=0; fail=0
check() { # check <label> <command...>
  local label="$1"; shift
  if "$@" >/dev/null 2>&1; then echo "  ok   $label"; pass=$((pass+1));
  else echo "  FAIL $label"; fail=$((fail+1)); fi
}

echo "== Agentic Blueteam smoke test =="

echo "[core toolchain]"
check "claude (Claude Code) on PATH" command -v claude
check "node present"                 command -v node
check "python3 present"              command -v python3
check "jq present"                   command -v jq
check "yara present"                 command -v yara

echo "[defensive tools]"
# pip-installed (best-effort in the Dockerfile); non-fatal if absent.
command -v sigma >/dev/null 2>&1 && echo "  ok   sigma (sigma-cli) present" || echo "  warn sigma absent (pip best-effort)"
command -v vol   >/dev/null 2>&1 && echo "  ok   vol (volatility3) present" || echo "  warn volatility3 absent (pip best-effort)"

echo "[skills + reference libraries]"
check "detect skill present"  test -f /root/.claude/skills/detect/SKILL.md
check "respond skill present" test -f /root/.claude/skills/respond/SKILL.md
DET_REF=/root/.claude/skills/detect/references
RES_REF=/root/.claude/skills/respond/references
check "detect reference library present"  test -f "$DET_REF/00-detection-engineering-methodology.md"
check "detect reference library complete (4 files)" test "$(ls -1 "$DET_REF"/*.md 2>/dev/null | wc -l)" -ge 4
check "respond reference library present" test -f "$RES_REF/00-ir-methodology.md"
check "respond reference library complete (3 files)" test "$(ls -1 "$RES_REF"/*.md 2>/dev/null | wc -l)" -ge 3

echo "[response guard]"
# both skills carry the guard; it must REFUSE a state-changing action when no authorization file exists.
for RG in /root/.claude/skills/detect/scripts/response_guard.sh /root/.claude/skills/respond/scripts/response_guard.sh; do
  skill=$(echo "$RG" | sed 's#.*/skills/\([^/]*\)/.*#\1#')
  check "$skill response_guard.sh present" test -x "$RG"
  if "$RG" "isolate-host: WKSTN-0001" /nonexistent/AUTHORIZED_RESPONSE.txt >/dev/null 2>&1; then
    echo "  FAIL $skill response guard allowed an action with no authorization file"; fail=$((fail+1))
  else
    echo "  ok   $skill response guard refuses with no authorization file"; pass=$((pass+1))
  fi
done

echo "== $pass passed, $fail failed =="
[ "$fail" -eq 0 ]
