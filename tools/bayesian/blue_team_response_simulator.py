#!/usr/bin/env python3
"""Blue-Team Response Simulator (deterministic math engine).

Bayesian alert triage + expected-utility (EU) containment decision. Computes the posterior probability that an
asset is compromised given an alert (prior + detector TPR/FPR), then weighs the cost asymmetry (downtime of a
false-positive isolation vs. damage of a false-negative miss) to recommend ISOLATE vs. MONITOR.

The recommendation is advisory only: any state-changing action remains HUMAN-GATED via the response guard. Reason
in bands by default; call this when you need a defensible figure. See docs/BAYESIAN_REASONING_UNDER_UNCERTAINTY.md.

Copyright (c) 2026 Shad Nygren / Virtual Hipster Corporation - Apache-2.0 License
"""
from typing import Dict, Any

try:
    from bands import prob_to_band
except ImportError:
    from .bands import prob_to_band


class BlueTeamResponseSimulator:
    """Bayesian triage + expected-utility isolate-vs-monitor decision."""

    def triage_and_evaluate(
        self,
        prior_criticality: float,
        true_positive_rate: float,
        false_positive_rate: float,
        downtime_cost: float,
        breach_damage_cost: float,
    ) -> Dict[str, Any]:
        if not all(0.0 <= x <= 1.0 for x in (prior_criticality, true_positive_rate, false_positive_rate)):
            raise ValueError("Probabilities must be between 0.0 and 1.0.")
        if downtime_cost < 0 or breach_damage_cost < 0:
            raise ValueError("Costs must be non-negative.")

        # 1) Bayesian update: P(Compromised | Alert)
        prior_safe = 1.0 - prior_criticality
        p_alert_given_c = true_positive_rate * prior_criticality
        p_alert_given_s = false_positive_rate * prior_safe
        p_total = p_alert_given_c + p_alert_given_s
        posterior = 0.0 if p_total == 0 else p_alert_given_c / p_total

        # 2) Utility matrix U(action, state); costs are negative utility
        u_iso_c, u_iso_s = 0.0, -downtime_cost            # isolate: correct if compromised, downtime if safe
        u_mon_c, u_mon_s = -breach_damage_cost, 0.0       # monitor: catastrophic if compromised, fine if safe

        # 3) Expected utility
        pc, ps = posterior, 1.0 - posterior
        eu_isolate = pc * u_iso_c + ps * u_iso_s
        eu_monitor = pc * u_mon_c + ps * u_mon_s

        directive = ("TRIGGER ISOLATION (human approval required)"
                     if eu_isolate > eu_monitor else "MAINTAIN MONITORING")

        return {
            "posterior_breach_probability": round(posterior, 4),
            "posterior_band": prob_to_band(posterior),
            "expected_utility_isolate": round(eu_isolate, 2),
            "expected_utility_monitor": round(eu_monitor, 2),
            "automated_directive": directive,
        }


if __name__ == "__main__":
    agent = BlueTeamResponseSimulator()

    print("--- Scenario 1: Standard developer workstation ---")
    r1 = agent.triage_and_evaluate(
        prior_criticality=0.02, true_positive_rate=0.85, false_positive_rate=0.15,
        downtime_cost=5_000.0, breach_damage_cost=25_000.0,
    )
    print(f"Breach P: {r1['posterior_breach_probability']*100:.2f}% ({r1['posterior_band']}) | "
          f"EU isolate {r1['expected_utility_isolate']} vs monitor {r1['expected_utility_monitor']}")
    print(f"Directive: {r1['automated_directive']}\n")

    print("--- Scenario 2: Production database (same alert, catastrophic breach cost) ---")
    r2 = agent.triage_and_evaluate(
        prior_criticality=0.02, true_positive_rate=0.85, false_positive_rate=0.15,
        downtime_cost=10_000.0, breach_damage_cost=500_000.0,
    )
    print(f"Breach P: {r2['posterior_breach_probability']*100:.2f}% ({r2['posterior_band']}) | "
          f"EU isolate {r2['expected_utility_isolate']} vs monitor {r2['expected_utility_monitor']}")
    print(f"Directive: {r2['automated_directive']}")
    print("Lesson: same likelihood band, opposite action - a high-value asset justifies acting at a lower band.")
