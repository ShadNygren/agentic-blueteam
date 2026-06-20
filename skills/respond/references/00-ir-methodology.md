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

The lifecycle **loops** — analysis informs containment, new findings re-open analysis. Don't rush to eradicate
before you've scoped the full footprint (whack-a-mole tips off the adversary and misses persistence).

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
