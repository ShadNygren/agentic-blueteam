# Detection Engineering — Methodology

Detection engineering is the discipline of building **reliable, maintainable, low-false-positive detections** as
code, mapped to adversary behaviour. The goal is **coverage of TTPs with high-fidelity alerts**, not a pile of
brittle rules.

## The detection lifecycle (work it as a loop)
1. **Hypothesis / requirement** — a behaviour worth detecting: a MITRE ATT&CK technique, a gap from a red-team
   emulation or hunt, a threat-intel report, or a post-incident lesson.
2. **Data** — identify the **telemetry + fields** the behaviour produces (`references/02`). No data → no
   detection; log the collection gap first.
3. **Rule** — express it as code (`references/01`): a Sigma rule (portable) or platform query; YARA for file/
   memory content. Map to the ATT&CK ID; state intent + required data sources.
4. **Test** — trigger the behaviour (Atomic Red Team / red-team emulation) and confirm the rule fires.
5. **Tune** — run against real baseline data and **drive false positives down** (the make-or-break step).
6. **Deploy** — through the authorized change process (gated — see SKILL.md).
7. **Maintain** — detections rot (env changes, attacker variation); review and retest periodically.

## Coverage mapping (MITRE ATT&CK + D3FEND)
- Track which **ATT&CK techniques** you detect on the matrix (use the ATT&CK Navigator as the heat-map —
  detected / partial / none). This is the same artifact the red side produces, so they line up.
- Prioritize coverage by **threat model**: techniques used by actors that target your org/industry (consume
  threat intel), and the highest-impact tactics (credential access, lateral movement, exfil, impact).
- **MITRE D3FEND** maps defensive countermeasures to offensive techniques (via shared digital artifacts) — use it
  to reason about *which* control/detection counters a given technique, to run coverage-gap analysis, and to
  characterize tooling by function. Full treatment: `references/04-mitre-d3fend.md`.
- **Cover your *environment-specific* attack vectors, not just generic ones.** Generic detections (common
  protocols, well-known techniques) are table stakes; the higher-value coverage targets the attack surface your
  org actually exposes (e.g. SMB or other high-risk protocols exposed for a business reason, specific SaaS/
  cloud exposure). Work each vector → the indicators it produces → a structured triage that separates benign from
  incident → clear criteria for elevating to an incident. (This is the detection side of the IR Detection &
  Analysis phase; the `respond` skill consumes it.)

## The Pyramid of Pain (detect on behaviour, not just atoms)
From easiest-for-the-attacker-to-change to hardest:
**hash → IP → domain → network/host artifacts → tools → TTPs.**
Atomic IOCs (hashes/IPs) are cheap to detect but trivially rotated, so they age out fast. **Behaviour/TTP
detections** (e.g. "LSASS access by a non-system process," "encoded PowerShell spawning from Office") cost the
attacker real effort to evade — invest there. Keep IOC matching too (fast, cheap), but don't rely on it alone.

## Alert quality & fidelity
- **Every alert must be actionable** — a responder should know what it means and what to do. Alert fatigue from
  noisy rules is a security failure, not a detail.
- Track **true-positive vs false-positive rate** per rule; a rule that's 95% FP trains analysts to ignore it.
- Add **context** to alerts (host, user, process tree, ATT&CK ID, severity) so triage is fast.
- **Reason about alerts Bayesianly (base rates matter).** A rule's raw FP *rate* isn't its real-world fidelity:
  on a **rare** true condition, even an "accurate" detector mostly fires false alarms (the base-rate fallacy).
  Weight each alert by the asset's **prior band** (exposure/value/vuln-surface) × the detector's fidelity → a
  posterior confidence **band** (Very Low … Very High). Same alert → suppress on a hardened low-value asset,
  escalate on an exposed high-value one. Doctrine + the math engine:
  `${AGENTIC_BLUETEAM_HOME}/docs/BAYESIAN_REASONING_UNDER_UNCERTAINTY.md` and `tools/bayesian/`.
- Prefer **higher-fidelity correlations** (multiple weak signals) over single noisy indicators where possible.

## Metrics that matter
- **Detection coverage** (ATT&CK techniques covered, by tactic) and known **gaps**.
- **MTTD / MTTR** (mean time to detect / respond) — the red/blue loop should drive these down over time.
- **FP rate / alert volume** per rule; **rule health** (last tested, still firing on its test case).
- **Time-to-detection** in validation: did the detection fire when the emulation ran the technique?
