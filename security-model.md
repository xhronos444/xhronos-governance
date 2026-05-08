# Security Model

## Core Principles

**Human review is mandatory for financial execution.**
No permit system, consensus result, or governance approval replaces the Architect's manual sign-off before any action that moves assets.

**No autonomous treasury access.**
The PayoutRouter and any asset-moving contracts are not directly connected to the governance pipeline in V1. Connection requires explicit, separate authorization.

**Permit replay protection.**
Every execution permit has a unique ID derived from `sha256(proposalId + agent + action + timestamp)`. Used permits cannot be reused.

**Permit expiration.**
All permits expire after 24 hours. Expired permits are rejected automatically.

**Consensus threshold.**
No single evaluator can authorize execution. 2 of 3 evaluators must return APPROVED.

**Architect-only contract authority.**
Only the Architect wallet (`0xe5CD007C19Ae5a046a8218ce9776fB1CC5FfB548`) can deploy contracts, bind nodes, and anchor canon entries.

## What This System Is Not

- Not an autonomous treasury
- Not a system that moves assets without human approval
- Not a black box — every decision is logged and auditable
- Not production-ready without further security audit

## Known Limitations in V1

- JSON file persistence is not suitable for concurrent access
- No authentication on the local API endpoints
- Permit consumption is not cryptographically signed
- Evaluator rules are simple and should be expanded before production use
