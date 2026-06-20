# Purple Teaming & Detection Validation

A detection you haven't *triggered* is a hypothesis, not a control. Validation closes the loop with the
offensive side: run the technique, confirm the detection fires (or find the gap), tune, repeat. This is where
**Agentic Blueteam meets Agentic Redteam.**

## The adversary-emulation lifecycle (what red is running)
Red runs a cyclic loop you should understand so you can plug into it:
**choose a technique → choose a test → execute the procedure → analyze detection of it → improve defenses →
repeat.** Red owns the first three; **blue owns analyze + improve.** Crucially, emulation tests the **Defenders,
not just the defenses** — your **readiness and resilience**: did the SOC *detect* it, *respond*, and **escalate
in good time** (does the analyst reach the CISO when they should)? It's holistic — people, **process
(communication/escalation)**, and technology. So measure more than "did a rule fire": measure detection,
response, *and* the escalation/decision path.

## The red/blue loop
ATT&CK is the shared language, so the two sides line up technique-for-technique:
1. **Red emulates** (Agentic Redteam) a threat actor and produces an **ATT&CK-mapped attack narrative + an
   ATT&CK Navigator layer + a detection-gap matrix** (what they did, what was logged/alerted/missed). Red picks
   the actor by your **industry + geography** — so prioritize your detection coverage for those same actors.
2. **Blue consumes** those mapped techniques: for each one, check **did we have the data? did a detection fire?**
   Build/tune detections for the misses.
3. **Re-run** — the next emulation verifies the new detections fire and measures improvement (MTTD down,
   coverage up). Track Navigator layers quarter-over-quarter as a **report card** of whether the blue team is
   improving.

**Purple-team modes:** *live* (run a technique, watch telemetry, tune the detection in real time — fastest
detection-engineering loop) or *debrief* (red runs covertly, then both sides walk the kill chain against the
logs). Either way the output is **new/tuned detections.**

## Atomic Red Team — discrete, repeatable test cases
[Atomic Red Team] is a library of small, single-technique tests mapped to ATT&CK. Use it to **trigger a specific
technique on demand** and confirm your detection fires — without a full red-team engagement. Each "atomic" is a
reproducible test case to attach to the corresponding detection rule (`ref 01`).

## The detection-gap matrix (defender's view)
The mirror of the red team's matrix — one row per technique you care about:

| ATT&CK ID | Technique | Data source present? | Detection exists? | Fired in test? | Gap / action |
|---|---|---|---|---|---|
| T1003.001 | LSASS dumping | yes (Sysmon EID 10) | yes | yes | tune FPs; cut TTD |
| T1071.004 | DNS C2 | partial (no DNS logs) | no | n/a | **collect DNS logs first**, then write rule |

- Distinguish the failure modes — they need different fixes: **no data collected** (fix telemetry, `ref 02`) vs
  **data but no rule** (write one, `ref 01`) vs **rule exists but didn't fire** (debug/tune).
- **Credit what worked**, not just gaps — confirms which detections are pulling their weight.
- **Never mark "detected" without seeing the alert in real telemetry** during the test. No fabrication —
  validation results come from actually triggering the technique and observing the data.

## Validating against an Agentic Redteam engagement
- Import the red team's **ATT&CK Navigator layer** (their executed techniques) and overlay your detection
  coverage → the combined heat-map is your prioritized detection backlog.
- For each technique the red side executed **undetected**, run the matching Atomic test in a safe environment,
  confirm the gap, then engineer + test the detection and re-validate.
- Feed measured results (MTTD, coverage delta, new rules) back so each round of the loop is evidenced.

## Metrics
Coverage (techniques detected / total in the threat model), MTTD in validation, FP rate per new rule, and the
**gap-closure rate** across loop iterations — the real proof the program is improving.
