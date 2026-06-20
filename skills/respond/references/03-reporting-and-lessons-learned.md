# Reporting & Lessons Learned

The incident isn't closed when the threat is gone — it's closed when you've produced a **defensible record** and
turned the incident into **stronger defenses**. This is where the blue/blue loop runs: IR findings become new
detections and playbooks.

## The incident report
Build it from `/work/INCIDENT.md` (kept current throughout). Audiences: executives (summary), technical staff
(detail), and possibly legal/regulators/auditors — write so each can act.
1. **Executive summary** — what happened, business impact, current status, and the few things to fix. Plain
   language; a leader reads only this.
2. **Timeline** — the ATT&CK-mapped sequence (initial access → actions on objective → containment), UTC
   timestamps, each entry traceable to evidence.
3. **Root cause** — how they got in and why it worked (the *initial access* + the gap that allowed escalation/
   spread). If unknown, say so with confidence levels — don't invent one.
4. **Scope & impact** — affected systems/accounts/data; data exposed/exfiltrated (evidence-based, not assumed);
   business disruption.
5. **Actions taken** — containment / eradication / recovery, **each tied to its approval** (who authorized it,
   when) and its entry in `AUTHORIZED_RESPONSE.txt`.
6. **IOCs & ATT&CK mapping** — indicators (with confidence) and the technique list (hand to `detect`).
7. **Recommendations** — prioritized: detection gaps, logging gaps, hardening, process fixes, training.
8. **Regulatory** — breach-notification obligations and whether/when they were met (with legal — see `ref 00`).

## Metrics (measure the response)
- **Dwell time** — initial compromise → detection (the number adversaries optimize to maximize; the program
  optimizes to minimize).
- **MTTD / MTTC / MTTR** — mean time to detect / contain / recover. Track across incidents to show improvement.
- **Detection source** — alert vs. hunt vs. user vs. third-party (third-party notification is a detection-program
  failure signal worth flagging).

## Lessons learned → stronger defense (close the loop)
- **Detection gaps → `detect` skill.** Every technique the adversary used that you **didn't detect** becomes a
  detection-engineering requirement and a row in the detection-gap matrix. Missing telemetry becomes a logging
  requirement.
- **Hunt leads → `hunt` skill.** Residual questions ("are other hosts affected the same way?") become hunt
  hypotheses.
- **Playbooks & authorization** — update IR playbooks, contact lists, and the `AUTHORIZED_RESPONSE.txt` patterns
  based on what worked (and what was slow because it needed ad-hoc approval).
- **Hardening** — the root cause fix (patch/config/credential rotation) should be tracked to completion, not just
  recommended.
- **Blameless review** — focus on systems and process, not individuals; that's what gets honest input and real
  improvement.

## Honesty & confidentiality
Report what the evidence supports, with confidence levels; mark unknowns as unknown; don't over- or under-state
impact. Treat the report + evidence as highly sensitive (it maps how the org was breached); deliver over a
secure channel; retain/destroy per legal + retention terms; never pair the client with specifics in any
non-deliverable/public material.
