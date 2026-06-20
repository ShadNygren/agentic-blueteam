# Telemetry & Data Sources

A detection is only as good as the data under it. Before writing a rule, confirm the **right telemetry is
collected, with the right fields, retained long enough** — and map your coverage to **MITRE ATT&CK Data
Sources**. Missing/again poor data is the most common reason detections fail silently.

## Endpoint
- **Windows process creation with command line** — the single highest-value source. **Sysmon** (especially EID
  1 process-create, EID 3 network, EID 7 image load, EID 8 remote-thread, EID 11 file-create, EID 10 process-
  access for LSASS) or EDR equivalents. Enable command-line auditing (4688 + cmdline).
- **PowerShell logging** — script-block logging (EID 4104), module + transcription logging; catches encoded/
  obfuscated payloads.
- **Authentication & privilege** — Windows Security log (4624/4625 logons, 4672 special privileges, 4688), Linux
  `auth.log`/`auditd`.
- **EDR telemetry** — process trees, file/registry/network events, and detections; often the richest single feed.

## Network
- **Zeek** — protocol-aware logs (conn, dns, http, ssl/x509, files) — excellent for beaconing, DNS tunneling,
  TLS/JA3 anomalies, lateral movement.
- **Suricata/Snort** — signature + protocol IDS/IPS.
- **NetFlow / firewall / proxy logs** — egress patterns, periodic beaconing, data-volume anomalies, blocked vs
  allowed. DNS logs are gold for C2/tunneling detection.

## Identity
- **Domain controllers / AD** — Kerberos (roasting, golden/silver ticket anomalies), LDAP queries (BloodHound
  collection), privileged-group changes, account creation, replication (DCSync) events.
- **Cloud IdP** (Entra ID/Okta) — sign-ins, impossible travel, MFA fatigue, OAuth consent grants, conditional-
  access failures.

## Cloud
- **AWS CloudTrail / GuardDuty**, **Azure Activity + Defender**, **GCP Audit Logs** — control-plane actions,
  IAM changes, key/secret access, anomalous API usage. Flow logs for network.
- **Container/k8s** — audit logs, runtime (Falco) events.

## Email & web
- Email gateway verdicts + user-reported phishing; web proxy logs (categories, downloads, uncategorized
  destinations).

## SaaS & AI (the new blind spot)
- **SaaS audit logs** — M365/Google Workspace/Salesforce admin + activity logs (sharing changes, mass
  download/export, mailbox rules, OAuth grants, DLP/sensitivity-label events).
- **AI / Copilot / chatbot logs — push them to the SIEM.** A common, current gap: AI assistants enabled
  org-wide but their logs never reach the SIEM, so you can't detect or report on AI data exposure. Collect
  prompt/response/audit logs and **DLP / sensitivity-label** events so you can catch sensitive data flowing into
  a model (e.g. a label that *should* have blocked AI ingestion but didn't). **Shadow AI/IT discovery** — find
  unsanctioned AI tools/SaaS (proxy/CASB) the way you hunt rogue assets; you can't protect what you don't know
  exists. (Incident handling for AI data spillage: `respond/references/00` + `03`.)

## ATT&CK Data Sources — map coverage, not just rules
For each technique you want to detect, ATT&CK lists the **Data Sources / Data Components** that reveal it (e.g.
T1003.001 LSASS dumping → *Process: OS API Execution*, *Process: Process Access*). Use this to answer "could we
even see this?" **before** writing the rule. Maintain a coverage view: technique → data source present? → detection
present? Gaps in the *data* layer are higher priority than gaps in the *rule* layer — you can't detect what you
don't collect.

## Detection & analysis fundamentals (NIST SP 800-61)
These make detection *work* once the data is flowing:
- **Profile/baseline** networks and systems — know normal so you can surface the abnormal (the basis of anomaly
  detection and hunting).
- **Event correlation** — correlate across sources (endpoint + network + identity) so analysts see the related
  critical event, not thousands of disconnected ones. This is the SIEM's core job.
- **Clock synchronization (NTP)** — every source on synced time, timestamps in UTC; without it, timelines and
  cross-source correlation break.
- **Log-retention policy** — collect and store long enough for hunts and IR (APTs dwell for months).
- A **knowledge base** of prior findings/indicators speeds future triage; **packet capture** adds depth when
  logs aren't enough.

## Data quality checklist
- **Completeness** — are the needed fields actually populated (command line, parent process, user)?
- **Coverage** — which hosts/accounts/cloud accounts are/aren't sending the log? Blind spots = undetected ground.
- **Timeliness & retention** — latency to the SIEM; retention long enough for hunts and IR (APTs dwell for
  months — see the red side's threat-intel reference).
- **Integrity & time sync** — trustworthy timestamps (NTP), tamper-resistant log storage.
