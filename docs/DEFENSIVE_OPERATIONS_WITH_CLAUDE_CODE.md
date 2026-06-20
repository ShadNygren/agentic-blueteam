# Defensive Operations with Claude Code

*A documented methodology for AI-augmented blue-team work — Claude Code orchestrating detection engineering,
threat hunting, and incident response, wrapped in a deterministic harness with human-in-the-loop control so
findings are tool-evidenced and reproducible, and state-changing actions are gated.*

---

## 0. Why this document exists
Defensive teams drown in telemetry and alerts. AI can accelerate the reasoning — correlating logs, drafting
detections, building incident timelines — **if** it's grounded in real data and prevented from acting
destructively on its own. This is both an honesty artifact (findings are evidenced, not hallucinated) and a
capability plan (detection engineering + DFIR you can genuinely deliver).

## 1. The approach in one paragraph
Claude Code is the **orchestration layer** over a defensive toolkit (Sigma/YARA, log/forensic tooling). It
**accelerates** detection authoring, telemetry analysis, hunt hypotheses, and incident reporting; **a human
approves every state-changing response** (containment/eradication/blocking); and **every detection, IOC, and
conclusion is validated against real telemetry/artifacts** before it ships. This counters the defensive AI
failure mode — **"hallucinated detection"** (inventing alerts, IOCs, or root causes) — with deterministic
validators and human review.

## 2. The red/blue loop (why this is the companion to Agentic Redteam)
ATT&CK is the shared language. The offensive side ([Agentic Redteam](https://github.com/ShadNygren/agentic-redteam))
emulates an adversary and produces an **ATT&CK-mapped attack narrative + detection-gap matrix**. The defensive
side consumes those mapped techniques (and Atomic Red Team test cases) to **build, tune, and prove detections**,
then feeds measured gaps back. Red emulates → Blue detects/responds → gaps drive the next round. The two
projects share the deterministic-harness + progressive-disclosure design; only the posture differs.

## 3. Frameworks (the backbone)
- **MITRE ATT&CK** — techniques to detect/hunt; the common language with the red team.
- **MITRE D3FEND** — defensive countermeasures mapped to offensive techniques.
- **NIST SP 800-61** (Computer Security Incident Handling) and **SANS PICERL** — the IR lifecycle.
- **The Detection Engineering lifecycle** — hypothesis → data → rule (detection-as-code) → test → tune → deploy
  → maintain, with coverage tracked on the ATT&CK matrix.
- **The Pyramid of Pain** — prefer detections on TTPs/behaviour over brittle atomic IOCs (hashes/IPs).

## 4. Skills
- **`detect`** — detection engineering & monitoring: build/tune detections (Sigma/YARA, detection-as-code), map
  telemetry coverage to ATT&CK, and validate against red-team emulations.
- **`respond`** — incident response / DFIR: triage → contain → eradicate → recover with forensic integrity, an
  ATT&CK-mapped timeline, and a human-gated action model.
- *(planned)* **`hunt`** — hypothesis-driven threat hunting.

## 5. Guardrails (the differentiator)
1. **Tool-evidenced findings only** — no detection/IOC/root-cause the telemetry or artifacts don't support.
2. **Human-in-the-loop for all state-changing actions** — analysis is AI-paced; containment/eradication/blocking
   is gated by explicit approval (`response_guard.sh` + an authorized-actions allow-list).
3. **Forensic integrity** — work on copies, hash on acquisition, preserve chain of custody, never alter sources.
4. **Reproducibility** — every detection ships with its query, required data sources, and a test case; every
   finding is reproducible from documented steps + evidence.
5. **Egress control / local-LLM option** — for regulated logs/evidence, run a local model so nothing leaves.

## 6. Safety, legal & ethics (non-negotiable)
Operate only on systems/data you own or are authorized to defend/investigate. Honor legal and
breach-notification obligations (PCI/HIPAA/GDPR). Never take a disruptive action without authorization; preserve
evidence; document everything. See `SECURITY.md`.
