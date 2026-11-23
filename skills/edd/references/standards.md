# EDD standards baseline

Each agent applies the standards relevant to its stage. Cite them in artifacts where a decision depends on them.

## Requirements & quality
- **ISO/IEC/IEEE 29148** — requirements must be necessary, unambiguous, verifiable, traceable. Give each one an ID (FR-001, NFR-001).
- **ISO/IEC 25010** quality model — NFRs are grouped by: functional suitability, performance efficiency, compatibility,
  usability (interaction capability), reliability, security, maintainability, portability, safety.
- **INVEST** for user stories; **Gherkin (Given/When/Then)** for acceptance criteria.
- NFRs must be quantified (e.g. "p95 latency < 300 ms at 200 RPS", not "fast").

## Architecture
- **C4 model** (context, container, component) as Mermaid diagrams.
- **ADRs** (Michael Nygard format): context, decision, alternatives considered, consequences.
- **AWS / Azure / GCP Well-Architected** pillars as a review lens: operational excellence, security, reliability,
  performance, cost, sustainability.
- **12-Factor App** for services.

## Security & privacy
- **NIST SSDF (SP 800-218)** — secure development practices across the lifecycle.
- **OWASP ASVS 4.x/5.x** — pick level 1 (low risk), 2 (most apps; default), or 3 (high-value/regulated).
- **OWASP Top 10** (web), **OWASP API Security Top 10**, **OWASP Top 10 for LLM Applications**.
- **STRIDE** threat modelling per trust boundary.
- **GDPR** — lawful basis, data minimisation, DPIA when high risk, data subject rights, EU data residency.
- **EU AI Act** — classify the AI system (prohibited / high-risk / limited-risk transparency duties / minimal).
- **NIS2** and **DORA** — check if the client is in critical sectors or EU financial services.
- Supply chain: SBOM (CycloneDX/SPDX), dependency scanning, secret scanning, **SLSA** provenance as a target.

## Testing
- Test pyramid: many unit tests, fewer integration tests, few E2E tests. Each acceptance criterion maps to at least one test.
- Coverage is a signal, not a goal: target ≥ 80% on domain logic and test edge cases and failure paths.
- For AI features: offline eval set with pass thresholds, regression evals in CI, red-team prompts.

## Delivery & operations
- **DORA metrics** — deployment frequency, lead time, change failure rate, time to restore.
- Trunk-based development, conventional commits, semantic versioning, Keep a Changelog.
- **SRE**: SLIs/SLOs with error budgets; structured logs, metrics, traces (OpenTelemetry).
- **WCAG 2.2 AA** for any UI (also required under the European Accessibility Act from June 2025).
