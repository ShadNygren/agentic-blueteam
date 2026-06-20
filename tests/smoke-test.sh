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
# installed via pipx (isolated venvs, PEP-668-safe) — hard requirements.
check "sigma (sigma-cli) present"  command -v sigma
check "vol (volatility3) present"  command -v vol

echo "[skills + reference libraries]"
check "detect skill present"  test -f /root/.claude/skills/detect/SKILL.md
check "respond skill present" test -f /root/.claude/skills/respond/SKILL.md
check "hunt skill present"    test -f /root/.claude/skills/hunt/SKILL.md
DET_REF=/root/.claude/skills/detect/references
RES_REF=/root/.claude/skills/respond/references
HUNT_REF=/root/.claude/skills/hunt/references
check "detect reference library present"  test -f "$DET_REF/00-detection-engineering-methodology.md"
check "detect reference library complete (5 files)" test "$(ls -1 "$DET_REF"/*.md 2>/dev/null | wc -l)" -ge 5
check "respond reference library present" test -f "$RES_REF/00-ir-methodology.md"
check "respond reference library complete (4 files)" test "$(ls -1 "$RES_REF"/*.md 2>/dev/null | wc -l)" -ge 4
check "hunt reference library present"    test -f "$HUNT_REF/00-threat-hunting-methodology.md"
check "hunt reference library complete (3 files)" test "$(ls -1 "$HUNT_REF"/*.md 2>/dev/null | wc -l)" -ge 3
# shared strategic-foundation doctrine
check "strategy doctrine doc present" test -f /opt/agentic-blueteam/docs/STRATEGY_OF_ADVERSARIAL_COEVOLUTION.md

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
