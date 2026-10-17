# Changelog

All notable changes to this project are documented here. Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning: [SemVer](https://semver.org/).

## [1.0.0] - 2026-10-18
### Added
- `aidlc` skill: gated Inception → Construction → Operations lifecycle with adaptive depth (spike / feature / product).
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
