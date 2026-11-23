# Changelog

All notable changes to this project are documented here. Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning: [SemVer](https://semver.org/).

## [2.0.0] - 2026-11-23
### Changed
- **Renamed** the project from `claude-aidlc` / "AI-DLC" to **Evidence-Driven Delivery (EDD)**, so it has a distinct
  name of its own and is not confused with other products or methodologies.
- Plugin `aidlc` → `edd`; marketplace `claude-aidlc` → `evidence-driven-delivery`; skill and command `/aidlc` → `/edd`
  (plugin install: `/edd:edd`); agents `aidlc-*` → `edd-*`; project folder `aidlc-docs/` → `edd-docs/`.

### Migration
- Uninstall the old plugin (`claude plugin uninstall aidlc@claude-aidlc`), then install `edd@evidence-driven-delivery`.
- In existing projects, rename the `aidlc-docs/` folder to `edd-docs/` to keep your state and audit log.

## [1.0.0] - 2026-10-18
### Added
- `edd` skill: gated Inception → Construction → Operations lifecycle with adaptive depth (spike / feature / product).
- 19 specialist agents: orchestrator, product analyst, architect, codebase auditor, security architect, AI engineer,
  planner, test engineer, developer, code quality, scalability, robustness, reviewer, self-heal, RCA, spike,
  devops, release manager, context keeper.
- Phase gates PG1–PG6 and coding gates CG1–CG14 with per-stack tooling and a `gates.yml` template.
- Patterns catalogue (architecture, integration, data, scalability, resilience, self-healing, security, code,
  AI/LLM, testing), each with use-when / avoid-when.
- Standards baseline: ISO/IEC 25010 & 29148, C4, ADRs, OWASP ASVS / Top 10 / LLM Top 10, NIST SSDF, GDPR,
  EU AI Act, NIS2, DORA, WCAG 2.2, SRE/DORA metrics.
- Token-minimal project memory (`context.min.md`) maintained by the context keeper.
- Claude Code plugin + marketplace manifests; manual install scripts for Windows and macOS/Linux.
