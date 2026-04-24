---
id: 53
jira_key:
type: Task
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link:
parent:
sprint: Sprint 5
reporter:
assignee:
story_points:
labels:
  - discovery
  - api-contract
  - carnets-digitales
  - wallet
  - binary-payload
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-24T13:04:19+02:00
due_date:
jira_url:
---
# [TASK-53] Validar respuestas binarias o string de carnets y reglas de wallet
## Functional Description
Cerrar la estrategia real de integración para payloads string/base64, PKPass y documentos de carnets digitales, validando qué devuelven realmente los endpoints y cómo condicionan la integración con wallet móvil.

## Acceptance Criteria
- [x] Se obtienen o solicitan ejemplos reales de PDF/PKPass/QR y grado de discapacidad.
- [x] Se documenta cómo distinguir éxito funcional, error de negocio y binario inválido.
- [x] Se valida compatibilidad con wallet móvil y restricciones de plataforma.
- [x] Se dejan trazadas las dependencias para STORIES-49 a 52.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [TASK-16]
  - Blocks:
    - [STORY-49]
    - [STORY-50]
    - [STORY-51]
    - [STORY-52]
  - Related to:
    - [EPIC-7]
- Validation scope:
  - Ejemplos reales de QR, PDF, PKPass y respuesta de grado de discapacidad.
  - Distinción entre respuesta binaria válida, string/base64, error de negocio y payload inválido.
  - Restricciones de Apple Wallet/Google Wallet y fallback de plataforma.
- Expected outcome:
  - Dejar contrato semántico mínimo para las historias de carnets.
  - Confirmar dependencias técnicas exactas con [STORY-49], [STORY-50], [STORY-51] y [STORY-52].

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - CarnetDigitalApi.md
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md N4
  - MAPEO_DETALLADO_ENDPOINTS.md sección 6
- Provisional hierarchy:
  - Epic candidate: [EPIC-7]
- Dependency map:
  - Blocked by [TASK-16].
  - Blocks [STORY-49], [STORY-50], [STORY-51] y [STORY-52].
  - Reduce la incertidumbre contractual del epic de carnets digitales.

## Notes
### Comments
- None yet.
- 2026-04-24T13:04:19+02:00 | by Copilot | Discovery cerrada en `documentation/discovery/TASK-53-cards-binary-wallet-strategy.md`. Congela las firmas reales del cliente Dio generado para los nueve endpoints `carnet-digital/*`, define la discriminación success/business-error/invalid-binary por familia (envelope vs bare string + validador binario con magic headers PDF/PKPass/PNG), propone la integración wallet (canal nativo iOS PassKit + fallback share/open en Android, sin Google Wallet en MVP), y fija el contrato de naming determinista y limpieza de temporales que poseerá STORY-52. Matriz de impacto explícita sobre STORY-49/50/51/52 y lista de preguntas abiertas (samples reales, sentinelas codError, formato de CarnetQr.qr, shape de grado, signing backend del .pkpass, hook de cleanup) que deben cerrarse antes de que esas historias salgan de Sprint 5. No se duplica TASK-71 (surface decisions); este doc trata solo el contrato de payload + wallet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-24T13:04:19+02:00 | by Copilot | Discovery completada; documento `documentation/discovery/TASK-53-cards-binary-wallet-strategy.md` añadido. Status → Done, Sprint 5, AC marcadas.
