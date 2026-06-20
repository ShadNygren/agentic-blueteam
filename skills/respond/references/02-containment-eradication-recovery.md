# Containment, Eradication & Recovery

This is where the response **changes system state** — so it's the **human-in-the-loop gate**. Every action here
must (a) match an approved line in `/work/AUTHORIZED_RESPONSE.txt` (`scripts/response_guard.sh`), (b) have an
explicit human "go," and (c) be recorded in `/work/INCIDENT.md` with who approved it and when. Preserve evidence
*before* any destructive step.

## Containment — stop the spread (gated)
Goal: limit damage while **preserving evidence** and **not tipping off** the adversary prematurely.
- **Short-term, reversible first:** isolate a host (network quarantine via EDR — keep it powered for memory),
  disable/limit a compromised account, block a C2 IP/domain/hash at the firewall/proxy/EDR, kill a malicious
  process, revoke sessions/tokens.
- **Capture volatile evidence before isolation reboots/powers anything** (memory first — `references/01`).
- **Sequencing matters:** contain *all* known footholds together where possible — partial containment warns the
  adversary, who may burn persistence or detonate (ransomware). Scope fully first (`ref 01`).
- **Balance** speed vs. business impact vs. evidence vs. stealth — that trade-off is a **human decision**;
  present options + impact, then wait for approval.
- **Containment isn't always isolation.** When a system is too business-critical to take offline, "control the
  bleeding" with **other technical controls** — restrictive firewall/segmentation rules, blocking the C2 channel,
  disabling the abused account/service, tightening access — rather than a full quarantine. The goal is to stop
  spread and limit the adversary's reach while the system stays up.
- **Action format** (so the guard can authorize it): `isolate-host: <name>`, `disable-account: <user>`,
  `block-ip: <ip>`, `block-hash: <sha256>`, `kill-process: <host> pid <n>`.

## Eradication — remove the foothold (gated)
- Remove malware, **persistence** (scheduled tasks, services, run keys, WMI subs, startup, cron/systemd),
  attacker-created accounts, web shells, and rogue tooling — on **every** affected asset (you scoped them all
  in analysis).
- **Close the root cause:** patch/▢ the exploited vulnerability, rotate exposed credentials/keys/secrets, fix
  the misconfiguration. If you don't fix initial access, they come back.
- Re-image rather than clean when integrity is uncertain (especially for kernel-level/rootkit or ransomware).
- **Eradication is never 100% — assume so.** Sophisticated/nation-state actors plant redundant persistence; you
  may kill one backdoor and miss another, and you often don't know their full capability. Re-image where
  feasible, watch closely afterward, and treat "fully eradicated" as a best-effort claim with confidence, not a
  certainty.

## Recovery — restore to known-good (gated)
- Restore systems/data from **known-good backups** (verify the backup predates compromise and is clean), rebuild
  from trusted images, and validate integrity before returning to production.
- **Recovery is also *testing the fixes*** — verify the eradication actually held (the threat doesn't reappear),
  controls are in place, and the system behaves normally before it's trusted again. A red-team/purple-team retest
  of the closed attack path is a strong validation.
- **Monitor closely** post-recovery for recurrence — deploy/raise the new detections (the `detect` skill) for the
  observed TTPs; watch the previously affected assets and accounts. Post-incident monitoring is part of recovery,
  not separate from it (in case eradication missed something).
- Phase the return to production; confirm business functionality and that the attacker's access is truly gone.
- **Prioritize recovery by business value — you can't recover everything at once.** Use the org's
  **business-function ranking / BIA** (business impact analysis) and each system's **RTO** (recovery time
  objective — must it be up in 1h? 24h? 15 days?) and **RPO** (recovery point objective — how much data loss is
  tolerable?). Bring the highest-ranked, lowest-RTO systems (tax/health/payments data) back first; a low-value
  HR doc share can wait. Made on the fly without these rankings, recovery decisions are guesswork. (BIA/RTO/RPO
  live in the BCP/DR program — IR consumes them.)

## Automation & runbooks (SOAR) — gated
Codify the response as **runbooks** so it's repeatable and fast (the maturity goal: "anyone can run the book,"
not heroics). A SOAR/automation runbook for, e.g., compromised AWS credentials chains: **confirm** (GuardDuty/
CloudTrail/Config + the IAM principal) → **contain** (revoke keys, kill sessions, quarantine the account, block
access) → **investigate** (logs for the window, lateral movement) → **remediate** (rotate keys, enforce MFA,
least-privilege) → **recover** (re-enable safe services) → **lessons learned** (update detections/guardrails).
- **The human gate still applies to automated containment.** Any state-changing step an automation would take
  (revoke/disable/block/isolate) must pass `response_guard.sh` + approval — automation drafts and stages the
  actions; a human authorizes. Don't wire fully-autonomous destructive response.

## Post-incident (lessons learned → stronger defense)
- Write the **root-cause report**: initial access → actions on objective, ATT&CK-mapped, with the timeline and
  the actions taken (each tied to its approval).
- **Hand detection/logging gaps to the `detect` skill** — every technique the adversary used that you *didn't*
  detect becomes a detection-engineering requirement (and a row in the detection-gap matrix). Missing telemetry
  becomes a logging requirement.
- Update **playbooks**, contacts, and the `AUTHORIZED_RESPONSE.txt` patterns based on what worked.
- Confirm any **breach-notification** obligations were met (`ref 00`).

## The gate, restated
If an action changes state and isn't pre-authorized + human-approved, **do not take it** — propose it, show the
impact, and wait. The agent never autonomously isolates, blocks, deletes, eradicates, or restores.
