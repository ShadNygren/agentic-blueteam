# syntax=docker/dockerfile:1
#
# Agentic Blueteam(TM) — AI-augmented defensive security (detection / hunting / IR)
# Driven by Claude Code. Defensive companion to Agentic Redteam.
# Copyright (c) 2026 Shad Nygren / Virtual Hipster Corporation · Apache-2.0 License
#
# Base: debian stable-slim (override with --build-arg BASE_TAG=...). A clean, reproducible base onto which we
# install defensive/DFIR tooling — deliberately distinct from the red side's Kali base.
ARG BASE_TAG=stable-slim
FROM debian:${BASE_TAG}

LABEL org.opencontainers.image.title="Agentic Blueteam" \
      org.opencontainers.image.description="AI-augmented defensive security — detection, hunting, incident response — driven by Claude Code" \
      org.opencontainers.image.source="https://github.com/ShadNygren/agentic-blueteam" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.authors="Shad Nygren / Virtual Hipster Corporation"

ENV DEBIAN_FRONTEND=noninteractive \
    AGENTIC_BLUETEAM_HOME=/opt/agentic-blueteam

# 1) Core utilities + reliable defensive tools from apt
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates curl git jq ripgrep \
      yara \
      python3 python3-pip python3-venv \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# 2) Node.js 20 LTS (required by Claude Code) via NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
 && apt-get install -y --no-install-recommends nodejs \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# 3) Claude Code CLI (the orchestration layer). Provide ANTHROPIC_API_KEY at run time.
RUN npm install -g @anthropic-ai/claude-code \
 && npm cache clean --force

# 4) Python defensive tooling (best-effort — the smoke test treats these as non-fatal):
#    sigma-cli (detection-as-code), volatility3 (memory forensics).
RUN pip3 install --no-cache-dir --break-system-packages sigma-cli volatility3 || true

# 5) The value-add: the Claude Code skills (detect + respond), docs, and tests.
#    Skills are placed where Claude Code auto-discovers them (~/.claude/skills/).
COPY skills/ /root/.claude/skills/
RUN mkdir -p ${AGENTIC_BLUETEAM_HOME}
COPY docs/   ${AGENTIC_BLUETEAM_HOME}/docs/
COPY tests/  ${AGENTIC_BLUETEAM_HOME}/tests/
COPY README.md SECURITY.md NOTICE LICENSE ${AGENTIC_BLUETEAM_HOME}/
RUN chmod +x ${AGENTIC_BLUETEAM_HOME}/tests/*.sh /root/.claude/skills/*/scripts/*.sh 2>/dev/null || true

# 6) Workspace — mount a volume here: logs/evidence IN, detections/report OUT.
WORKDIR /work
VOLUME ["/work"]

# Drop into a shell; `claude` is on PATH and the `detect`/`respond` skills are preloaded.
# AUTHORIZED DEFENSE/INVESTIGATION ONLY — see SECURITY.md.
CMD ["/bin/bash"]
