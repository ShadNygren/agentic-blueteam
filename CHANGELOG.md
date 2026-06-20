# Changelog

All notable changes to **Agentic Blueteam™** are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- **`docs/STRATEGY_OF_ADVERSARIAL_COEVOLUTION.md`** — a strategic-foundation paper (shared verbatim with the
  red-team companion): *when both sides know the playbook, knowledge is only the floor* — victory turns on
  structural asymmetry, tempo (OODA), terrain, deception, force, discipline, and above all **adaptation velocity**
  (the Red Queen / adversarial self-play engine — WarGames, AlphaZero, GANs). Red/blue is **positive-sum
  sparring** (*iron sharpens iron*) and a **living document** that commits to continuously integrating emerging
  TTPs. Wired into all three SKILL.md files, README (Strategic foundation + Keeping current), and the smoke test.
- **`detect` reference `04-mitre-d3fend.md`** — MITRE D3FEND, the defensive counterpart to ATT&CK: the matrix
  (Model/Harden/Detect/Isolate/Deceive/Evict/Restore), the digital-artifact ontology that bridges to ATT&CK
  (mapping inferred via shared artifacts), the noun+verb naming, coverage-gap analysis, vendor/capability
  characterization (cut through the acronym soup) + D3FEND/ATT&CK extractors, caveats (not a checklist; notional
  ≠ tested coverage; risk-driven prioritization), and CAR/CAPEC/CWE. Cross-referenced from `respond` (Isolate/
  Evict/Restore/Deceive vocabulary) and `hunt` (CAR analytics). Smoke test now expects 5 detect reference files.
- **`hunt` skill** — proactive, hypothesis-driven, assume-breach threat hunting (read-only: discovers and hands
  off to `respond`/`detect`, never takes action). References: methodology, hypotheses & analytics (stack
  counting / outliers / enrichment / pivoting), and hunting by domain (endpoint/network/identity/cloud, ATT&CK-mapped).
- **`respond` reference `03-reporting-and-lessons-learned.md`** — IR report structure, metrics (dwell time /
  MTTD/MTTC/MTTR), and closing the loop into `detect`/`hunt`.
- **NIST SP 800-61r3 (2025) + CSF 2.0 integrated into `respond`/`detect`:** IR re-framed as enterprise risk
  management/governance across the six CSF functions (Govern/Identify/Protect/Detect/Respond/Recover) with the
  r2 four-phase lifecycle still operational; IR policy/plan/procedure trio; IR team structures (central/
  distributed/coordinating); precursors-vs-indicators + NIST's three impact dimensions (functional/information/
  recoverability); business-function ranking + RTO/RPO/BIA driving recovery order; SOAR runbooks (human-gated);
  notification/reporting specifics (HHS/state-AG/GDPR clocks); RACI, maturity levels, annual per-division
  exercises, evidence-retention policy; and **AI-incident handling** (govern shadow AI, risk-assess AI tools,
  push Copilot/AI + DLP/sensitivity-label logs to the SIEM, breach-notification for AI data spillage).
- **IR-practitioner wisdom integrated into `respond`** (from incident-response podcasts): the **incident→problem
  transition + exit criteria** and NIST-is-not-strictly-sequential / people·process·technology / prevention-as-
  data-sources (`00`); **observe-before-acting** (scope all + initial access before cleanup, don't tip off, when
  to pull the plug) and **preserve evidence to disprove a breach** (HIPAA-by-default; firewall logs + the Windows
  **SRUM** database show data exfil) (`01`); **containment ≠ isolation** and **eradication is never 100%** /
  recovery tests the fixes (`02`); **fair lessons-learned that drive a tracked plan of action**, celebrate
  strengths + name missed opportunities, include external parties (`03`). Plus environment-specific attack-vector
  coverage in `detect`.

### Changed
- **Base image → `ubuntu:24.04`** (more complete than debian-slim) and **Python tools installed via `pipx`**
  (isolated virtualenvs) — fixes the PEP-668 failure where `pip --break-system-packages` conflicted with
  apt-managed packages. `sigma` (sigma-cli) and `vol` (volatility3) are now reliably present; the smoke test
  promotes them from non-fatal warnings to hard checks.
- **CI now builds, smoke-tests, and publishes the image to GHCR** (`ghcr.io/shadnygren/agentic-blueteam`) as a
  **private** package on pushes to `main` — building once and pushing the exact tested image (`:latest` + short
  SHA).

## [0.1.0] - 2026-06-20
Initial scaffold of the **defensive companion to Agentic Redteam** — an AI-augmented blue-team toolkit (Kali's
counterpart on the defensive side): Claude Code + defensive/DFIR tooling in a Docker image, with a deterministic,
human-in-the-loop safety harness.

### Added
- **Docker image** on `debian:stable-slim` (override via `BASE_TAG`) with Node.js 20, the Claude Code CLI, and a
  defensive toolset (yara, jq, ripgrep + best-effort sigma-cli/volatility3). `ANTHROPIC_API_KEY` is supplied at
  run time, never baked in; `/work` is the mounted workspace.
- **`detect` skill** — detection engineering & monitoring (progressive disclosure: `SKILL.md` + a `references/`
  library): methodology (detection lifecycle, ATT&CK coverage, Pyramid of Pain, metrics), detection-as-code &
  Sigma/YARA, telemetry & data sources, and purple-team validation (the red/blue loop with Agentic Redteam +
  Atomic Red Team).
- **`respond` skill** — incident response / DFIR: methodology (NIST SP 800-61 / SANS PICERL), triage & forensics
  (order of volatility, Volatility3, plaso timelines, Chainsaw/Hayabusa, chain of custody), and containment /
  eradication / recovery (the human-gated action model).
- **Response guard** (`response_guard.sh`) in each skill — refuses any state-changing/response action not on the
  `/work/AUTHORIZED_RESPONSE.txt` allow-list (and refuses everything if the file is missing). Read-only analysis
  proceeds freely.
- **Templates** (`examples/AUTHORIZED_RESPONSE.txt`, `examples/INCIDENT.md`) and a **methodology doc**
  (`docs/DEFENSIVE_OPERATIONS_WITH_CLAUDE_CODE.md`).
- **Smoke test** (`tests/smoke-test.sh`) + **CI** (`.github/workflows/docker-build.yml`) — build the image and
  verify the toolchain, both skills + reference libraries, and both response guards (refusal without an auth file).
- **Project docs & licensing** — `README.md`, `SECURITY.md`, `NOTICE`, Apache-2.0 `LICENSE` (Copyright 2026 Shad
  Nygren / Virtual Hipster Corporation), trademark disclaimer.

### Security
- Hard safety model: read & analyze freely; **every state-changing response action is human-gated** (host
  isolation, account disable, IP/hash block, process kill, eradication, recovery); forensic integrity (work on
  copies, hash evidence, preserve chain of custody); tool-evidenced, reproducible findings only (no fabricated
  detections, IOCs, or root cause); local-model option for regulated data.

[Unreleased]: https://github.com/ShadNygren/agentic-blueteam/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/ShadNygren/agentic-blueteam/releases/tag/v0.1.0
