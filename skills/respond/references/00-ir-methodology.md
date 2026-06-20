# Incident Response — Methodology

Incident response is a disciplined lifecycle, not heroics. Follow a recognized framework so the response is
repeatable, defensible, and preserves evidence while limiting damage.

## The lifecycle (NIST SP 800-61 ⇄ SANS PICERL)
| NIST SP 800-61 | SANS PICERL | What happens |
|---|---|---|
| Preparation | Preparation | tooling, logging, playbooks, authorization, contacts — done *before* incidents |
| Detection & Analysis | Identification | confirm it's real, scope it, build the timeline, find root cause |
| Containment, Eradication & Recovery | Containment → Eradication → Recovery | stop spread, remove the foothold, restore to known-good |
| Post-Incident Activity | Lessons Learned | root-cause report + improvements (feed the `detect` skill) |

The two models share intent; SANS just splits Containment/Eradication/Recovery out. **The lifecycle is NOT
strictly sequential** — NIST explicitly loops Containment back to Detection & Analysis, because you won't always
get the scope right the first time. Per-phase metrics: **MTTD** (mean time to detect) measures Detection;
**MTTR** (mean time to respond/recover) measures Containment→Recovery. Don't rush to eradicate before you've
scoped the full footprint (whack-a-mole tips off the adversary and misses persistence).

## Preparation underpins everything (people · process · technology)
- **No silver-bullet tool.** Effective IR needs the right **technology** (tools that handle your data volume),
  the right **people** (trained to use them), *and* the right **process** (do the people have the access/creds/
  coordination to use the tool in the right place?). Doing two of the three well isn't enough for a
  sophisticated incident.
- **Prepare before the fire:** playbooks, **tabletop exercises**, defined criteria for what *is* an incident,
  on-call/escalation paths, and the access (physical/electronic, domain-admin where needed) responders require.
- **Prevention controls double as IR enablers.** Environment/risk assessments, network/host hardening, and
  training (NIST's prevention guidance) also create **data sources** for IR and surface **visibility gaps**
  before you need them — tabletop and red-team exercises find these (see the red side's purple-team loop).
- **Lessons Learned feeds back into Preparation** — IR is a continuous-improvement loop, not a one-shot.

## Incident vs. problem — know when an incident *ends*
A subtle but high-value distinction. An **incident** is triggered when something violates the **CIA triad**
(confidentiality / integrity / availability). Defining **exit criteria** is as important as defining entry
criteria — don't leave something classified an "incident" for weeks/months with war-room paging.
- When the immediate CIA violation is **fixed/stabilized**, the work transitions from an **incident** (urgent,
  high-tempo, hourly/daily updates, war room) to a **problem** (problem management: assign a PM, set timelines,
  open a project, root-cause and permanently fix or build a mitigation procedure).
- Some phases (eradication/recovery of a bad infection, or a recurring vendor bug) genuinely take weeks — that's
  **problem-management work**, with different cadence and comms, not an open incident. Move it off the incident
  track once the bleeding has stopped.
- Communication differs by mode: incident = frequent, focused updates to the right people; problem = scheduled
  status to stakeholders. Avoid pointless recurring status meetings that just report "+1% done."

## Triage & severity
- **Validate first** — is the alert a true incident or a false positive? (`references/01`.)
- **Scope** — which hosts, accounts, data, and business processes are affected? Pivot on IOCs to find *all*
  affected assets before acting.
- **Severity** — combine impact (data sensitivity, business criticality, blast radius) and urgency (active
  spread? data exfil in progress? ransomware detonating?). Severity drives speed, who's pulled in, and comms.
- **Classify** — malware, BEC/phishing, ransomware, insider, web compromise, account takeover, data breach —
  each has a different playbook.

## Roles & comms
- **Incident commander** (coordinates, makes the call), **handlers/analysts** (do the work), **scribe** (keeps
  `/work/INCIDENT.md` current). Define an **escalation + approval path** for gated actions.
- **Communications** — internal stakeholders, leadership, and (if required) legal, PR, and customers. Use an
  out-of-band channel if the primary comms may be compromised. Avoid tipping off the adversary.
- **Deconfliction with offensive testing** — confirm the activity isn't an authorized red-team engagement before
  declaring a real incident (the red side keeps a timestamped operator log for exactly this).

## Legal, regulatory & evidence
- **Breach-notification obligations** vary by data + jurisdiction (PCI DSS, HIPAA, GDPR, state laws) and often
  have **clocks** (e.g. 72 hours under GDPR). Loop in legal early; the IR severity/scope drives the obligation.
- **Preserve evidence to a legal standard** if litigation/law-enforcement is possible — chain of custody,
  hashing, work-on-copies (`references/01`). Decisions about law-enforcement involvement are the client's.
- **Don't attribute publicly or hastily** — attribution is hard; report TTPs/ATT&CK mapping and confidence, not
  unfounded actor claims.

## Outputs
A defensible **timeline** (ATT&CK-mapped), **root cause** (initial access → impact), the **actions taken** (each
tied to an approval), **recovery validation**, and **lessons learned** that become detection/logging/playbook
improvements handed to the `detect` skill.
