---
name: prd-to-issues
description: Break a PRD into independently-grabbable Linear issues using tracer-bullet vertical slices. Use when user wants to convert a PRD to issues, create implementation tickets, or break down a PRD into work items.
---

# PRD to Issues

Break a PRD into independently-grabbable Linear issues using vertical slices (tracer bullets).

## Process

### 1. Locate the PRD

Ask the user for the PRD location in Linear. This may be one of:

- A Linear issue ID (e.g., `PROJ-123`)
- A Linear document slug or ID
- A direct Linear URL

If the PRD is not already in your context window, retrieve it using the Linear MCP tools:

- Use `linear_get_issue` if the PRD is stored as a Linear issue
- Use `linear_get_document` if the PRD is stored as a Linear document

Also fetch comments if relevant so you capture clarifications and design decisions.

PRD validation:

- If the PRD is a Linear **issue**, verify it follows the workspace PRD convention.
- A valid PRD should either:
  - have a title starting with `[PRD]`, or
  - include the label `prd`.
- If neither condition is true, warn the user that the selected issue does not appear to be a PRD and ask if they still want to proceed.

### 2. Explore the codebase (optional)

If you have not already explored the codebase, do so to understand the current state of the code.

### 3. Draft vertical slices

Break the PRD into **tracer bullet** issues. Each issue is a thin vertical slice that cuts through ALL integration layers end-to-end, NOT a horizontal slice of one layer.

Slices may be 'HITL' or 'AFK'. HITL slices require human interaction, such as an architectural decision or a design review. AFK slices can be implemented and merged without human interaction. Prefer AFK over HITL where possible.

<vertical-slice-rules>
- Each slice delivers a narrow but COMPLETE path through every layer (schema, API, UI, tests)
- A completed slice is demoable or verifiable on its own
- Prefer many thin slices over few thick ones
</vertical-slice-rules>

### 4. Quiz the user

Present the proposed breakdown as a numbered list. For each slice, show:

- **Title**: short descriptive name
- **Type**: HITL / AFK
- **Blocked by**: which other slices (if any) must complete first
- **User stories covered**: which user stories from the PRD this addresses

Ask the user:

- Does the granularity feel right? (too coarse / too fine)
- Are the dependency relationships correct?
- Should any slices be merged or split further?
- Are the correct slices marked as HITL and AFK?

Iterate until the user approves the breakdown.

### 5. Create the Linear issues

For each approved slice, create a Linear issue using the Linear MCP (`linear_save_issue`).

Guidelines:

- Use the slice **Title** as the Linear issue title
- Put the issue body template below into the issue **description**
- Detect and reuse the **team** and **project** from the parent PRD when possible
- If the PRD is a Linear issue, set `parentId` to the PRD issue ID so all slices appear nested under the PRD
- If the PRD includes priority, labels, or milestone hints, propagate them to child issues when appropriate
- Create issues in dependency order (blockers first)

After creating each issue, capture its Linear issue identifier (e.g., `PROJ-456`) so it can be referenced in later slices under "Blocked by".

If dependency relationships exist between slices, use Linear relationships when possible:

- Use `blockedBy` for prerequisite slices
- Use `relatedTo` when slices are logically related but not strict blockers
- Ensure each slice is linked back to the PRD:
  - If `parentId` is not used (e.g., PRD stored as a document), add the PRD issue to `relatedTo` so navigation from tasks back to the PRD is easy.

### 6. Map PRD metadata

Before creating issues, inspect the PRD and extract useful metadata that should be reused across slices:

- **Team**: infer from the PRD issue or ask the user if unclear
- **Project**: if the PRD belongs to a Linear project, attach all slices to that project
- **Labels**: reuse labels such as `backend`, `frontend`, `infra`, `api`, `design`
- **Priority**: inherit from the PRD unless a slice clearly differs

If any of these are missing or ambiguous, ask the user once before creating issues.

<issue-template>
## Parent PRD

<PRD Linear issue or document link>

## What to build

A concise description of this vertical slice. Describe the end-to-end behavior, not layer-by-layer implementation. Reference specific sections of the parent PRD rather than duplicating content.

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Blocked by

- Blocked by <LINEAR-ISSUE-ID> (if any)

Or "None - can start immediately" if no blockers.

## User stories addressed

Reference by number from the parent PRD:

- User story 3
- User story 7

</issue-template>

Do NOT close or modify the parent PRD issue.
