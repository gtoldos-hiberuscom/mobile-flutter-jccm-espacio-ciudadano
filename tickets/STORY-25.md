---
id: 25
jira_key: JCCMEC-19
type: Story
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link: JCCMEC-14
parent: JCCMEC-14
sprint: Sprint 3
reporter:
assignee:
story_points:
labels:
  - bienestar-social
  - dashboard
  - landing
  - family
  - contract-gap
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-05-11T15:57:23+02:00
due_date:
jira_url: https://hiberusmobile.atlassian.net/browse/JCCMEC-19
---
# [STORY-25] Dominio Bienestar social con familia numerosa y servicios sociales vinculados
## Functional Description
Cubrir la experiencia de bienestar social mostrando información social relevante y servicios visibles en diseño.

## Acceptance Criteria
- [x] Se contempla landing de Bienestar social con información relevante y enlaces externos.
- [x] Se contempla detalle de familia numerosa con datos del título y beneficiarios.
- [x] Se contempla tarjeta de estacionamiento y atención a la dependencia como pantallas funcionales inferidas del diseño.
- [x] Se contempla termalismo/balnearios como capacidad visible del dominio y fallback si el backend no está disponible.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-22]
    - [TASK-27] (partial)
  - Blocks:
    - [STORY-48] (partial)
  - Related to:
    - [EPIC-3]
    - [STORY-28]
- Confirmed contracts:
  - /ccaa/familia-numerosa/{numDocumento}
  - /intermediacion/discapacidad/datos
  - /carnet-digital/grado-discapacidad/{dni}
- Contract-sensitive surfaces:
  - Tarjeta de estacionamiento, atención a la dependencia y termalismo/balnearios requieren cierre funcional/técnico adicional.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - endpoint /ccaa/familia-numerosa/{numDocumento}
  - endpoint /intermediacion/discapacidad/datos
  - endpoint /carnet-digital/grado-discapacidad/{dni}
  - image_references/Landing Bienestar social.png
  - image_references/Servicios - Familia numerosa.png
  - image_references/Servicios - Familia numerosa-1.png
  - image_references/Servicios - Atención a la dependencia.png
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md N1 y N4
- Provisional hierarchy:
  - Epic candidate: [EPIC-3]
- Dependency map:
  - Blocked by [STORY-22] y parcialmente por [TASK-27].
  - Blocks parcialmente [STORY-48].
  - Related to [STORY-28] para enlaces externos del dominio.

## Notes
### Comments
- 2026-05-04T22:35:00+02:00 | author: Copilot | comment: TASK-27 discovery resolved Sprint 3 gaps that affect this story. See `documentation/discovery/TASK-27-dashboard-contract-gaps.md` (commit `docs(dashboard-domains): [EPIC-3/TASK-27/document-gap-decisions] add dashboard contract gap discovery doc and close TASK-27`). Decision summary para Bienestar social: termalismo, tarjeta de estacionamiento y atención a la dependencia → external link via ExternalLinkCatalog; familia numerosa se mantiene contra `/ccaa/familia-numerosa/{numDocumento}`.
- 2026-05-05T11:00:00+02:00 | author: Copilot | comment: Sprint-3 implementation applied the TASK-27 decisions per gap. EXTERNAL_LINK → "Termalismo / Balnearios", "Tarjeta de estacionamiento" y "Atención a la dependencia" ship as `ExternalLinkCard` cards (no fake state, no fake API). Catalog inventory extended with a single new entry `bienestar_social_clm` (category `socialWelfareCLM`) used by termalismo and dependencia cards; tarjeta de estacionamiento points at `carpeta_ciudadana_age` as the Sprint-3 fallback. Both new cards carry `// TODO(product)` markers asking product to confirm the canonical sede electrónica JCCM landings. Familia numerosa shipped as functional UI bound to mock CCAA data — real Dio wiring against `/ccaa/familia-numerosa/{numDocumento}` is left as a follow-up story (TODO markers in `social_welfare_repository.dart` / `social_welfare_repository_impl.dart`). Sitemap (STORY-28 surface) updated to include the new entry so the catalog/sitemap parity test continues to pass.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-05-05T11:00:00+02:00 | status | To Do -> In Progress | by Copilot
- 2026-05-05T11:00:00+02:00 | status | In Progress -> Done | by Copilot
