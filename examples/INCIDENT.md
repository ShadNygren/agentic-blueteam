# Incident Record (TEMPLATE)

> Copy to `/work/INCIDENT.md` and keep it current throughout the engagement. The `respond` skill builds the
> timeline here. Pair with `/work/AUTHORIZED_RESPONSE.txt` (the actions you're permitted to take).

**Incident ID / name:** ____________________________________________
**Reported / detected:** __________  **Detected by:** (alert / hunt / user / third party) __________
**Handler / responder:** __________________________  **Incident commander:** __________________________
**Severity:** ☐ Critical ☐ High ☐ Medium ☐ Low   **Status:** ☐ Open ☐ Contained ☐ Eradicated ☐ Closed

## Scope & authorization
- Affected systems / accounts / data (in-scope): ____________________________________________
- Authorized response actions: see `/work/AUTHORIZED_RESPONSE.txt` (state-changing actions are human-gated).
- Out-of-scope / do-not-touch: ____________________________________________
- Legal / compliance / breach-notification considerations (PCI/HIPAA/GDPR/...): __________

## Timeline (append-only; UTC timestamps)
| Time (UTC) | Source/host | Observation or action | ATT&CK ID | Evidence ref | Analyst |
|---|---|---|---|---|---|
| | | | | | |

## Indicators of Compromise (IOCs)
| Type (ip/domain/hash/account/path) | Value | Context | Confidence |
|---|---|---|---|
| | | | |

## Findings & root cause
(initial access → actions on objective; mapped to ATT&CK)

## Actions taken (containment / eradication / recovery)
(each action ↔ an approved line in AUTHORIZED_RESPONSE.txt; record who approved + when)

## Lessons learned / detection improvements
(hand detection gaps to the `detect` skill; what new logging/detections/playbooks are needed)
