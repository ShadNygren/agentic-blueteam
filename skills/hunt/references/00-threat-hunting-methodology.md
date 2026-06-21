# Threat Hunting — Methodology

Threat hunting is **proactive, hypothesis-driven** search for adversary activity that automated detections
missed. It **assumes a breach has already occurred** and goes looking — the opposite of waiting for an alert.
Its outputs feed both response (incidents) and detection engineering (new rules).

## What hunting is (and isn't)
- **Is:** human-led, hypothesis-driven analysis of telemetry to find unknown/undetected threats; an iterative
  discovery process that turns tacit "this looks wrong" into evidenced findings.
- **Isn't:** alert triage (reactive), running a vuln scanner, or taking action. Hunting **discovers**; the
  `respond` skill acts (gated) and the `detect` skill operationalizes (standing rules).
- **Assume breach** is the mindset: don't ask "are we compromised?" but "*how* would I find the compromise that's
  already here, given our blind spots?"
- **"Looks like the pentest" is a reason to hunt harder, not to relax.** A real adversary deliberately mimics
  red-team/pentest tradecraft (incl. public tooling like `agentic-redteam`) to blend in — so resemblance to
  authorized testing is a *hiding place*, not a clearance. Treat it as suspicious until **positively deconflicted**
  (`respond/references/00`; doctrine §10.1), and hunt the residual: is *every* such event accounted for by the
  white cell's operator log, or is one of them the real thing wearing the costume?

## The hunt loop
1. **Hypothesis** — a specific, testable statement about adversary behaviour (`references/01`).
2. **Data** — identify the telemetry that would reveal it (use the `detect` skill's data-sources reference). No
   data → a logging gap for `detect`; the hunt may be inconclusive.
3. **Hunt / analyze** — query and apply analytic techniques (`references/01`); investigate hits.
4. **Findings** — evidence + ATT&CK mapping + confidence (including "nothing found").
5. **Handoff & improve** — active threat → `respond`; repeatable pattern or logging gap → `detect`; refine the
   next hypothesis. **A good hunt should leave behind a new detection** so you never hunt the same thing twice.

## Types of hunt
- **TTP / ATT&CK-driven** — hunt for a specific technique an actor uses (e.g. `T1003.001` LSASS dumping). The
  most repeatable; prioritize techniques used by actors that target your industry (consume threat intel — see
  the red side's threat-intel/APT reference).
- **Intelligence-driven** — pivot on fresh IOCs/TTPs from a threat report across your estate.
- **Anomaly / baseline-driven** — establish "normal," then surface outliers (rare processes, new admin logons,
  unusual egress). Powerful but noisier; needs good baselines.
- **Crown-jewel / risk-driven** — start from the most valuable assets and hunt the paths an adversary would take
  to reach them.

## Pyramid of Pain (hunt for behaviour)
Atomic IOCs (hash/IP) are cheap to hunt but trivially rotated. Hunt at the **TTP** level (behaviour) where the
adversary can't easily change tradecraft — those findings become durable detections. Keep IOC sweeps too (fast),
but don't stop there.

## Maturity & cadence
- Maturity ranges from ad-hoc IOC searches → repeatable procedures → data-science-assisted hunting. Start with
  documented, repeatable TTP hunts.
- Run hunts on a **cadence** and after **triggers** (new threat intel, a red-team engagement, an incident, a new
  crown-jewel system). Each hunt should either find something or **produce a new detection** (so coverage grows).

## Outputs (always)
- **Findings** (evidenced, ATT&CK-mapped, with confidence) — including negative results.
- **Handoffs** — incidents to `respond`, detections + logging gaps to `detect`.
- **A documented, re-runnable hunt** (hypothesis + query + data + result) under `/work/hunts/`.
