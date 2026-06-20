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

## Scoping & IOC extraction
- From the foothold, extract **IOCs** — hashes, IPs/domains (C2), filenames/paths, persistence mechanisms,
  attacker accounts, user-agents, mutexes.
- **Pivot** those IOCs across the estate (EDR/SIEM hunts, the `detect` data sources) to find **every** affected
  host/account — scope the *full* footprint before containment so eradication isn't whack-a-mole.
- Map each observation to an **ATT&CK technique** and add a timestamped row to `/work/INCIDENT.md`.

## Live response (when imaging isn't feasible)
Targeted live collection (EDR, `osquery`, Velociraptor, KAPE-style artifact collection) for fast triage at scale
— still hash + log what you collect, and capture volatile data first.

## Honesty
Conclusions come from artifacts, with **confidence levels**. If the data doesn't show initial access or
attribution, say **unknown** — never fabricate a root cause to close the ticket.
