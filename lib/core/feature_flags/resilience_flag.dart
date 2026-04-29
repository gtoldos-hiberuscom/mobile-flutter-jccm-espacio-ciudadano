/// Sprint 7 / STORY-65 / TASK-70 — opt-in resilience layer.
///
/// Single kill-switch for the whole resilience stack (connectivity stream,
/// retry interceptor, TTL cache adopters). Defaults to `true`. Features
/// that opted in MUST gate their resilience adoption on this constant so a
/// regression can be flipped off in one place without ripping wiring.
///
/// Do NOT silently rewrite existing repositories; adopters are explicit and
/// documented in `documentation/qa/resilience-adopters.md`.
library;

const bool kResilienceLayerEnabled = true;
