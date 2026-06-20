# Hunting by Domain

Concrete hunt starting points across the four telemetry domains, each tied to MITRE ATT&CK. Use the `detect`
skill's data-sources reference to confirm the telemetry exists first; prefer behaviour/TTP hunts over atomic
IOCs. These are seeds — adapt the observable to your data and refine via the analytics in `ref 01`.

## Endpoint
- **Suspicious process lineage (Execution, T1059)** — Office apps (`winword`/`excel`) spawning `powershell`/
  `cmd`/`wscript`; `powershell -enc`/`-w hidden`; `mshta`/`regsvr32`/`rundll32` with odd args.
- **LOLBins (Defense Evasion / Execution, T1218)** — living-off-the-land binaries (`certutil` downloading,
  `bitsadmin`, `msbuild`, `installutil`) used outside their normal context. Stack-count usage to find the rare.
- **Credential access (T1003)** — non-system processes opening **LSASS** (Sysmon EID 10), `comsvcs.dll`
  MiniDump, shadow-copy/`ntds.dit` access.
- **Persistence (T1547/T1053/T1543)** — new run keys, scheduled tasks, services, WMI event subs; new autoruns
  on many hosts at once.
- **Anomalies** — first-time-seen binaries (stack count by hash/path), unsigned binaries in user-writable paths,
  processes from `\Temp\`/`\AppData\`.

## Network
- **C2 beaconing (T1071)** — periodic call-backs with low jitter to one destination; stack-count by
  destination + analyze inter-arrival regularity. Long connections, fixed-size requests.
- **DNS tunneling / DGA (T1071.004/T1568)** — high volume of TXT/NULL queries, very long subdomains, high-entropy
  / newly-registered domains, one host doing far more DNS than peers.
- **Rare external destinations** — least-frequency egress: connections to domains/ASNs nobody else talks to,
  newly-registered domains, cloud/file-share services unusual for the host. Enrich with reputation + domain age.
- **Lateral movement (T1021)** — unusual internal SMB/RDP/WinRM/WMI between hosts that don't normally talk;
  admin-share (`C$`/`ADMIN$`) usage; new logon types.

## Identity
- **Anomalous authentication (T1078)** — impossible travel, off-hours admin logons, service accounts logging on
  interactively, a spike of failed→success (spray), new device/location for privileged users.
- **Kerberos abuse** — Kerberoasting (many TGS requests for SPN accounts), AS-REP roasting, golden/silver-ticket
  anomalies, encryption-downgrade.
- **AD recon / privilege (T1087/T1098)** — BloodHound-style LDAP enumeration bursts, sudden privileged-group
  membership changes, new admin accounts, DCSync (replication) from a non-DC.
- **Cloud IdP** — risky OAuth consent grants, MFA-fatigue patterns, conditional-access bypass, new app
  registrations / federation changes.

## Cloud
- **Control-plane abuse (T1078.004)** — anomalous IAM changes, key/secret access, role assumption chains,
  disabling logging/guardrails (CloudTrail off, GuardDuty disabled) — itself a strong signal.
- **Exposure & exfil (T1530/T1567)** — public-bucket changes, mass object reads/downloads, snapshot sharing to
  external accounts, large/odd egress.
- **Persistence** — new credentials/keys on principals, backdoor IAM users, login profiles added to service
  accounts.

## Hunt hygiene
For each hunt, record the hypothesis, the data source, the exact query, the result + confidence, and the ATT&CK
ID — under `/work/hunts/`. Promote anything repeatable + low-FP to a standing detection (`detect`); escalate
anything active to `respond`. Never act from the hunt itself.
