# Triage & Forensics

Get the facts without destroying them. The cardinal rule: **work on copies, preserve the original, capture in
order of volatility, and hash everything.** Every artifact you rely on must be reproducible and defensible.

## Chain of custody & integrity (do this around everything below)
- **Hash on acquisition** (`sha256sum`) and record it; re-verify before analysis. Note who collected what, when,
  from where, and how.
- **Work on copies** — analyze images/exports, never the live source. Don't write to the evidence drive.
- **Preserve timestamps** — record system time + timezone + clock skew; prefer UTC in the timeline.

## Order of volatility (capture most-volatile first)
1. **Memory (RAM)** — running processes, network connections, injected code, in-memory-only malware, keys. Lost
   on reboot. Acquire **before** powering off or isolating in a way that reboots.
2. **Volatile system state** — network connections, logged-on users, running processes/services, ARP/routing.
3. **Disk** — filesystem, registry, logs, artifacts.
4. **Remote/archived logs** — SIEM, cloud audit logs (durable; collect but lower urgency).

## Memory forensics — Volatility 3
`vol -f <memory.raw> windows.pslist` / `windows.pstree` (processes), `windows.netscan` (connections),
`windows.malfind` (injected code), `windows.cmdline`, `windows.dlllist`, `windows.handles`. Scan dumped
processes with **YARA** (see the `detect` skill) for known-bad. On Linux, use the `linux.*` plugins.

## Disk & artifact timelines
- **plaso / log2timeline** — `log2timeline.py timeline.plaso <image>` then `psort.py -o l2tcsv timeline.plaso`
  builds a **super-timeline** across filesystem + registry + logs + browser + event logs. The backbone of "what
  happened when."
- **Windows artifacts** — registry (run keys, services, ShimCache/AmCache for execution), prefetch, scheduled
  tasks, `$MFT`, USN journal, browser history, LNK/jumplists.
- **Linux artifacts** — `auth.log`/`auditd`, bash history, cron, systemd units, `/tmp`, SUID changes, package logs.

## Windows event logs (fast triage)
- **Chainsaw** and **Hayabusa** run **Sigma rules** over `.evtx` event logs to surface suspicious activity
  quickly (logons, process creation, PowerShell, service installs, Defender events) — great first-pass triage
  before the full timeline. (Same Sigma rules the `detect` skill authors — the loop again.)
- Key channels: Security (4624/4625/4672/4688), Sysmon, PowerShell/Operational (4104), System (service installs
  7045), TerminalServices (RDP).

## Observe before you act (don't be jumpy)
IR is **not** "see a problem, fix a problem" — premature fixing destroys evidence and tips off the adversary.
- **Find all of it first.** From the first compromised host, extract artifacts/IOCs and **pivot quietly across
  the estate** to find *every* affected host/account **and the initial-access vector** *before* you clean
  anything. Fix one host but miss the lateral movement, and the attacker just goes **low-and-slow** — you're now
  worse off and blind. (Analogy: don't arrest the bagman; find the source.)
- **Don't tip them off.** Scope using logs/EDR/AV passively — match the known-bad artifacts everywhere — rather
  than taking visible action that signals "we see you" and pushes them to burn persistence or detonate ransomware.
- **Know when to stop observing and pull the plug.** Observation has a limit — if the adversary is about to
  reach crown-jewel data (e.g. the database) or cause irreversible harm, **contain now**. This trade-off is a
  judgment call; present it to the human (incident commander) with the timeline and impact, and act on their go.
- **Communicate the *why*.** Stakeholders feel the urge to "just fix it." The incident commander explains the
  timeline — "we observed because fixing one hole would have missed the lateral move to the file server" — so the
  deliberate pace is understood, not mistaken for inaction.

## Scoping & IOC extraction
- From the foothold, extract **IOCs** — hashes, IPs/domains (C2), filenames/paths, persistence mechanisms,
  attacker accounts, user-agents, mutexes.
- **Pivot** those IOCs across the estate (EDR/SIEM hunts, the `detect` data sources) to find **every** affected
  host/account — scope the *full* footprint before containment so eradication isn't whack-a-mole.
- Map each observation to an **ATT&CK technique** and add a timestamped row to `/work/INCIDENT.md`.

## Preserve evidence to *disprove* a breach (regulatory)
Reimaging on reflex can destroy the very evidence you need to *avoid* a breach declaration.
- **HIPAA example:** a system holding PHI hit by ransomware is a **breach by default** — you must **prove no data
  left** to rebut it. If you wipe/reimage first, you lose that proof and must publicly declare a breach (lawyers,
  notifications, the works).
- **The proof lives in artifacts you'd otherwise destroy:** firewall/proxy egress logs (how much data left), and
  on Windows the **SRUM** database (System Resource Usage Monitor — per-process network bytes sent/received) and
  EDR network telemetry. **Capture these before any containment that alters/reimages the host.**
- General rule: the order-of-volatility capture above isn't just for analysis — it's what lets you make defensible
  statements (with confidence) about whether data was exfiltrated.

## Live response (when imaging isn't feasible)
Targeted live collection (EDR, `osquery`, Velociraptor, KAPE-style artifact collection) for fast triage at scale
— still hash + log what you collect, and capture volatile data first.

## Honesty
Conclusions come from artifacts, with **confidence levels**. If the data doesn't show initial access or
attribution, say **unknown** — never fabricate a root cause to close the ticket.
