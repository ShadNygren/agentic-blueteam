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

## Notification & reporting (know who/when before the incident)
Reporting obligations are **data- and jurisdiction-specific, with clocks** — work them out *in preparation*, not
during the fire:
- **HIPAA / PHI** → report to HHS (and affected individuals). **PCI** → card brands/acquirer. **GDPR** → the
  supervisory authority (often within **72 hours**). **State laws** → many require notifying the **state attorney
  general** above a resident-count threshold. **Contracts** may impose their own clocks.
- **Cloud/AI nuance:** if data spilled into a third-party/AI model, work out with legal whether it's spillage vs.
  a reportable breach, who you notify, and whether the provider can redact. **Who pays the fine** if a vendor's
  bug caused the breach is a *contractual* question — read the terms (often "you're responsible") and treat the
  residual as an accepted risk management decides on, not an assumption.
- Map each obligation to an owner (usually **GRC/legal** for notification; **SecOps/IT** for containment) so
  nobody assumes someone else sent the notice.

## Metrics (measure the response)
- **Dwell time** — initial compromise → detection (the number adversaries optimize to maximize; the program
  optimizes to minimize).
- **MTTD / MTTC / MTTR** — mean time to detect / contain / recover. Track across incidents to show improvement.
- **Detection source** — alert vs. hunt vs. user vs. third-party (third-party notification is a detection-program
  failure signal worth flagging).

## Lessons learned → stronger defense (close the loop)
Give **fair** feedback across **people, process, and technology** — honest about what fell short, but not
self-flagellating. **Celebrate what worked** (pat both your team and partner teams on the back — it builds the
culture that makes the next response better) *and* **name the missed opportunities** ("we burned hours on X that
didn't help," "this tool assumed access we didn't have," "we lost time waiting on ad-hoc approval").
- **A lesson with no action item is wasted.** Don't just file notes in SharePoint/Confluence — **develop a plan
  of action**, assign owners + dates, and track each item to completion. Lessons learned only matter if someone
  implements them.
- **Detection gaps → `detect` skill.** Every technique the adversary used that you **didn't detect** becomes a
  detection-engineering requirement and a row in the detection-gap matrix. Missing telemetry becomes a logging
  requirement.
- **Hunt leads → `hunt` skill.** Residual questions ("are other hosts affected the same way?") become hunt
  hypotheses.
- **Incident → problem handoff** — if a permanent fix is a multi-week effort or a vendor issue, move it to
  **problem management** (PM, timeline, project, or a documented mitigation procedure) rather than leaving an
  open incident (see `00-ir-methodology.md`).
- **Playbooks & authorization** — update IR playbooks, contact lists, and the `AUTHORIZED_RESPONSE.txt` patterns
  based on what worked (and what was slow because it needed ad-hoc approval).
- **Include all relevant parties — internal *and* external.** Loop in IR retainers/MSSPs, vendors, and partners
  whose systems or actions were part of the incident or the response; they share in the lessons.
- **Hardening** — the root cause fix (patch/config/credential rotation) should be tracked to completion, not just
  recommended.
- **Document for maturity, compliance, and correlation** — SOC 2 and others require documented IR process +
  records; historical incident data also lets you correlate future activity (e.g. re-link to a prior
  not-fully-eradicated nation-state intrusion) and meet evidence-retention obligations.
- **Blameless review** — focus on systems and process, not individuals; that's what gets honest input and real
  improvement.

## Maturity, roles (RACI) & evidence retention
- **Maturity is the trajectory.** The lowest level is heroics ("put on your cape and work miracles from memory");
  the goal is **automated/repeatable** — documented runbooks anyone can pick up and run. Use lessons learned to
  climb: add logging/SIEM, a documented process, then automation. Rank where you are and where you're going.
- **Clarify roles with a RACI** for the IR process (who's Responsible/Accountable/Consulted/Informed for
  detection, containment, notification, legal review, comms), **signed off** so there's no confusion mid-incident.
- **Annual (at least) IR exercises** — required by many regimes; run them **per division/scenario** (SOC, client
  services, cloud, AI). Driving an exercise off a *current, real-world* incident motivates participation and
  surfaces gaps (e.g. an AI/Copilot data-leak scenario).
- **Evidence-retention policy** — define **how long** evidence is kept (longer if prosecution is possible),
  **where** (secure, access-controlled storage — which has a real cost), and per legal/contract/IR-retainer
  terms. Historical incident data also enables future correlation.

## Honesty & confidentiality
Report what the evidence supports, with confidence levels; mark unknowns as unknown; don't over- or under-state
impact. Treat the report + evidence as highly sensitive (it maps how the org was breached); deliver over a
secure channel; retain/destroy per legal + retention terms; never pair the client with specifics in any
non-deliverable/public material.
