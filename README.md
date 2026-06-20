# Agentic Blueteam™

*AI-augmented defensive security — detection engineering, threat hunting, and incident response, driven by Claude Code.*

**Copyright © 2026 Shad Nygren / Virtual Hipster Corporation · Apache-2.0 License**

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
- **`respond`** — **incident response / DFIR**: triage → contain → eradicate → recover, with forensic integrity,
  a timeline, and ATT&CK-mapped root cause (NIST SP 800-61 / SANS PICERL).

> Threat hunting (`hunt`) is a planned next skill; for now hunting guidance lives inside `detect`/`respond`.

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
[purple-team validation](skills/detect/references/03-purple-team-and-validation.md).

**[`respond`](skills/respond/SKILL.md)** — incident response / DFIR. References:
[IR methodology](skills/respond/references/00-ir-methodology.md),
[triage & forensics](skills/respond/references/01-triage-and-forensics.md),
[containment, eradication & recovery](skills/respond/references/02-containment-eradication-recovery.md).

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
