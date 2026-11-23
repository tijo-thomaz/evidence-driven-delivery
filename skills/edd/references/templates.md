# EDD artifact templates

## PRD (`inception/prd.md`)
```
# <Product> — PRD
## Problem & goals        (problem statement, measurable success metrics / KPIs)
## Users & personas
## Scope                  (in scope / out of scope / future)
## Functional requirements   FR-001 ... (MoSCoW priority)
## Non-functional requirements NFR-001 ... (ISO 25010 category, quantified target, how measured)
## Constraints & assumptions
## Risks
## Glossary
```

## User story (`inception/user-stories.md`)
```
### US-001 <title>   (Priority: Must | Traces: FR-001)
As a <persona>, I want <capability> so that <benefit>.
Acceptance criteria:
- Given <context> When <action> Then <outcome>
```

## ADR (`inception/adr/0001-<slug>.md`)
```
# ADR-0001: <decision>
Status: proposed | accepted | superseded by ADR-XXXX
Date:
## Context
## Decision
## Alternatives considered   (option, pros, cons, why rejected)
## Consequences              (positive, negative, follow-ups)
```

## Threat model (`inception/threat-model.md`)
```
## System & trust boundaries (data-flow diagram in Mermaid)
## Assets
## Threats   | ID | Boundary | STRIDE | Threat | Likelihood | Impact | Mitigation | Status |
## Security requirements (ASVS refs)
## Residual risks
```

## Unit of work (`inception/units/U-01-<slug>.md`)
```
# U-01 <name>
Stories: US-001, US-002     Depends on: —
Scope / out of scope
Interfaces (APIs, events, schemas)
Definition of Done: tests pass, review clean, docs updated, AC demoed
Estimate: S | M | L
```

## Review (`construction/<unit>/review.md`)
```
| # | Severity (blocker/major/minor/nit) | File:line | Finding | Recommendation | Status |
Verdict: approve | changes requested
```
