# Incident Response — Methodology

Incident response is a disciplined lifecycle, not heroics. Follow a recognized framework so the response is
repeatable, defensible, and preserves evidence while limiting damage.

## The lifecycle (NIST SP 800-61 ⇄ SANS PICERL)
| NIST SP 800-61 | SANS PICERL | What happens |
|---|---|---|
| Preparation | Preparation | tooling, logging, playbooks, authorization, contacts — done *before* incidents |
| Detection & Analysis | Identification | confirm it's real, scope it, build the timeline, find root cause |
| Containment, Eradication & Recovery | Containment → Eradication → Recovery | stop spread, remove the foothold, restore to known-good |
| Post-Incident Activity | Lessons Learned | root-cause report + improvements (feed the `detect` skill) |

The two models share intent; SANS just splits Containment/Eradication/Recovery out. *(This four-phase operational
backbone is the NIST SP 800-61r2 model and remains how you run an incident.)* **The lifecycle is NOT
strictly sequential** — NIST explicitly loops Containment back to Detection & Analysis, because you won't always
get the scope right the first time. Per-phase metrics: **MTTD** (mean time to detect) measures Detection;
**MTTR** (mean time to respond/recover) measures Containment→Recovery. Don't rush to eradicate before you've
scoped the full footprint (whack-a-mole tips off the adversary and misses persistence).

## NIST SP 800-61r3 (2025) — IR as enterprise risk management, aligned to CSF 2.0
The 2025 revision (**r3**, which superseded the 2012 r2) re-frames incident response as **part of ongoing
cyber-security risk management and governance — not a separate technical exercise.** It maps IR onto the six
**NIST CSF 2.0** functions:
**Govern** (policy, sponsorship, risk strategy) · **Identify** (asset/risk understanding, inventories, BIA) ·
**Protect** (safeguards, preparation) · **Detect** (detection & analysis) · **Respond** (containment &
mitigation) · **Recover** (restoration). The operational r2 four-phase lifecycle above still runs *inside* this.
Practical implications:
- **IR is cross-functional, not just a SOC task.** Pull in **legal, compliance, privacy, communications/PR, HR,
  asset owners, and external partners (MSSP/cloud vendors)** — and practice *which* division/scenario you're
  testing. Big incidents touch the whole org (a war room with the CISO/C-suite, cloud vendor, legal).
- **An "incident" is more than cyber/software.** Physical events (a tornado taking out a site), or a pandemic
  forcing mass remote work, are incidents too — the plan covers movement of people, alternate sites, and surge
  capacity, not only malware.
- **AI-incident considerations (current).** Govern shadow AI; **risk-assess AI/SaaS tools** (don't wave through
  "it's from Microsoft/Google"); **push AI/Copilot logs to the SIEM** so you can detect/report on them; and know
  your **breach-notification path for AI data spillage** (data leaked into a public model, sensitivity-label/DLP
  bypass). See `detect/references/02` for the telemetry.
- **Continuous improvement** is explicit: lessons learned feed back into governance, preparation, and detection
  as KPIs/benchmarks — iterative, not a static post-incident review.

## IR documentation — policy, plan, procedures (three distinct artifacts)
- **Policy** — scope, severity/rating definitions, who may access/modify it, and a **statement of management
  commitment.**
- **Plan** — mission, strategy, goals (what you optimize when responding — preserve evidence vs. restore
  availability), and the **maturity roadmap** for the IR capability.
- **Procedures** — the SOPs: specific technical steps, **checklists, and forms** the IR team actually uses.
**Trust but verify:** if an org can't produce these on request, the capability probably isn't real.

## IR team structures (per NIST)
- **Central** — one team handles the whole org.
- **Distributed** — multiple teams, each owning a logical/physical segment.
- **Coordinating** — a team that **advises without authority** over others (e.g. an MSSP reviewing the internal
  team's work). Define authority + escalation up front.

## Preparation underpins everything (people · process · technology)
- **No silver-bullet tool.** Effective IR needs the right **technology** (tools that handle your data volume),
  the right **people** (trained to use them), *and* the right **process** (do the people have the access/creds/
  coordination to use the tool in the right place?). Doing two of the three well isn't enough for a
  sophisticated incident.
- **Prepare before the fire:** playbooks, **tabletop exercises**, defined criteria for what *is* an incident,
  on-call/escalation paths, and the access (physical/electronic, domain-admin where needed) responders require.
- **Prevention controls double as IR enablers.** Environment/risk assessments, network/host hardening, and
  training (NIST's prevention guidance) also create **data sources** for IR and surface **visibility gaps**
  before you need them — tabletop and red-team exercises find these (see the red side's purple-team loop).
- **Lessons Learned feeds back into Preparation** — IR is a continuous-improvement loop, not a one-shot.

## Incident vs. problem — know when an incident *ends*
A subtle but high-value distinction. An **incident** is triggered when something violates the **CIA triad**
(confidentiality / integrity / availability). Defining **exit criteria** is as important as defining entry
criteria — don't leave something classified an "incident" for weeks/months with war-room paging.
- When the immediate CIA violation is **fixed/stabilized**, the work transitions from an **incident** (urgent,
  high-tempo, hourly/daily updates, war room) to a **problem** (problem management: assign a PM, set timelines,
  open a project, root-cause and permanently fix or build a mitigation procedure).
- Some phases (eradication/recovery of a bad infection, or a recurring vendor bug) genuinely take weeks — that's
  **problem-management work**, with different cadence and comms, not an open incident. Move it off the incident
  track once the bleeding has stopped.
- Communication differs by mode: incident = frequent, focused updates to the right people; problem = scheduled
  status to stakeholders. Avoid pointless recurring status meetings that just report "+1% done."

## Triage & severity
- **Validate first** — is the alert a true incident or a false positive? (`references/01`.) Detection rests on
  **precursors** (a sign an incident *may* occur — e.g. recon, a new CVE for an exposed service) and
  **indicators** (a sign one *has* occurred or is in progress — an EDR alert, a matched IOC). Precursors are
  rare; most response starts from indicators.
- **Scope** — which hosts, accounts, data, and business processes are affected? Pivot on IOCs to find *all*
  affected assets before acting.
- **Prioritize, don't first-come-first-served** (NIST's three impact dimensions): **functional impact** (effect
  on the affected systems' operation), **information impact** (effect on the CIA of data — what exfiltration
  would mean for the mission), and **recoverability** (size/type of incident → time + resources to recover; some
  incidents aren't worth full recovery effort). Not all incidents are equal — active domain-admin on a DC far
  outranks a failed external brute-force.
- **Severity** — combine those impacts with urgency (active spread? data exfil in progress? ransomware
  detonating?). Severity drives speed, who's pulled in, and comms.
- **Classify** — malware, BEC/phishing, ransomware, insider, web compromise, account takeover, data breach, **AI/
  data-spillage** — each has a different playbook.
- **Decide containment by expected utility, not by probability alone.** Whether to take a (gated) disruptive
  action weighs the **compromise-likelihood band** against the **cost asymmetry** — downtime of a wrong isolation
  vs. damage of a missed breach. A **high-value asset justifies acting at a lower band** (isolate a prod DB at a
  Medium band; merely monitor a dev box at the same band). The math engine
  `tools/bayesian/blue_team_response_simulator.py` computes this; it is **advisory** — the action stays
  **human-gated** (`references/02`). Doctrine: `${AGENTIC_BLUETEAM_HOME}/docs/BAYESIAN_REASONING_UNDER_UNCERTAINTY.md`.

## Roles & comms
- **Incident commander** (coordinates, makes the call), **handlers/analysts** (do the work), **scribe** (keeps
  `/work/INCIDENT.md` current). Define an **escalation + approval path** for gated actions.
- **Communications** — internal stakeholders, leadership, and (if required) legal, PR, and customers. Use an
  out-of-band channel if the primary comms may be compromised. Avoid tipping off the adversary.
- **Deconfliction with offensive testing** — confirm the activity isn't an authorized red-team engagement before
  declaring a real incident (the red side keeps a timestamped operator log for exactly this).

## Legal, regulatory & evidence
- **Breach-notification obligations** vary by data + jurisdiction (PCI DSS, HIPAA, GDPR, state laws) and often
  have **clocks** (e.g. 72 hours under GDPR). Loop in legal early; the IR severity/scope drives the obligation.
- **Preserve evidence to a legal standard** if litigation/law-enforcement is possible — chain of custody,
  hashing, work-on-copies (`references/01`). Decisions about law-enforcement involvement are the client's.
- **Don't attribute publicly or hastily** — attribution is hard; report TTPs/ATT&CK mapping and confidence, not
  unfounded actor claims.

## Outputs
A defensible **timeline** (ATT&CK-mapped), **root cause** (initial access → impact), the **actions taken** (each
tied to an approval), **recovery validation**, and **lessons learned** that become detection/logging/playbook
improvements handed to the `detect` skill.
