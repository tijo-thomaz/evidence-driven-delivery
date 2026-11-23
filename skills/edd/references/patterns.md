# EDD patterns catalogue

**Rule:** A pattern is applied only when its *use when* condition is actually true in this project (YAGNI).
Every artifact or unit that applies a pattern records it in a `## Patterns used` section:
`<pattern> — <where> — <why here (link to the NFR/FR/threat)> — <trade-off accepted>`.
Architecture-level patterns also need an ADR. Reviewers flag missing patterns *and* patterns applied without a reason.

Format: **Pattern** — use when | avoid when.

## 1. Architecture styles (architect)
- **Modular monolith** — default; small team; domain still evolving | modules need independent scaling or deployment.
- **Hexagonal (ports & adapters) / Clean** — the domain logic is non-trivial and you need to swap infrastructure or test the domain in isolation | a thin CRUD app.
- **Layered (N-tier)** — simple CRUD with little domain logic | complex domain rules leak across layers.
- **Microservices** — independent teams, scaling or release cadence per domain, and the team is mature in ops | early stage, a single team, or unclear boundaries.
- **Event-driven** — async workflows, fan-out, decoupled producers and consumers | you need strong immediate consistency or a simple request/response.
- **Serverless** — spiky/low traffic, event triggers, small ops team | long-running work, steady high load, latency-critical cold starts.
- **CQRS** — read and write models or loads differ strongly | simple CRUD (doubles the complexity).
- **Event sourcing** — you need the audit history or temporal queries | the team is unfamiliar with it and there is no audit need.

## 2. Integration (architect, developer)
- **API gateway / BFF** — several clients or services that need cross-cutting auth/rate limiting, or responses tailored per client | a single client and a single service.
- **Anti-corruption layer** — integrating a legacy or third-party model you don't control | you own both sides.
- **Strangler fig** — incrementally replacing a legacy system | a greenfield project.
- **Transactional outbox** — you must update the DB *and* publish an event atomically | there are no events.
- **Saga (orchestration or choreography)** — a business transaction spans services or DBs and needs compensation | a single DB transaction is enough.
- **Idempotent consumer / idempotency key** — at-least-once delivery, retries, or payment-like operations | never avoid it on retryable writes.
- **Pub/sub, competing consumers** — fan-out, or parallel processing of work items | the steps must be strictly ordered and synchronous.

## 3. Data (architect, developer)
- **Repository** — isolate persistence from the domain | trivial scripts.
- **Unit of work** — several aggregate changes must commit together | single-row operations.
- **Optimistic locking (version column)** — concurrent edits where conflicts are rare | heavy contention (use queues or pessimistic locks).
- **Cache-aside / write-through / TTL** — read-heavy data that tolerates staleness | data that must be strongly consistent; also define the invalidation strategy.
- **Read replicas, materialised views** — read load or reporting queries | writes are the bottleneck.
- **Sharding / partitioning** — data or write volume exceeds a single node, with a clear partition key | before you have exhausted vertical scaling and indexing.
- **Audit trail / soft delete** — compliance or recovery needs | GDPR erasure applies (use crypto-shredding or a hard delete with an audit stub).
- **Cursor pagination** — large or growing lists | small fixed sets.

## 4. Scalability (scalability agent)
- **Stateless services + horizontal autoscaling** — variable load; keep sessions and state external.
- **Queue-based load levelling** — bursty writes or slow downstream systems | the user needs the result synchronously.
- **Backpressure / rate limiting / throttling** — protect shared resources and stop noisy neighbours.
- **CDN + edge caching** — static or cacheable content served to geographically spread users.
- **Batching, bulk APIs** — high-volume small operations.
- **Async request-reply (202 + status URL)** — operations longer than about 2 seconds.
- **Connection pooling** — any DB or HTTP client under load.
- **Partitioned consumers, priority queues** — mixed workloads with different SLOs.

## 5. Resilience / robustness (robustness agent)
- **Timeout on every remote call** — always; budget it from the end-to-end SLO (deadline propagation).
- **Retry with exponential backoff + jitter** — transient faults on *idempotent* operations | non-idempotent operations without an idempotency key.
- **Circuit breaker** — a dependency can fail or slow down and cascade | in-process calls.
- **Bulkhead** — isolate resource pools per dependency or tenant.
- **Fallback / graceful degradation** — a degraded answer is better than an error (cached data, a default, a feature turned off).
- **Dead-letter queue + replay** — async message processing.
- **Compensating transaction** — undo steps of a distributed workflow.
- **Input validation at boundaries, fail fast** — always; parse, don't validate (typed domain objects).
- **Result/Either types for expected failures** — business errors; reserve exceptions for exceptional cases.

## 6. Self-healing & deployment (self-heal, devops)
- **Liveness/readiness/startup probes** — for any orchestrated service; readiness must check dependencies, liveness must not.
- **Auto-restart / supervisor** — crash-only design for stateless processes.
- **Reconciliation loop** — make desired state equal actual state (Kubernetes operators, IaC drift fixes).
- **Auto-rollback on SLO burn / failed health check** — every production deploy.
- **Blue-green / canary / progressive delivery** — production releases with real user traffic.
- **Feature flags / kill switches** — risky features, gradual rollout, instant disable.
- **Leader election** — singleton jobs in a replicated deployment.

## 7. Security (security architect, developer)
- **Zero trust, least privilege** — always.
- **Gatekeeper / API gateway authz** — centralised policy at the edge, plus object-level authz in the service.
- **Valet key (pre-signed URLs)** — direct client upload or download to storage.
- **Secret manager + short-lived credentials (OIDC)** — always; no long-lived keys.
- **Output encoding / parameterised queries** — always.
- **Crypto-shredding** — erasure of personal data in immutable stores or backups.

## 8. Code-level (developer, code-quality)
- **Strategy** — interchangeable algorithms chosen at runtime | only one variant (use a plain function).
- **Factory** — creation logic is complex or depends on config | a simple `new`.
- **Adapter** — wrapping third-party or legacy APIs behind your own port.
- **Decorator / middleware** — cross-cutting concerns (logging, retry, caching, auth) on an interface.
- **Observer / domain events** — decouple side effects from the core action.
- **Builder / test data builder** — objects with many optional parts; test fixtures.
- **Chain of responsibility / pipeline** — ordered processing steps (validation, request handling).
- **Specification** — composable business rules or queries.
- **Value object, aggregate, entity (DDD)** — rich domains; enforce invariants in the type.
- **Dependency injection (constructor)** — always for testability; avoid service locators and mutable singletons.

**Anti-patterns to flag:** god class/function, primitive obsession, shotgun surgery, feature envy, deep inheritance,
mutable global state, speculative generality, magic numbers/strings, swallowed exceptions, boolean flag parameters,
temporal coupling, N+1 queries, chatty remote calls in loops.

## 9. AI / LLM (ai-engineer)
- **Structured output (JSON schema)** — any machine-consumed output.
- **Prompt chaining** — a task decomposes into fixed sequential steps.
- **Routing** — distinct input classes need different prompts or models (cheap model first).
- **Parallelisation (sectioning or voting)** — independent subtasks, or confidence by consensus.
- **Orchestrator–workers** — subtasks can't be predicted up front.
- **Evaluator–optimiser** — clear evaluation criteria where iterating improves output.
- **Autonomous agent with tools** — open-ended multi-step tasks; requires guardrails, budgets and human-in-the-loop for consequential actions | a fixed workflow would do the job.
- **RAG (hybrid search + re-rank)** — answers must be grounded in private or changing data | the data fits in context and is static (just include it).
- **Guardrail sandwich** — input filter → model → output validator.
- **Model cascade / fallback** — balance cost and quality; handle provider outages.
- **Semantic cache, prompt caching** — repeated queries or a large stable prefix.
- **Prompts as versioned code + eval-gated changes** — always.

## 10. Testing (test engineer)
- **Arrange–Act–Assert, one behaviour per test.**
- **Test data builders / object mothers** — complex fixtures.
- **Testcontainers** — integration tests against a real DB or broker.
- **Contract tests (Pact)** — consumer/provider APIs across teams or services.
- **Property-based tests** — parsers, serialisers, math, invariants.
- **Golden/snapshot tests** — stable rendered output, LLM eval baselines.
- **Fault injection / chaos tests** — verifying resilience patterns (robustness agent).
- **Load tests (k6/Gatling/Locust)** — verifying scalability NFRs (scalability agent).
