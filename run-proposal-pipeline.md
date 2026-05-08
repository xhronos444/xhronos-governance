# Running a Proposal Through the Pipeline

This guide walks through evaluating a proposal end-to-end using the XHRONOS governance scripts.

## Prerequisites

- Node.js installed
- `ethers`, `express` installed (`npm install ethers express`)
- All governance scripts in your working directory

## Step 1 — Get a Proposal ID

Find a proposal ID from the registry on Basescan:
`https://basescan.org/address/0x18B3E7c44C312D35CD75d44c13046eA82B30C010#events`

Look for `ProposalSubmitted` events. Copy the `proposalId` value.

## Step 2 — Evaluate

```bash
node policy-evaluator-v1.cjs 0xYOUR_PROPOSAL_ID
```

Output: `APPROVED`, `REJECTED`, or `PENDING`.

## Step 3 — Consensus

```bash
node consensus-layer-v1.cjs 0xYOUR_PROPOSAL_ID
```

Output: `EXECUTE`, `BLOCK`, or `INCONCLUSIVE`.

## Step 4 — Execution Binding

```bash
node execution-binding-v1.cjs 0xYOUR_PROPOSAL_ID
```

Records the result in `executions.json`.

## Step 5 — Sync State

```bash
node governance-state-manager-v1.cjs sync 0xYOUR_PROPOSAL_ID
node governance-state-manager-v1.cjs query 0xYOUR_PROPOSAL_ID
```

Shows the unified lifecycle state.

## Step 6 — Start the API and Explorer

```bash
node governance-api.cjs
```

Open `http://localhost:3000` to view the Explorer.

## Step 7 — Generate a Permit (if APPROVED)

```bash
node execution-permit-v1.cjs
```

Then POST to generate a permit:

```
POST http://localhost:3001/permit/generate
Content-Type: application/json

{
  "proposalId": "0xYOUR_PROPOSAL_ID",
  "agent": "0xYOUR_ADDRESS",
  "action": "PAYOUT_EXECUTION"
}
```

## Step 8 — Human Review and Consumption

Review the permit at `GET http://localhost:3001/permit/:permitId`.

If approved, consume it:

```
POST http://localhost:3001/permit/:permitId/consume
Content-Type: application/json

{ "executor": "architect" }
```

Only after this step should any downstream action be taken.
