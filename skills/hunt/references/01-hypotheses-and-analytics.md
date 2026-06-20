# Hypotheses & Analytic Techniques

A hunt is only as good as its hypothesis and the analytics you apply. A vague "look for bad stuff" wastes the
day; a specific, testable hypothesis against the right data finds things.

## Building a good hypothesis
A strong hypothesis is **specific, testable, and tied to data + ATT&CK**. Form: *"Adversary is doing
[behaviour / ATT&CK technique] on [scope], which would appear in [data source] as [observable]."*
Sources to generate hypotheses:
- **ATT&CK technique** — pick a technique (ideally one used by an actor that targets your industry — consume
  threat intel) and hunt its observable. E.g. `T1059.001` → encoded PowerShell in process-creation logs.
- **Threat intelligence** — a fresh report's TTPs/IOCs; pivot them across your estate.
- **Crown jewels** — "how would someone reach the payments DB?" → hunt those access paths.
- **Anomaly** — "service accounts shouldn't log on interactively" → hunt for ones that did.
Write the hypothesis down *before* hunting; record the result against it (confirmed / refuted / inconclusive).

## Core analytic techniques
- **Stack counting (frequency analysis)** — aggregate a field and sort by rarity. Rare = interesting: the host
  running a binary nobody else runs, the one parent→child process pair seen once, the single user with a weird
  user-agent. The workhorse of hunting.
- **Outlier / baseline analysis** — define "normal" (per host/user/time) and surface deviations: new admin
  logons, first-time-seen processes, off-hours activity, unusual data volumes.
- **Clustering / grouping** — group related events (by host, user, process tree, time window) to see a campaign
  rather than isolated events.
- **Enrichment** — add context to raw events: threat-intel reputation on IPs/domains/hashes, GeoIP/ASN, WHOIS
  age, file prevalence, user/role, asset criticality. Enrichment turns "an IP" into "a 2-day-old domain on a
  bulletproof host."
- **Link analysis / pivoting** — start from one indicator (a suspicious process, a C2 IP) and pivot through the
  data to related hosts/accounts/sessions, expanding the picture (and the scope of any incident).
- **Long-tail / least-frequency-of-occurrence** — the inverse of dashboards: the loudest things are usually
  benign; the **rarest** are where intrusions hide.

## Investigating a hit (benign vs. malicious)
For each candidate, gather: the full **process tree** (parent/child, command line), **user + host context**,
**timing**, **network** the process made, and **provenance** (signed? known path? prevalence?). Decide
benign / suspicious / malicious with an explicit **confidence level**. Map to ATT&CK. Resist confirmation bias —
look for the disconfirming evidence too.

## From hunt to detection
When a hunt query reliably surfaces a behaviour with acceptable false positives, **hand it to the `detect`
skill** to become a Sigma rule / standing detection (with the hunt as its test case). That's how hunting
permanently shrinks the blind spot instead of being repeated by hand.

## Honesty
Negative results are real results — "no evidence of `T1003` LSASS dumping in 30 days of process-access logs"
scopes risk and tunes the next hunt. Never manufacture a finding to justify the hunt; never assert malice the
data doesn't support.
