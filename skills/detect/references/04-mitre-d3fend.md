# MITRE D3FEND — the defensive counterpart to ATT&CK

**D3FEND** (Detection, Denial & Disruption Framework Empowering Network Defense) is MITRE's NSA-funded knowledge
base of **defensive countermeasures** — the yin to ATT&CK's yang. Where ATT&CK names what attackers *do*, D3FEND
names what defenders *do* about it, in a standardized vocabulary. Use it to reason about defenses structurally,
find coverage gaps, characterize your tooling, and speak a common language with engineers, vendors, and the SOC.

## The D3FEND matrix — defensive tactics
Far fewer than ATT&CK's 14 tactics. Originally five (**Harden, Detect, Isolate, Deceive, Evict**); now also
**Model** and **Restore** — seven tactics:
- **Model** — know what you're defending: asset/software inventory, threat modeling, system mapping.
- **Harden** — reduce attack surface *before* compromise (design/config time). Sub-tactics: **Application
  Hardening** (ASLR, DEP, stack canaries, dead-code elimination vs. ROP, SAST/DAST to fix vulns), **Credential
  Hardening** (MFA), **Message Hardening** (message auth/encryption, API security), **Platform Hardening** (disk
  encryption, integrity/boot/firmware verification).
- **Detect** — observe malicious activity (D3FEND's deepest area): **File Analysis** (malware/binary), **Identifier
  Analysis** (URL/IP/domain), **Message Analysis**, **Network Traffic Analysis** (e.g. community-deviation /
  baseline), **Platform Monitoring**, **Process Analysis** (process-spawn analysis, system-call analysis).
- **Isolate** — limit reach: **Network Isolation** (segmentation), **Execution Isolation** (VMs, containers,
  enclaves).
- **Deceive** — decoys: honeypots/honeynets, **honey-credentials/honeytokens**, decoy personas (high-signal,
  low-false-positive detection — a touch on a honeytoken is almost always malicious).
- **Evict** — remove the adversary (stop execution, disable accounts) once detected.
- **Restore** — return to known-good operation (the recovery counterpart).

**Temporal reality (like ATT&CK, it's a knowledge base, not a strict sequence — but):** you can't **Isolate** or
**Evict** before you **Detect**; **Harden** happens at design time before the adversary arrives.

## How D3FEND connects to ATT&CK — the digital-artifact ontology
The bridge is **digital artifacts** (a knowledge graph of 400+ entities). A *digital object* (file, URL, IP,
process code segment, memory region, registry key, network packet…) becomes a *digital artifact* when a cyber
actor — offensive **or** defensive — **creates, touches, uses, or reads** it. Every ATT&CK technique
**produces/consumes** digital artifacts; D3FEND countermeasures **observe/act on** them.
- The ATT&CK ⇄ D3FEND mapping is **inferred through the shared artifact**, never hard-coded "X mitigates Y."
  Example: *process injection* (offense) modifies a **process code segment**; *process code segment
  verification* (defense) reads the same artifact → the tool can infer the relationship.
- Naming convention is **noun + verb** (e.g. `Process Spawn Analysis`, `URL Analysis`, `System Call Analysis`,
  `Network Traffic Community Deviation`). "Countermeasure / control / mitigation / defensive technique" are
  synonyms in D3FEND.

## How to use it (the practical use cases)
1. **Threat-intel-driven (ATT&CK → D3FEND).** For the techniques a relevant actor uses, pivot via the artifacts
   to candidate countermeasures, then prioritize. (CISA/NSA/FBI advisories now pair ATT&CK for offense + D3FEND
   for recommended countermeasures.)
2. **Capability / coverage-gap analysis.** Break your existing tools down into the D3FEND techniques they
   actually perform → a **notional** threat-coverage map → spot gaps. **Notional coverage ≠ real coverage** —
   turn the maybes into a **test plan** and validate (the purple-team loop, `ref 03`).
3. **Characterize vendors/tooling by *function*, not acronym.** Cut through the firewall→NGFW→IPS→EDR→NDR→XDR
   acronym soup by asking "what D3FEND techniques does this product actually do?" (MITRE's D3FEND/ATT&CK
   *extractors* pull techniques from vendor blogs and threat reports.) Many D3FEND techniques are also things you
   *build* — a SIEM query on process spawns **is** `Process Spawn Analysis`, not something you buy.
4. **Design-time (digital engineering).** Annotate system components with their digital artifacts → derive
   threats → derive applicable defenses, *early* in the SDLC where changes are cheap.

## Caveats (per MITRE)
- **Not a checklist, and it doesn't prioritize for you.** Which countermeasures to implement is *your* call —
  driven by your **threat model** (understand your enemies → their common TTPs → prioritize defenses) and your
  budget/risk (**risk ≈ threat × vulnerability × likelihood × impact**; spend on highest-risk assets first).
- **It's a model → inherently incomplete** (an abstraction that captured everything wouldn't be a model). Still
  maturing; treat as guidance, tailor to your environment — the real work is the tailoring.

## Related MITRE resources
- **CAR (Cyber Analytics Repository)** — ready-made detection analytics (e.g. Autorun via Sysinternals; Zeek
  scripts for SMB on port 445) mapped to ATT&CK. A direct source of detections and hunt analytics.
- **CAPEC** (attack patterns) and **CWE** (software weaknesses) — the weakness/pattern side that hardening fixes.

## How this skill uses D3FEND
Map each detection you author to its **D3FEND technique + the artifact it observes** (alongside its ATT&CK ID);
run **coverage-gap analysis** on the tool stack; characterize capabilities by function; and **validate**, never
assert notional coverage. Harden/Isolate/Evict/Deceive/Restore countermeasures are executed via the `respond`
skill (state-changing → human-gated); Deceive (honeytokens) is a high-signal detection you can deploy proactively.
