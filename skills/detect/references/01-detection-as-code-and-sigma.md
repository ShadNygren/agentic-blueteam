# Detection-as-Code, Sigma & YARA

Treat detections like software: versioned, reviewed, tested, and deployed through a pipeline. This makes them
portable, auditable, and maintainable — the opposite of click-ops rules buried in one SIEM console.

## Detection-as-code workflow
- **Store rules in git** (e.g. `/work/detections/`), one rule per file, with metadata: title, description,
  author, date, ATT&CK technique ID(s), data source(s) required, false-positive notes, status (test/prod).
- **Review** rule changes like code (PRs). **CI** can lint rules, run them against sample/known-bad logs, and
  fail on regressions — the same pattern this project uses for its own image.
- **Test cases travel with the rule:** how to trigger it (an Atomic Red Team test / a red-team emulation) and
  the expected match. A rule with no test is unproven.

## Sigma — portable detection rules
**Sigma** is a generic, YAML-based signature format for log events; convert one rule to many SIEM dialects.
- Anatomy: `title`, `logsource` (category/product/service, e.g. `category: process_creation`, `product:
  windows`), `detection` (a `selection` of field matches + a `condition`), `falsepositives`, `level`, and
  `tags` (put the ATT&CK technique here, e.g. `attack.t1059.001`).
- Sketch:
  ```yaml
  title: Encoded PowerShell from Office
  logsource: { category: process_creation, product: windows }
  detection:
    selection:
      ParentImage|endswith: ['\winword.exe','\excel.exe']
      Image|endswith: '\powershell.exe'
      CommandLine|contains: '-enc'
    condition: selection
  level: high
  tags: [attack.execution, attack.t1059.001]
  ```
- **Convert** with the Sigma CLI: `sigma convert -t <backend> rule.yml` (backends for Splunk SPL, Elastic/ES|QL,
  Sentinel KQL, etc.). Author once in Sigma; deploy everywhere.
- Sigma also has correlation rules (count/temporal) for multi-event detections.

## YARA — file & memory content
**YARA** classifies files/memory by content patterns — malware families, web shells, tool artifacts.
- A rule has `meta`, `strings` (text/hex/regex), and a boolean `condition`. Keep strings specific to avoid FPs;
  prefer combinations (`2 of ($a*)`) and anchor on stable artifacts, not volatile noise.
- Run: `yara rules.yar <file-or-dir>`; pairs with memory forensics (scan a Volatility-dumped process) — see the
  `respond` skill. Like detections, anchor on durable traits over easily-changed atoms (Pyramid of Pain, `ref 00`).

## Tuning false positives (the make-or-break step)
- Run the new rule against **real baseline data** (a representative window of normal logs) before deploying.
- For each FP, decide: tighten the selection, add an exclusion (`filter`) for known-good, raise the correlation
  threshold, or lower severity. Document *why* each exclusion exists (exclusions are attack surface — an
  attacker who learns them can hide).
- Re-run the **test case** after every tune to confirm you didn't break true-positive detection.

## Other detection content
- **Suricata/Snort** rules for network IDS; **Zeek** scripts for protocol-level analytics (`ref 02`).
- **EDR/SIEM-native** analytics (KQL/SPL/EQL) when a behaviour needs platform-specific telemetry; keep the
  ATT&CK mapping + test case regardless of language.
