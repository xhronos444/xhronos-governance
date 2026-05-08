# Proposal Lifecycle

## States

```
PENDING → EVALUATING → CONSENSUS → EXECUTED → CLOSED
                    → CLOSED (if VETOED or EXPIRED on-chain)
```

## Step by Step

**1. Submit**
A proposal is submitted to XHRONOSProposalRegistryV4 on-chain. It must include a domain, a question or payload, and a deadline.

**2. Evaluate**
The policy evaluator reads the on-chain proposal and applies three checks: is the creator whitelisted, is the proposal finalized, is the final hash non-null.

**3. Consensus**
Three independent evaluators run against the same proposal data with different rule sets. A 2 of 3 APPROVED result produces an EXECUTE consensus.

**4. Execution Permit**
A permit is generated with a unique ID, 24-hour expiration, and replay protection. The permit is associated with the proposal and the intended action.

**5. Human Review**
The Architect reviews the permit via the Explorer at `localhost:3000` or the Permit API at `localhost:3001/permit/:id`.

**6. Execution**
The Architect manually consumes the permit and triggers the authorized action.

## Rejection

If consensus is BLOCK or INCONCLUSIVE, no permit is generated and the proposal is logged as rejected. No execution occurs.
