# XHRONOS Architecture

## Overview

XHRONOS is a governance middleware prototype for autonomous AI agents. It provides a deterministic authorization pipeline that sits between an AI agent's requests and infrastructure execution.

## Components

### On-Chain (Base Mainnet)

**ChainOfSaturn0** — `0x8Dc82ae02662Db0cE750882CA51f05A26391EA8c`
The immutable protocol record. An append-only canon of 18 governance entries. Deployed and permanently anchored on Base Mainnet.

**XhronosNodeRegistry** — `0xf1Deb206aE4bCcf0437aA0c2ADe106eCD88888a3`
Maps wallet addresses to governance roles and layers.

**XHRONOSProposalRegistryV4** — `0x18B3E7c44C312D35CD75d44c13046eA82B30C010`
Accepts and tracks structured governance proposals on-chain.

**XhronosLoopDecision** — `0x0a5A0fA880Ad04c3cD0D52eBeD073958f953eC2A`
Autonomous loop contract. Executes every 3600 seconds. Emits ValidState or InvalidState signals.

### Off-Chain (Node.js)

| Component | File | Purpose |
|---|---|---|
| Policy Evaluator | `policy-evaluator-v1.cjs` | Applies deterministic governance rules to proposals |
| Consensus Layer | `consensus-layer-v1.cjs` | Runs 3 evaluators, applies 2/3 threshold |
| Execution Binding | `execution-binding-v1.cjs` | Records authorized proposals |
| State Manager | `governance-state-manager-v1.cjs` | Unified lifecycle tracking |
| Governance API | `governance-api.cjs` | REST API + Explorer on port 3000 |
| Execution Permit | `execution-permit-v1.cjs` | Issues and validates execution permits on port 3001 |

## Security Model

- No autonomous asset movement. Permits authorize actions — humans execute them.
- No permit without 2/3 consensus.
- Replay protection on all permits.
- 24-hour permit expiration.
- Architect wallet is the sole authority for contract operations.
