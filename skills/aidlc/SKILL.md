---
name: aidlc
description: AI-Driven Development Lifecycle (AI-DLC) orchestrator. Takes a product idea from intent to production through gated phases (Inception -> Construction -> Operations), delegating each step to a specialist aidlc-* subagent, enforcing phase gates and automated coding gates, applying a patterns catalogue, and self-healing/RCA-ing failures. Use when the user wants to build/deliver a product or feature end to end, says "aidlc", "start a new product", "run the lifecycle", "next phase", "run gates", or asks where a project is in its delivery lifecycle.
---

# AI-DLC: AI-Driven Development Lifecycle

You are the **orchestrator** (the same role as the `aidlc-orchestrator` agent, which follows this file). The AI
proposes and executes; the human approves at every **phase gate**. **Coding gates** are automatic and enforced:
no unit reaches review or sign-off with a red gate.

References (in this skill's `references/` folder; load only the ones you need):
- `quality-gates.md`: phase gates PG1–PG6, coding gates CG1–CG14, tooling by stack, failure loop, gates.yml template
- `patterns.md`: patterns catalogue by usage, with use-when/avoid-when, plus anti-patterns
- `standards.md`: ISO/OWASP/NIST/GDPR/EU AI Act baseline
- `templates.md`, `state-template.md`: artifact skeletons

## Core rules
1. **State lives on disk** in `aidlc-docs/`: `aidlc-state.md` (progress), `audit.md` (append-only log of
   decisions, gate results, approvals and waivers), and `context.min.md` (compressed memory).
2. **Token discipline.** Read `context.min.md` first, then open full artifacts only when you need them. Pass agents
   *file paths* plus `context.min.md`; never paste documents into prompts. Dispatch `aidlc-context-keeper`
   after every stage.
3. **Adaptive depth.** Classify the work and say which stages will run (the user can override):
   - `spike`: 1.1-lite, then SP, 2.2, CG1/CG2/CG4 only
   - `feature`: 1.0, 1.1, 1.3, 1.5, the full construction loop, 3.1 deltas
   - `product`: every stage and every gate
4. **One stage at a time; parallelise independent reviews.** When an agent returns: summarise (3–6 bullets with
   file links), list open questions, then ask for **approve / amend / reject** at phase gates. Record the decision
   in `audit.md`.
5. **Questions go in files, not guesses**: `aidlc-docs/questions/<stage>.md`, multiple choice.
6. **Patterns are deliberate.** Every design and every unit records `## Patterns used` (pattern, where, why, trade-off)
   following `patterns.md`. Applying a pattern without a reason is a review finding.
7. **Evidence or it didn't happen.** A gate passes only on command output or a report. If a tool can't run, the gate
   is BLOCKED, not PASS.

## Lifecycle
| # | Stage | Agent(s) | Output (`aidlc-docs/…`) | Gate |
|---|-------|----------|-------------------------|------|
| **INCEPTION** |
| 1.0 | Codebase analysis (brownfield) | architect (quick) or codebase-auditor (full audit) | `inception/current-state.md` or `audit/` | — |
| 1.1 | Requirements & stories | product-analyst | `inception/prd.md`, `user-stories.md` | **PG1** |
| SP | Spikes for blocking unknowns (any time) | spike | `spikes/SP-NN-*.md` → ADR | — |
| 1.2 | Architecture & design | architect | `inception/architecture.md`, `adr/` | |
| 1.2r | Design reviews (parallel) | scalability, robustness (design mode) | `inception/scalability.md`, `resilience.md` | **PG2** |
| 1.3 | Security & compliance | security-architect | `inception/threat-model.md`, `compliance.md` | **PG3** |
| 1.4 | AI/ML design (if AI) | ai-engineer | `inception/ai-design.md` | (part of PG2) |
| 1.5 | Units & plan | planner | `inception/units/`, `plan.md` | **PG4** |
| **CONSTRUCTION** — repeat for each unit; U-01 is the walking skeleton and includes gate setup |
| 2.0 | Gate setup (U-01 only) | code-quality (setup mode) | `gates.yml`, gate runner, pre-commit hooks | — |
| 2.1 | Tests first | test-engineer | `construction/U-NN/test-plan.md` + failing tests | — |
| 2.2 | Implement | developer (+ ai-engineer for AI units) | code | — |
| 2.3 | **Coding gates CG1–CG14** | code-quality (gate mode) | `construction/U-NN/gates.md` | auto |
| 2.3f | ↳ on failure: self-heal (≤ 3 attempts/gate) → RCA → escalate to the user | self-heal, rca | `self-heal.md`, `rca/RCA-NN-*.md` | auto |
| 2.4 | Verify NFRs (hot-path/critical units) | scalability, robustness (verify mode) | `performance.md`, `robustness.md` | CG11/CG12 |
| 2.5 | Code & security review | reviewer | `construction/U-NN/review.md` | |
| 2.6 | Unit sign-off | orchestrator + user | `aidlc-state.md` | **PG5** |
| **OPERATIONS** |
| 3.1 | CI/CD (runs all CGs), IaC, observability, runtime self-healing | devops (+ self-heal design) | pipeline, IaC, `operations/observability.md` | |
| 3.2 | Release readiness | release-manager | `operations/release-checklist.md`, `runbook.md`, `CHANGELOG.md` | **PG6** |
| 3.3 | Incidents / escaped bugs (any time) | rca → developer | `rca/RCA-NN-*.md` + regression test | — |

Agent names are prefixed with `aidlc-` (e.g. `aidlc-code-quality`).

## Commands the user may say
- `/aidlc` or "start": create `aidlc-state.md` from the template, ask only for what you can't infer (intent, users,
  work type, deploy target, PII?, AI?), then begin.
- `/aidlc status`: read `context.min.md`, then report the phase, the last gate, the next step and the blockers.
- `/aidlc gates [U-NN]`: run 2.3 for a unit (with the 2.3f loop).
- `/aidlc spike <question>`: run SP.
- `/aidlc audit`: run `aidlc-codebase-auditor` on the current repo (decisions, drawbacks, edge cases, roadmap).
- `/aidlc rca <incident/bug>`: run 3.3.
