"""Qualitative probability bands for Bayesian reasoning.

Doctrine: agents reason in BANDS (Very Low ... Very High), never invented numbers. When a deterministic tool
computes an exact probability, it reports the number AND its band via prob_to_band(). See
docs/BAYESIAN_REASONING_UNDER_UNCERTAINTY.md.

Copyright (c) 2026 Shad Nygren / Virtual Hipster Corporation - Apache-2.0 License
"""
from typing import List, Tuple

# (lower inclusive, upper exclusive, label) - all FIVE bands, 1:1 with the doctrine table.
# Very High's upper bound is 1.01 so that p == 1.0 maps to "Very High".
_BANDS: List[Tuple[float, float, str]] = [
    (0.00, 0.10, "Very Low"),
    (0.10, 0.30, "Low"),
    (0.30, 0.70, "Medium"),
    (0.70, 0.90, "High"),
    (0.90, 1.01, "Very High"),
]

BAND_LABELS: List[str] = [label for _, _, label in _BANDS]  # Very Low ... Very High


def prob_to_band(p: float) -> str:
    """Map a probability in [0,1] to its qualitative band label."""
    if not 0.0 <= p <= 1.0:
        raise ValueError("probability must be between 0.0 and 1.0")
    for lo, hi, label in _BANDS:
        if lo <= p < hi:
            return label
    return "Very High"  # unreachable given the ranges; kept as a defensive default


if __name__ == "__main__":
    for x in (0.03, 0.2, 0.5, 0.8, 0.97):
        print(f"{x:.2f} -> {prob_to_band(x)}")
