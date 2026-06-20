# The Strategy of Adversarial Co-Evolution
### What Determines Victory When Both Sides Know the Playbook — Doctrine for AI-Augmented Red and Blue Operations

*A shared strategic foundation for [Agentic Redteam](https://github.com/ShadNygren/agentic-redteam) (offense)
and [Agentic Blueteam](https://github.com/ShadNygren/agentic-blueteam) (defense). This document is identical in
both projects by design: each side should understand the other's tactics and strategy as completely as public
frameworks allow. It is a **living document** — see §12.*

> *"Iron sharpens iron, and one man sharpens another."* — Proverbs 27:17
>
> *"Shall we play a game?"* — WOPR / Joshua, **WarGames** (1983). The machine learned the futility of an
> unwinnable war by **playing itself, thousands of times, at machine speed.** That is the whole idea: play the
> safe game so you never have to play the real one unprepared.

---

## Abstract
Sun Tzu wrote that one who knows the enemy and knows himself need not fear the result of a hundred battles. The
modern security profession has operationalized exactly that knowledge: **MITRE ATT&CK** catalogs what attackers
do, **MITRE D3FEND** catalogs what defenders do, and the **digital-artifact ontology** binds them into a single
shared map. But this creates a paradox at the edge of Sun Tzu's maxim: *if both sides have mastered the same
public knowledge, the information advantage cancels — so what then decides the outcome?* This paper argues that
**knowledge is the floor, not the ceiling.** When the maps are symmetric, victory is determined by the classical
factors Sun Tzu and later strategists wrote about — **structural asymmetry, tempo, terrain, deception, force, and
discipline** — and, above all, by **adaptation velocity**: the rate at which each side learns and changes. The
deepest implication for authorized red/blue work is that it is **positive-sum**: the engagement is sparring, the
real battles are fought later against a third party, and the side that learns fastest makes the *organization*
win. We close with the operating commitment that follows: continuously ingest emerging tactics so the model never
goes stale.

---

## 1. The premise and its limit
"Know your enemy and know yourself, and you need not fear a hundred battles. Know yourself but not the enemy, and
for every victory you will suffer a defeat. Know neither, and you will lose every battle." (*The Art of War*,
III.) The maxim is about **ignorance as a cause of defeat**. Removing ignorance moves you from the losing column
to the even column — it is the **price of entry to the battlefield**, not the price of victory.

Cybersecurity has, uniquely among conflicts, made that knowledge *cheap and public*. Anyone can read ATT&CK,
D3FEND, CAR, CAPEC, CWE, the kill-chain models, the threat-intel reporting, and the academic literature. So we
must ask the question that begins where Sun Tzu's maxim ends: **when both sides have paid the price of entry —
both know themselves, both know the other — what determines who prevails?** The remaining chapters of *The Art of
War* (terrain, maneuver, deception, force, the indirect approach) are the answer, and they map cleanly onto
offensive and defensive operations.

## 2. Knowledge as the shared map (and why it equalizes)
ATT&CK is the attacker's dictionary; D3FEND is the defender's; **digital artifacts** are the Rosetta Stone
between them. Every offensive technique *produces or consumes* artifacts (a process spawn, a network connection,
a modified code segment, a registry key); every defensive technique *observes or acts on* the same artifacts.
When both sides internalize this map:
- The red team can predict, for any technique it runs, which artifacts it generates and therefore which D3FEND
  countermeasures might catch it.
- The blue team can predict, for any technique an actor uses, which artifacts to collect and which detections to
  build.

This is the symmetric-knowledge condition. Sun Tzu's information edge is now **zero** — neither side is surprised
by the *existence* of a technique or a countermeasure. The contest moves up a level, from *knowing* to *doing*.

## 3. The structural asymmetry (the game is uneven even when the knowledge is even)
The single most important fact about attack and defense is that **the game is not symmetric**, regardless of
knowledge:
- **The attacker needs one path; the defender must hold all of them.** This is the **Defender's Dilemma**. The
  attacker can fail ninety-nine times and win on the hundredth; the defender must succeed every time, everywhere.
- **Cost asymmetry.** A single exposed service, one unpatched host, one reused credential is enough. Equal
  knowledge does not equalize this — it just means both sides *understand* the asymmetry.
- **But the asymmetry cuts back toward defense over time and scale.** The attacker leaves an artifact at *every
  step* of the kill chain — initial access, C2, discovery, lateral movement, exfil. Defense-in-depth means the
  attacker must evade detection *repeatedly*, while the defender needs to catch them *once*. The **Pyramid of
  Pain** (Bianco) formalizes this: detections on behavior/TTPs cost the attacker far more to evade than atomic
  indicators. So the structural game favors the attacker in any single engagement and the defender across a
  campaign. **Knowing the playbook lets each side play its side of this asymmetry well; it does not remove it.**

## 4. Tempo and initiative (the OODA loop)
When both sides see the same board, **the faster decision loop wins.** John Boyd's **OODA loop** (Observe →
Orient → Decide → Act) is the engine: the side that cycles faster operates *inside* the other's loop, acting
before the other can react. In security this is measured directly:
- **Attacker dwell time** vs. defender **MTTD/MTTR** (mean time to detect / respond). The attacker's whole
  campaign is an effort to complete its OODA loop (to the objective) before the defender completes theirs (to
  eviction).
- **Initiative.** The attacker chooses the time, place, and vector — a real edge even under symmetric knowledge.
  The defender *seizes initiative back* by **threat hunting** (assume-breach: go find them rather than waiting for
  an alert) and by **deception** (force the attacker to react to a board the defender controls).

Equal knowledge, unequal tempo → the faster side dominates. This is why both projects optimize for speed of
detection, response, and the purple-team learning cycle.

## 5. Terrain and position (shape the ground before contact)
Sun Tzu devotes whole chapters to terrain because **position is decided before the battle.** The defender is the
*home team* and shapes the ground in advance:
- **Hardening** (D3FEND *Harden*) raises the cost of *known* techniques — ASLR/DEP/CFG against exploitation, MFA
  against credential abuse, segmentation against lateral movement. Equal knowledge of a technique does not help
  the attacker if the terrain has made it expensive or unreliable.
- **Choke points and visibility** — funnel the adversary through instrumented ground (the network's "high
  ground"), reduce the attack surface to what you can watch.
- **Supply lines** — the attacker's C2/egress is their supply line; constraining it (egress filtering, proxy
  inspection) is attacking their logistics. The red team in turn invests in resilient infrastructure (redirectors,
  channel diversity) precisely because the defender shapes this terrain.

Two equally-knowledgeable forces on unequal ground: the prepared one wins. **Preparation is a force multiplier
that knowledge alone cannot match.**

## 6. Deception (re-breaking the symmetry on purpose)
"All warfare is based on deception." (*The Art of War*, I.) This is the decisive move *specifically* in the
symmetric-knowledge case: **if both sides know each other, you win by making the other's knowledge false.**
- **Blue** deploys **D3FEND *Deceive*** — honeytokens, honeypots, decoy credentials, decoy systems. A touch on a
  honeytoken is near-zero-false-positive: it converts the attacker's own reconnaissance into the defender's
  highest-fidelity signal. Deception makes the attacker's map of the environment *wrong*.
- **Red** uses misdirection within the Rules of Engagement — redirectors and infrastructure that obscure
  attribution, decoy activity, and timing that defeats the defender's model of "normal." It makes the defender's
  map of the *attacker* wrong.

Deception is how a strategist escapes a symmetric standoff: you do not out-know the opponent, you **corrupt what
they know.** Both sides must therefore understand the other's deception repertoire — to deploy it, and to detect
it.

## 7. Force, economy, and endurance
When knowledge and even position are matched, **mass and endurance** matter. The "**A**dvanced **P**ersistent
**T**hreat" is defined as much by *persistent* and *resourced* as by *advanced* — nation-state and large-criminal
actors win wars of attrition that an under-resourced defender cannot sustain. The classical principles apply
directly:
- **Economy of force / concentration** — neither side can be strong everywhere; concentrate at the decisive
  point. For blue, that means **risk-based prioritization** (defend the crown jewels first; risk ≈ threat ×
  vulnerability × likelihood × impact). For red, it means driving at the **highest-value objective** rather than
  spreading thin.
- **The culminating point** (Clausewitz) — every offensive has a point beyond which it overextends; every defense
  has a point beyond which it exhausts. Recognizing your own and the opponent's culminating point is a
  knowledge-independent strategic skill.

## 8. The decisive variable: adaptation velocity
Here the premise quietly breaks. **The knowledge is never actually static-symmetric.** It is a *co-evolving*
system: every new attack technique invites a new countermeasure, which invites a new evasion, which invites a new
detection — a perpetual arms race. This is the **Red Queen effect** (Van Valen): both sides must run as fast as
they can *just to stay in the same place.* Therefore:

> **The side that learns and changes faster breaks every momentary symmetry on the very next round.**

Adaptation velocity is the OODA loop at the *program* level — not "how fast do I act in this incident?" but "how
fast does my whole capability *evolve*?" It is the true tiebreaker, and it is why both ATT&CK/D3FEND and both of
these projects treat **continuous improvement as doctrine, not decoration**:
- Red emulates **fresh** TTPs each engagement so the blue team faces an evolving adversary.
- Blue closes the **detection gaps** each round and re-validates, so coverage compounds.
- The **purple-team loop** (emulate → detect → measure the gap → engineer the detection → re-emulate) is, in
  strategic terms, a machine for maximizing *joint* adaptation velocity.

Whoever institutionalizes the faster learning loop wins the long war, even starting from parity.

### 8.1 Adversarial self-play: the learning engine (the WarGames lesson)
There is a proven way to *manufacture* adaptation velocity: **adversarial self-play.** Pit the two sides against
each other, over and over, and harvest the result of every round to improve both. It is the oldest idea in
training (sparring — *iron sharpens iron*) and the newest in machine learning:
- In **WarGames** (1983), the WOPR/Joshua learns the futility of an unwinnable war by **playing itself thousands
  of times at machine speed** until the lesson is unmistakable. The famous conclusion — *"the only winning move
  is not to play"* — is about the **real** war (don't fight the live one rashly). The **game** you absolutely
  *should* play is the safe simulation, precisely so the real one is already decided.
- **AlphaZero** reached superhuman play with *no* human games — purely by self-play, generating its own
  ever-harder opponents. **GANs** (generative adversarial networks) train a generator and a discriminator against
  each other until both are excellent. The pattern is identical: **two adversaries co-evolving produce capability
  neither could reach alone.**
- This is the **agentic** thesis of these two projects. Autonomous red and blue agents — each grounded in the
  public frameworks, each constrained by the deterministic harness and human-in-the-loop gates — can run the
  red/blue game **safely, repeatedly, and fast**, closing detection gaps and exercising evasions far quicker than
  a once-a-year human engagement. The bottleneck on adaptation velocity is how cheaply and safely you can run the
  next game; agentic self-play attacks exactly that bottleneck. **The faster the safe game spins, the faster the
  whole organization sharpens.**

## 9. Discipline and the unforced error
When both sides know the playbook, victory often goes not to the most brilliant move but to the **fewest
mistakes.** Symmetric knowledge raises the floor, so the variance that decides outcomes shifts to *execution
quality*:
- **Red** loses to OPSEC lapses — a noisy tool, a forgotten artifact, a reused indicator, an action outside the
  emulated actor's profile.
- **Blue** loses to alert fatigue, miscorrelation, a missing log source, a slow or absent response to an alert
  that *did* fire.

Both projects therefore enforce **discipline as a control**: tool-evidenced findings (no fabrication), the
operator log / incident timeline, high-fidelity alerting over noise, the human-in-the-loop gate, and a
**blameless** improvement culture that surfaces honest input. The disciplined side compounds small advantages
into decisive ones.

## 10. The positive-sum reframe (why this isn't really a duel)
The most important strategic truth for *these* projects: **red vs. blue is not the war — it is the training.**
The agentic-redteam and agentic-blueteam relationship is *sparring*, and it is **positive-sum**:
- The genuine adversary is a **third party** — the real, unknown APT the organization will face *in production*,
  later, without warning.
- When both sparring partners know themselves and each other as fully as the public record allows, the
  organization buys **certainty about its own readiness cheaply**, in the exercise, instead of expensively, in a
  breach.
- Sun Tzu's "hundred battles" are fought in production; the red/blue exercise is where you make their outcome a
  foregone conclusion. The win condition is not "red beats blue" or "blue beats red" — it is **a measurably
  stronger organization** when the real attacker arrives.
- **Iron sharpens iron.** Each side exists to make the other better; the friction *is* the product. The only
  truly **losing** move is to meet the real adversary having never sparred — to "play" the live war (WarGames §8.1)
  with no practice. So: *shall we play a game?* Yes — the safe one, on a loop, until readiness is no longer in
  doubt.

This is why both projects are built on the *same* deterministic-harness, ATT&CK-anchored, human-in-the-loop
foundation, and why this strategy document is **shared verbatim** between them. They are two halves of one
learning system.

## 11. Implications for these projects (how the doctrine becomes practice)
- **Each side models the other from public frameworks.** Red studies D3FEND (the defender's countermeasures, the
  artifact lens, deception); blue studies ATT&CK (the adversary's TTPs, the kill chain, threat-actor emulation).
  Neither is blind to the other's strategy.
- **The artifact ontology is the shared coordinate system.** Plan and report in ATT&CK *and* D3FEND terms so red
  findings and blue coverage line up on the same map.
- **Optimize tempo and the learning loop, not just coverage.** Track MTTD/MTTR and *gap-closure rate across
  rounds*, not only a point-in-time matrix.
- **Invest in terrain and deception**, the two levers that beat symmetric knowledge.
- **Compete on discipline** — fewer unforced errors, honest evidence, fast honest improvement.

## 12. Living-document commitment (the model must never go stale)
Adaptation velocity (§8) is only real if the knowledge base actually moves. New attacks are devised continuously,
and defense must evolve in lockstep. These projects therefore commit to **continuously monitoring cybersecurity
developments and integrating new tactics and countermeasures as they emerge**, including:
- **Framework updates** — new ATT&CK and D3FEND versions, CAR analytics, CAPEC/CWE entries.
- **Threat intelligence & advisories** — CISA/NSA/FBI joint advisories, vendor and community CTI, fresh
  threat-actor TTPs and tooling.
- **Emerging attack surfaces** — e.g. AI/LLM systems (prompt injection, model data exfil, shadow AI) on offense,
  and AI-incident detection/handling on defense.
- **Research** — academic and practitioner publications, novel evasions and detections.

Each side integrates the *other's* advances too: when a new offensive technique is documented, blue adds the
detection; when a new countermeasure is documented, red adds the evasion test. The two repositories evolve
**together**, as a coupled system. Knowledge is the floor; this commitment is how we keep raising the ceiling.

---

## Sources & influences (public)
- Sun Tzu, *The Art of War* (knowledge, terrain, deception, the indirect approach).
- John Boyd, the **OODA loop** (tempo and decision superiority).
- Carl von Clausewitz, *On War* (friction, the culminating point, economy of force).
- Leigh Van Valen, the **Red Queen hypothesis** (co-evolutionary arms races).
- Lockheed Martin, the **Cyber Kill Chain**; the **Unified Kill Chain**.
- MITRE **ATT&CK**, **D3FEND**, **CAR** (Cyber Analytics Repository), **CAPEC**, **CWE**.
- David J. Bianco, the **Pyramid of Pain**.
- The **Defender's Dilemma** (industry doctrine).
- NIST **CSF 2.0** and **SP 800-61** (incident response as risk management).
- MITRE **Atomic Red Team** and the **purple-team** discipline.
- **Adversarial self-play** — *WarGames* (1983); DeepMind **AlphaZero**; **GANs** (Goodfellow et al.) — two
  adversaries co-evolving as a learning engine.
- *"Iron sharpens iron"* — Proverbs 27:17.
