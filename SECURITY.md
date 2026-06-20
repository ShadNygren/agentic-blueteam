# Security & Responsible Use

**Agentic Blueteam™** is defensive-security tooling. It analyzes logs/evidence and can propose or take response
actions — so it operates under guardrails to protect business continuity and evidence integrity.

## Authorized use
- Use it only on systems and data you **own or are authorized to defend / investigate**. Incident-response and
  forensic work still requires authorization and a defined scope.
- **State-changing response actions are human-gated.** Containment / eradication / blocking (host isolation,
  account disable, IP/hash block, process kill, deletion) must match a pre-approved line in
  `/work/AUTHORIZED_RESPONSE.txt`; the bundled `response_guard.sh` refuses anything else (and refuses everything
  if that file is missing). Read-only analysis, detection authoring, and hunting proceed freely.
- **No autonomous destructive action.** The agent never isolates, disables, blocks, deletes, or eradicates
  without explicit human approval — these can disrupt production and destroy evidence.

## Built-in guardrails
- Response-action allow-list enforcement (`skills/*/scripts/response_guard.sh`).
- Human-in-the-loop approval before any containment / eradication / blocking action.
- Forensic integrity: work on copies, hash evidence, preserve chain of custody, never alter source logs.
- Tool-evidenced, reproducible findings only — no fabricated detections, IOCs, or conclusions.

## Data handling
- Treat all logs, evidence, and incident data as confidential per your NDA/MSA and legal/breach-notification
  obligations (PCI/HIPAA/GDPR/...). Store under `/work/`, hash on acquisition, and destroy per retention terms.
- For regulated data, run with a **local model** (no cloud egress) or a sanctioned, documented data path.

## Reporting a vulnerability in this project
Found a security issue in **Agentic Blueteam** itself (not in a system you're defending)? Please report it
privately to the maintainer rather than opening a public issue, and allow reasonable time to remediate.

## Disclaimer
This software is provided "as is," without warranty of any kind, under the Apache License 2.0. The authors are
not liable for misuse. **You** are responsible for using it lawfully and ethically.
