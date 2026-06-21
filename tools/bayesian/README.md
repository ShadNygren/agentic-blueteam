# `tools/bayesian/` — deterministic Bayesian math engines

**Reason in bands (Very Low … Very High); call these tools when you need an exact, defensible number.** This is
the neuro-symbolic / deterministic-harness pattern: the agent does qualitative reasoning, these scripts do the
arithmetic. Full doctrine: [`docs/BAYESIAN_REASONING_UNDER_UNCERTAINTY.md`](../../docs/BAYESIAN_REASONING_UNDER_UNCERTAINTY.md).

| Script | Purpose |
|---|---|
| `bands.py` | The five-band scale + `prob_to_band(p)` (every tool reports a number **and** its band). |
| `vulnerability_calculator.py` | Posterior P(real \| alert) from prior + TPR + FPR, with a per-10k population projection — makes the base-rate trap concrete (is this alert real?). |
| `blue_team_response_simulator.py` | Bayesian triage + expected-utility **isolate-vs-monitor** decision (advisory only — containment stays **human-gated** via the response guard). |

Pure standard-library Python 3 (no dependencies). Run any script directly to see a worked example:

```bash
python3 tools/bayesian/vulnerability_calculator.py
python3 tools/bayesian/blue_team_response_simulator.py
```

Import them in your own orchestration:

```python
from blue_team_response_simulator import BlueTeamResponseSimulator
r = BlueTeamResponseSimulator().triage_and_evaluate(0.02, 0.85, 0.15, downtime_cost=10000, breach_damage_cost=500000)
# r["posterior_band"], r["automated_directive"]  (directive is advisory; a human approves any action)
```

A telemetry broker can feed real events (EDR/Syslog + AWS GuardDuty/Security Hub/Inspector ASFF) into these
engines to compute **empirical** P(detection | attack) for the purple-team loop — see the doctrine §9.
