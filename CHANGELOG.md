# Changelog

All notable changes to **Agentic Blueteam™** are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
