# EDD quality gates

A gate is a **pass/fail check backed by evidence** (command output, a report file). A gate never passes on an
agent's opinion alone. Failed gates trigger the self-heal → RCA → human escalation loop described at the bottom.

Project-specific commands and thresholds live in `edd-docs/gates.yml` (template at the end). The
`edd-code-quality` agent creates it during the walking-skeleton unit (U-01) and keeps it current.

## Phase gates (human approval required)
| Gate | After stage | Pass criteria |
|------|-------------|---------------|
| PG1 Requirements | 1.1 | Every FR is covered by stories; every Must story has Given/When/Then; every NFR is quantified and measurable |
| PG2 Design | 1.2–1.4 | C4 views and ADRs exist; every NFR maps to a tactic or pattern; scalability and resilience reviews have no open blockers |
| PG3 Security | 1.3 | STRIDE is done for every boundary; ASVS level is set; compliance applicability is decided |
| PG4 Plan | 1.5 | Every Must story and every SEC requirement is in exactly one unit; dependency graph is acyclic |
| PG5 Unit done | 2.x | All coding gates are green, the review is approved, and the user signs off |
| PG6 Release | 3.2 | Release checklist is all PASS or has recorded waivers |

## Coding gates (automated, run for every unit before review)
| Gate | Check | Threshold (default; override in gates.yml with an ADR) |
|------|-------|----------------------------------------------------------|
| CG1 Build | Clean build from lockfile | Succeeds; reproducible |
| CG2 Format & lint | Formatter + linter | 0 errors; 0 **new** warnings |
| CG3 Types | Strict type-check | 0 errors (strict mode on new code) |
| CG4 Tests | Full suite | 100% pass; no skipped tests without a linked issue; no flaky tests (3 consecutive runs) |
| CG5 Coverage | Line + branch + diff coverage | Changed code: diff coverage ≥ 80%, branch ≥ 70%; domain core line coverage ≥ 85% |
| CG6 Mutation (product type only) | Mutation testing on domain core | Score ≥ 60% |
| CG7 Complexity | Per function | Cyclomatic ≤ 10 (hard max 15), cognitive ≤ 15, ≤ 50 lines, ≤ 4 params, nesting ≤ 3; file ≤ 400 lines |
| CG8 Duplication | Copy/paste detection | ≤ 3% on new code; no duplicated block > 10 lines |
| CG9 Architecture | Dependency rules | No import cycles; layer/module direction respected (domain must not import infrastructure) |
| CG10 Security | SAST, dependency scan, secret scan, licences | 0 critical/high SAST findings; 0 critical/high CVEs that have a fix available; 0 secrets; only allowed licences |
| CG11 Robustness | Static + test evidence | Every external call has a timeout; retries are only on idempotent operations; error paths are tested; no swallowed exceptions |
| CG12 Performance (hot-path units) | Perf smoke / query analysis | p95 within the NFR budget at target load; no N+1 queries; no unbounded queries or loops over I/O |
| CG13 AI evals (AI units) | Eval suite | Pass rate ≥ the threshold in ai-design.md; no metric regresses by more than 2 points vs baseline |
| CG14 Docs | Diff check | Public APIs documented; affected ADRs updated; CHANGELOG entry added |

## Tooling by stack
| Stack | Lint/format | Types | Tests/coverage | Complexity/dup | Architecture | Security | Mutation |
|-------|-------------|-------|----------------|----------------|--------------|----------|----------|
| Python | ruff, ruff format | mypy --strict / pyright | pytest, pytest-cov, diff-cover | radon/xenon, jscpd | import-linter | bandit, semgrep, pip-audit | mutmut |
| TypeScript/JS | eslint (+sonarjs), prettier | tsc --strict | vitest/jest --coverage, diff-cover | eslint complexity rules, jscpd | dependency-cruiser | semgrep, npm audit / osv-scanner | Stryker |
| Java/Kotlin | spotless, checkstyle, PMD | compiler | JUnit 5, JaCoCo | PMD, CPD | ArchUnit | SpotBugs+FindSecBugs, OWASP dependency-check | PIT |
| .NET | dotnet format, analyzers | nullable enable | xUnit, coverlet | analyzers, jscpd | NetArchTest | security-code-scan, dotnet list package --vulnerable | Stryker.NET |
| Go | gofmt, golangci-lint | compiler | go test -cover | gocyclo, dupl (via golangci-lint) | go-arch-lint | gosec, govulncheck | go-mutesting |
| All stacks | | | | | | gitleaks, trivy, syft (SBOM) | |

A SonarQube/SonarCloud quality gate with the same thresholds is an acceptable substitute for CG5–CG8.

## Failure handling loop
1. A gate fails → `edd-self-heal` fixes it, with at most **3 attempts** per gate. It may not loosen thresholds,
   skip or delete tests, or add ignore/suppress comments without stating the reason.
2. Still failing, or the same gate failed in 2 different units → `edd-rca` runs a root-cause analysis and proposes
   a systemic fix (code, design, gate config or process).
3. The RCA fix needs a design change or a threshold change → escalate to the user. A waiver is recorded in
   `audit.md` with an owner and an expiry date.

## gates.yml template
```yaml
stack: typescript            # python | typescript | java | dotnet | go
work_type: product           # spike | feature | product (spike runs CG1, CG2, CG4 only)
gates:
  CG1_build:        { cmd: "npm ci && npm run build" }
  CG2_lint:         { cmd: "npm run lint && npx prettier --check ." }
  CG3_types:        { cmd: "npx tsc --noEmit" }
  CG4_tests:        { cmd: "npx vitest run", repeat: 3 }
  CG5_coverage:     { cmd: "npx vitest run --coverage", diff_min: 80, branch_min: 70 }
  CG6_mutation:     { cmd: "npx stryker run", min: 60, scope: "src/domain" }
  CG7_complexity:   { cmd: "npx eslint . --rule 'complexity:[error,10]'" }
  CG8_duplication:  { cmd: "npx jscpd src --threshold 3" }
  CG9_architecture: { cmd: "npx depcruise src --validate" }
  CG10_security:    { cmd: "npx semgrep --config auto --error && npx osv-scanner -r . && gitleaks detect" }
  CG11_robustness:  { review: edd-robustness }
  CG12_performance: { cmd: "k6 run perf/smoke.js", p95_ms: 300, applies_to: [U-03] }
  CG13_ai_evals:    { cmd: "npm run evals", min_pass: 0.9 }
  CG14_docs:        { review: edd-code-quality }
waivers: []   # { gate, unit, reason, owner, expires, audit_ref }
```
