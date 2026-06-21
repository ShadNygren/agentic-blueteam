# Bayesian Reasoning Under Uncertainty
### Probabilistic hypothesis-testing for AI-augmented red and blue operations — qualitative bands by default, exact math only via tools

*A shared methodology for [Agentic Redteam](https://github.com/ShadNygren/agentic-redteam) and
[Agentic Blueteam](https://github.com/ShadNygren/agentic-blueteam). Identical in both projects by design.*

---

## 1. Why Bayesian reasoning fits security
Both offense and defense are, at heart, **hypothesis-test loops under uncertainty**: form a hypothesis ("this
service is exploitable," "this host is compromised"), gather evidence (a scan result, an alert, an artifact), and
**update your belief**. Bayes' theorem is the disciplined way to do that update:

> posterior ∝ prior × likelihood — *the updated belief is the starting belief weighted by how well the new
> evidence fits it.*

Crucially, **the posterior becomes the prior for the next piece of evidence** — so beliefs compound as a
campaign unfolds. This is exactly how a red-teamer's confidence in an attack path grows, and how a blue-teamer
fuses weak signals into a confident detection.

## 2. THE RULE: reason in bands, never invent numbers
**Do not assign precise numeric probabilities by LLM judgment.** Made-up numbers ("82% chance of lateral
movement") are false precision — LLMs neither calibrate nor compute arithmetic reliably. Instead use a **five-band
ordinal scale** for every prior and posterior:

| Band | Plain meaning | (numeric interval, *for tools only*) |
|---|---|---|
| **Very High** | near-certain | `[0.90, 1.0]` |
| **High** | likely | `[0.70, 0.90)` |
| **Medium** | plausible / uncertain | `[0.30, 0.70)` |
| **Low** | unlikely | `[0.10, 0.30)` |
| **Very Low** | near-negligible | `[0.00, 0.10)` |

*Intervals are **half-open** — lower-bound **inclusive (`>=`)**, upper-bound **exclusive (`<`)** — so they are
contiguous (no gap) and non-overlapping (no double-count). A boundary value belongs to the **higher** band (e.g.
`0.90 → Very High`). Agents reason in the **labels**; the numbers exist only for the deterministic tools.*

- **Exact numbers are allowed ONLY when a deterministic tool computes them** — this project ships them in
  [`tools/bayesian/`](../tools/bayesian) (§9). When you call a tool, report **both** the number *and* its band.
- This is the **neuro-symbolic / deterministic-harness** pattern: the LLM does strategy, language, and *qualitative*
  reasoning; a symbolic math engine does the rigorous calculation. It keeps findings **tool-evidenced, not
  hallucinated** — the same rule the skills already enforce.

## 3. The mechanics, in bands
- **Prior** — your baseline band *before* the evidence (from base rates: how common is this condition in this
  kind of environment?).
- **Evidence** — an observation, weighted by its **source fidelity**: a high-fidelity tool's positive is *strong*
  evidence; a noisy tool's positive is *weak*. (Fidelity = true-positive rate vs. false-positive rate.)
- **Posterior** — the updated band. **Strong** evidence can move belief several bands; **weak** evidence barely
  moves it. Then the posterior is the next prior.

Directional update heuristic (not arithmetic — call a tool for the real value):

| Prior \ Evidence | Strong-for | Weak-for | Strong-against |
|---|---|---|---|
| **Low** | → Medium/High | → Low (stays) | → Very Low |
| **Medium** | → High/Very High | → Medium (nudge up) | → Low |
| **High** | → Very High | → High (stays) | → Medium |

## 4. Base rates & the false-positive trap (the most important lesson)
A **rare** condition flagged by a **noisy** tool is *still probably a false alarm.* If the prior is **Low/Very
Low** and a single tool of mediocre fidelity fires, the posterior is **not High** — it's maybe Low→Medium at most.
Jumping straight to "confirmed" on one noisy hit is the **base-rate fallacy**, and it is the #1 cause of wasted
red-team effort and blue-team alert fatigue. **Always weight a single tool output by (a) the prior rarity and (b)
the tool's fidelity.** When in doubt, run `tools/bayesian/vulnerability_calculator.py` — a rare vuln + an
"accurate" scanner often yields a *surprisingly Low* posterior and a flood of false positives per 10k hosts.

## 5. Combining signals — and the independence caveat
- **Fusion compounds belief.** Several *independent* weak signals each nudge the band upward until a confident
  picture emerges — the **kill-chain narrative** (§7–8). This is how subtle, low-severity events that each look
  benign add up to a Very High posterior.
- **But independence rarely holds.** Naive Bayes assumes evidence is independent; in security it usually isn't —
  an open SMB port and a Windows Server banner are *correlated*, not two independent confirmations. **Don't
  double-count correlated evidence** — treating dependent signals as independent produces **overconfidence**
  (a Very High band that isn't earned). When signals share a common cause, count them as roughly one.

## 6. Decisions under uncertainty: expected utility (qualitative)
A *belief* band isn't a *decision*. The decision weighs the likelihood band against the **cost asymmetry**:
- **Cost of acting wrongly** (false positive — e.g. isolating a healthy asset = downtime) vs. **cost of not
  acting** (false negative — e.g. ignoring a real breach = catastrophic loss).
- Therefore: **a higher-value asset justifies acting at a *lower* likelihood band.** A Very-High-value asset
  (catastrophic breach cost) may warrant containment at a **Medium** compromise band, while a low-value dev box
  requires **High/Very High** before you'd disrupt it. Same likelihood, different action — because the stakes
  differ. (`tools/bayesian/blue_team_response_simulator.py` computes this trade-off; the red side uses the same
  logic to allocate effort to the highest-value, lowest-resistance path.)
- **The human-in-the-loop gate still governs every state-changing action.** Expected-utility reasoning
  *recommends*; a human *authorizes* (red exploitation, blue containment). The math never auto-fires a
  destructive action.

## 7. Red-team applications (in bands)
- **Vulnerability confidence.** Is this scanner/recon hit real? Combine the base-rate prior with the tool's
  fidelity → a band. **Chase High/Very High; deprioritize Low** (don't burn an engagement on ghost vulns).
- **Exploit-chain probability.** A multi-stage path's success is the *product* of its conditional steps
  (Recon → Initial Access → Privesc → …), so a chain is **only as strong as its weakest link**, and **a single
  effective mitigation collapses the entire downstream chain** even if the software is unpatched. This is how you
  answer *"where am I truly vulnerable vs. effectively mitigated?"* — model it with
  `tools/bayesian/exploit_chain_simulator.py`.
- **Information-gain prioritization.** Pick the next action that most **reduces uncertainty** about the path —
  the path of least resistance and highest confirmation value — rather than scanning everything.
- **Campaign updating.** Start a phishing campaign at an industry-base-rate band; update with open/click evidence
  to re-target dynamically rather than waiting for the end-of-engagement report.

## 8. Blue-team applications (in bands)
- **Dynamic alert triage.** Each asset carries a **prior band** from its exposure (public vs. isolated), value
  (prod DB vs. test box), and vuln/IAM surface. The *same* alert → **suppress** on a hardened, low-value, internal
  asset (posterior stays Low) but **escalate** on an exposed, misconfigured, high-value one (posterior spikes).
- **Weak-signal fusion.** Sequentially update across subtle anomalies to catch living-off-the-land activity
  before any single critical alert: e.g. *odd internal port scan* (Very Low → Low) → *admin login from an
  unusual IP* (Low → Medium) → *`vssadmin` deleting shadow copies* (Medium → Very High). The fused band reveals
  the attack graph early.
- **Expected-utility containment.** The decision to isolate / disable / block is the EU trade-off of §6 — and it
  is **human-gated** (the response guard): the agent computes the recommendation, a human approves.

## 9. The deterministic engines (`tools/bayesian/`)
These are the **only** place exact numbers come from. Call them when you need a defensible figure; otherwise
reason in bands. Each returns the numeric result **and** its band (`bands.py`):
- **`vulnerability_calculator.py`** — posterior P(vuln | alert) from prior + TPR + FPR, with a per-10k-host
  population projection (makes the base-rate trap concrete). *Useful to both sides* (red: real finding? blue: real
  alert?).
- **`exploit_chain_simulator.py`** *(red)* — conditional multi-stage path probability and how mitigations collapse
  downstream risk.
- **`blue_team_response_simulator.py`** *(blue)* — Bayesian triage + expected-utility isolate-vs-monitor decision.
- **Pipeline (optional).** A telemetry broker can feed *real* events — offensive tool output (Kali/Metasploit RPC)
  and defensive findings (AWS Security Hub / GuardDuty / Inspector ASFF, EDR/Syslog) — into these engines,
  correlating attack actions with detections in a time window to compute **empirical** P(detection | attack) for
  the purple-team loop.

## 10. Limits & honesty
- **Priors are subjective.** Tie every band to a stated base rate + reasoning; surface the assumption. Garbage
  prior → garbage posterior.
- **"Very High" ≠ certainty.** Keep the band; mark genuine unknowns as **unknown** — never fabricate confidence.
- **Independence is the silent killer.** Don't double-count correlated evidence (§5); prefer to *under*-claim.
- **Complexity.** Exact posteriors over an enterprise-scale attack graph are intractable; **bands everywhere +
  the deterministic tools on the critical paths** is the pragmatic, honest answer.

## Sources & influences
- Bayes' theorem; sequential (recursive) Bayesian updating.
- The **base-rate fallacy** (Kahneman & Tversky) — why accurate tools still flood you with false positives.
- **Bayesian Attack Graphs** and **Noisy-OR** gates for multi-path compromise modeling.
- **Expected-utility theory** for decision-making under uncertainty.
- **Neuro-symbolic AI** — LLM strategy + symbolic/probabilistic computation (this project's deterministic harness).
