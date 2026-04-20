---
name: flutter-quality-governance
description: Apply the canon for security, PII handling, performance, testing, release checks, lints, PR validation, and ADR decisions. Use when validating an implementation, introducing architectural exceptions, or defining completion criteria for a change.
argument-hint: When asking to implement a change, provide as much context as possible about the affected area, the relevant ticket if any, and the expected outcome. For example:
Implement the new navigation menu design according to the mockups provided by the design team. The change should follow the architecture canon v2 and be traceable to the existing ticket NAVEMP-126. Make sure to consult the relevant sections of the canon for guidance on repository topology, feature structure, and implementation rules. Use the appropriate architecture skills for scaffolding, UI composition, and ticket synchronization. Validate tests and confirm that the implementation aligns with the acceptance criteria in the ticket.
target: github-copilot  
---

Use this skill when the task requires validating quality, adding tests, reviewing security or performance implications, updating release/lint rules, or deciding whether a canon exception needs an ADR.

## Canon sources
Read these sections first:
- `documentation/architecture_canon_flutter_v2_docs/architecture_canon_flutter_v2_annex_c.md` sections 24-29
- `documentation/architecture_canon_flutter_v2_docs/architecture_canon_flutter_v2_annex_d.md` sections 34-39

## Security and privacy rules
- Tokens and sensitive session data go to secure storage.
- Real secrets are never embedded in the client.
- External URLs must be validated before use.
- Logs, analytics, and crash reports must redact PII.
- Sensitive fields require explicit review before they are captured, persisted, or reported.

## Performance rules
- Respect the project's performance budgets for startup, critical screen load, scrolling, payload size, and rebuild cost.
- Avoid expensive work in hot UI paths.
- Use pagination, caching, batching, and cancellation when the use case needs them.

## Testing rules
- Cover the correct layer with the correct test type.
- Minimum expectation:
  - domain: happy path and error path per use case;
  - data: mapper, repository, and contract behavior;
  - presentation: controller/notifier and important widget states;
  - integration: critical end-to-end flows.
- If a required test cannot be added yet, state the gap explicitly.

## Governance rules
- CI should fail on missing generated code, static-analysis failures, or unjustified test regressions.
- Prefer explicit lint rules for forbidden imports, naming, and hardcoded UI strings.
- Any meaningful deviation from routing, state management, repo structure, error strategy, cache strategy, or release process requires an ADR.

## Done checklist
- Security, privacy, and logging implications were reviewed.
- The matching tests or validation steps exist, or the gap is stated.
- PR-level architecture checks pass conceptually: no forbidden imports, no DTO leaks, no raw errors to users.
- If the change breaks a canon default, an ADR or explicit override is in place.
