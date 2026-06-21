# Agentic Blueteam™

*AI-augmented defensive security — detection engineering, threat hunting, and incident response, driven by Claude Code.*

**Copyright © 2026 Shad Nygren / Virtual Hipster Corporation · Apache-2.0 License**

[![Docker Build](https://github.com/ShadNygren/agentic-blueteam/actions/workflows/docker-build.yml/badge.svg)](https://github.com/ShadNygren/agentic-blueteam/actions/workflows/docker-build.yml)
[![Security Scan](https://github.com/ShadNygren/agentic-blueteam/actions/workflows/security.yml/badge.svg)](https://github.com/ShadNygren/agentic-blueteam/actions/workflows/security.yml)
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/ShadNygren/agentic-blueteam/badge)](https://scorecard.dev/viewer/?uri=github.com/ShadNygren/agentic-blueteam)
[![SBOM](https://img.shields.io/badge/SBOM-CycloneDX%20%2B%20SPDX-blue)](https://github.com/ShadNygren/agentic-blueteam/actions/workflows/security.yml)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

> 🛡️ **Defensive companion to [Agentic Redteam](https://github.com/ShadNygren/agentic-redteam).** Where
> Agentic Redteam *emulates* adversaries, Agentic Blueteam *detects and responds* to them — and validates its
> detections against the red side's ATT&CK-mapped emulations (the red/blue loop).

---

## What this is
A Docker image that packages **defensive / DFIR tooling + Claude Code + Claude Code skills** into a single,
runnable, AI-augmented blue-team toolkit. Claude Code orchestrates the toolset by following recognized
methodologies — **MITRE ATT&CK / NIST SP 800-61 (incident handling) / the Detection Engineering lifecycle** —
wrapped in a **deterministic harness with human-in-the-loop control** so every finding is **tool-evidenced and
reproducible, not hallucinated**, and every **state-changing response action is gated**.

The skills (use the right one for the job):
- **`detect`** — **detection engineering & monitoring**: build/tune detections against MITRE ATT&CK
  (detection-as-code, Sigma/YARA), map telemetry coverage, and **validate detections against Agentic Redteam
  emulations**.
- **`hunt`** — **threat hunting**: proactive, hypothesis-driven, assume-breach search of telemetry for activity
  detections missed. Read-only — it discovers and hands off to `respond`/`detect`.
- **`respond`** — **incident response / DFIR**: triage → contain → eradicate → recover, with forensic integrity,
  a timeline, and ATT&CK-mapped root cause (NIST SP 800-61 / SANS PICERL).

## Quick start
```bash
# Build (default base: debian-slim + defensive toolset)
docker build -t agentic-blueteam .

# Run: mount a workspace (logs/evidence IN, detections/report OUT), provide your Claude key.
docker run -it --rm \
  -e ANTHROPIC_API_KEY=sk-ant-... \
  -v "$(pwd)/work:/work" \
  agentic-blueteam

# Inside the container:
#   1) put logs/evidence under /work/, the incident record at /work/INCIDENT.md, and (for IR)
#      the approved actions at /work/AUTHORIZED_RESPONSE.txt
#   2) run:  claude        # the `detect` / `respond` skills are preloaded and enforce the guardrails
```

## Safety model (why this is trustworthy)
- **Read & analyze freely; every state-changing response action is human-gated** (host isolation, account
  disable, IP/hash block, process kill, eradication) via `scripts/response_guard.sh` + an
  `/work/AUTHORIZED_RESPONSE.txt` allow-list.
- **Forensic integrity** — work on copies, hash evidence, preserve chain of custody; never alter source logs.
- **Tool-evidenced findings only** — every detection / alert / IOC / conclusion traces to real telemetry or an
  artifact; no fabricated detections or indicators.
- **ATT&CK as the common language** with the red side, so detections and gaps line up across the loop.

See [`SECURITY.md`](SECURITY.md) and the skills under [`skills/`](skills).

## The skills
Both skills use **progressive disclosure**: a focused `SKILL.md` entry point (hard rules + workflow) backed by a
`references/` library read as each phase demands.

**[`detect`](skills/detect/SKILL.md)** — detection engineering. References:
[methodology](skills/detect/references/00-detection-engineering-methodology.md),
[detection-as-code & Sigma/YARA](skills/detect/references/01-detection-as-code-and-sigma.md),
[telemetry & data sources](skills/detect/references/02-telemetry-and-data-sources.md),
[purple-team validation](skills/detect/references/03-purple-team-and-validation.md),
[MITRE D3FEND](skills/detect/references/04-mitre-d3fend.md).

**[`hunt`](skills/hunt/SKILL.md)** — threat hunting (read-only). References:
[methodology](skills/hunt/references/00-threat-hunting-methodology.md),
[hypotheses & analytics](skills/hunt/references/01-hypotheses-and-analytics.md),
[hunting by domain](skills/hunt/references/02-hunting-by-domain.md).

**[`respond`](skills/respond/SKILL.md)** — incident response / DFIR. References:
[IR methodology](skills/respond/references/00-ir-methodology.md),
[triage & forensics](skills/respond/references/01-triage-and-forensics.md),
[containment, eradication & recovery](skills/respond/references/02-containment-eradication-recovery.md),
[reporting & lessons learned](skills/respond/references/03-reporting-and-lessons-learned.md).

## Strategic foundation
All skills are grounded in a shared doctrine:
[**The Strategy of Adversarial Co-Evolution**](docs/STRATEGY_OF_ADVERSARIAL_COEVOLUTION.md) (identical in the
[Agentic Redteam](https://github.com/ShadNygren/agentic-redteam) companion). When both sides know the playbook
(ATT&CK + D3FEND), *knowledge is only the floor* — victory is decided by **tempo, terrain, deception, and
adaptation velocity**. Red vs. blue is **positive-sum sparring** (*iron sharpens iron*; "shall we play a game?")
that makes the organization win the real battles, later, against the genuine adversary.

## Probabilistic reasoning (Bayesian)
Defensive work is largely **alert triage and signal fusion under uncertainty.** This project applies **Bayesian
reasoning** with a hard rule for LLM reliability: **reason in qualitative bands — Very Low / Low / Medium / High /
Very High — never invented numbers.** Mind base rates (a noisy detector on a hardened asset is still probably a
false alarm), **fuse weak signals** into a confident picture without double-counting correlated ones, and decide
containment by **expected utility** (a high-value asset justifies acting at a lower band) — always **human-gated**.
When an **exact** figure is needed, the agent calls the deterministic engines in [`tools/bayesian/`](tools/bayesian)
(vulnerability calculator, response/expected-utility simulator) — the neuro-symbolic / deterministic-harness
pattern. Doctrine: [`docs/BAYESIAN_REASONING_UNDER_UNCERTAINTY.md`](docs/BAYESIAN_REASONING_UNDER_UNCERTAINTY.md).

## Keeping current (living project)
New attacks are devised continuously, so defense must co-evolve. This project **continuously monitors
cybersecurity developments and integrates emerging tactics and countermeasures** — ATT&CK/D3FEND/CAR updates,
CISA/NSA advisories, community CTI, new research, and new attack surfaces (e.g. AI-incident detection) — and
evolves **in lockstep with the red-team companion**: a new offensive technique on one side begets the matching
detection on the other. See the doctrine's §12 and [`CHANGELOG.md`](CHANGELOG.md).

## Trademarks
**Agentic Blueteam™** is a trademark of Shad Nygren / Virtual Hipster Corporation. This project is **driven by
Claude Code** and bundles third-party defensive/DFIR software — it is **not affiliated with, sponsored by, or
endorsed by Anthropic or any tool vendor**. **Claude** and **Claude Code** are trademarks of Anthropic. All
product names are used **descriptively**; no logos are used.

## License
Code and documentation: **Apache License 2.0** — see [`LICENSE`](LICENSE) and [`NOTICE`](NOTICE). The bundled
tools, Claude Code, and other third-party software remain under their own respective licenses.

## Changelog
Notable changes are tracked in [`CHANGELOG.md`](CHANGELOG.md) ([Keep a Changelog](https://keepachangelog.com) +
[SemVer](https://semver.org)).
