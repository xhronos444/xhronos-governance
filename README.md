# XHRONOS — AI Governance Middleware

**Network:** Base Mainnet  
**Canon Contract:** `0x8Dc82ae02662Db0cE750882CA51f05A26391EA8c`  
**Node Registry:** `0xf1Deb206aE4bCcf0437aA0c2ADe106eCD88888a3`  

---

## What is XHRONOS?

XHRONOS is a governance middleware layer for autonomous AI agents.

It solves a specific problem: **how do you let AI agents request infrastructure actions without giving them uncontrolled authority?**

The answer: every agent action must pass through a deterministic governance pipeline before execution is authorized. A human remains in the loop for any action that moves real assets.

---

## The Core Idea

```
AI Agent
  → submits proposal
  → XHRONOS evaluates (deterministic rules)
  → consensus forms (2 of 3 evaluators)
  → execution permit generated
  → human reviews
  → action executed
```

No agent can bypass this pipeline. No execution happens without a valid permit. No permit is issued without consensus.

---

## What Is Already Built

### On-Chain (Base Mainnet)

**ChainOfSaturn0** — `0x8Dc82ae02662Db0cE750882CA51f05A26391EA8c`  
Immutable append-only canon. 18 blocks recorded. The permanent protocol record.

**XhronosNodeRegistry** — `0xf1Deb206aE4bCcf0437aA0c2ADe106eCD88888a3`  
Registered nodes:
- Nexus Execution Node — `0x8ea888...` (Layer 1)
- GPT Node Proxy — `0x735DCA...` (Layer 1)
- Claude Node Proxy — `0xb82010...` (Layer 2)

**XHRONOSProposalRegistryV4** — `0x18B3E7...`  
Existing proposal substrate. Accepts structured governance proposals on-chain.

**XhronosLoopDecision** — `0x0a5A0f...`  
Autonomous loop contract. Executes cycle() every 3600 seconds. Emits ValidState/InvalidState signals.

### Off-Chain (Node.js)

| File | Purpose |
|---|---|
| `policy-evaluator-v1.cjs` | Evaluates proposal against governance rules |
| `consensus-layer-v1.cjs` | Runs 3 evaluators, applies 2/3 threshold |
| `execution-binding-v1.cjs` | Marks approved proposals as EXECUTED |
| `governance-state-manager-v1.cjs` | Unified lifecycle state tracking |
| `governance-api.cjs` | REST API + Explorer (localhost:3000) |
| `execution-permit-v1.cjs` | Generates and validates execution permits |

---

## Running a Proposal Through the Pipeline

**Step 1 — Evaluate**
```bash
node policy-evaluator-v1.cjs 0xPROPOSAL_ID
```

**Step 2 — Consensus**
```bash
node consensus-layer-v1.cjs 0xPROPOSAL_ID
```

**Step 3 — Execution Binding**
```bash
node execution-binding-v1.cjs 0xPROPOSAL_ID
```

**Step 4 — Sync State**
```bash
node governance-state-manager-v1.cjs sync 0xPROPOSAL_ID
```

**Step 5 — Generate Permit**
```bash
POST http://localhost:3001/permit/generate
{
  "proposalId": "0x...",
  "agent": "0x...",
  "action": "PAYOUT_EXECUTION"
}
```

**Step 6 — Human Review**  
Check the Explorer at `http://localhost:3000`.  
Verify the permit at `GET http://localhost:3001/permit/:id`.  
If approved — consume the permit manually.

---

## Security Boundaries

- **No autonomous ETH movement.** Permits authorize actions. Humans execute them.
- **No permit without consensus.** The system rejects any permit request without a valid 2/3 consensus.
- **Replay protection.** Each permit is unique. Used permits cannot be reused.
- **Expiration.** Permits expire after 24 hours.
- **Architect control.** Only the Architect wallet can bind nodes, anchor canon, and deploy contracts.

---

## Evaluator Logic

Three independent evaluators run on every proposal:

| Evaluator | Focus | Logic |
|---|---|---|
| A — Whitelist | Creator authorization | Is the proposer whitelisted? |
| B — Policy | Strict compliance | FINALIZED + non-null hash + deadline check |
| C — Risk | Execution safety | Rejects VETOED/EXPIRED immediately |

**Consensus threshold: 2 of 3 APPROVED → EXECUTE**

---

## What This Is Not

- Not an autonomous treasury
- Not an unrestricted AI authority layer
- Not a system that moves assets without human approval
- Not a black box — every decision is logged and auditable

---

## Three-Month Target

A working AI-agent governance demonstration that any engineer can immediately understand:

> "This solves a real coordination and authorization problem for autonomous agents."

**FIAT ORDO — Flamma. Ordo. Systema.**
