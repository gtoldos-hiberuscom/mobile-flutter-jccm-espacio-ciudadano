---
id: 26
jira_key: JCCMEC-20
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
  - estado
  - dashboard
  - landing
  - registros
  - external-links
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-05-11T15:57:23+02:00
due_date:
jira_url: https://hiberusmobile.atlassian.net/browse/JCCMEC-20
---
# [STORY-26] Dominio Estado y otros temas de interés con domicilio, inmuebles y vehículos
## Functional Description
Cubrir la experiencia de datos procedentes de otras administraciones o registros estatales visibles en la portada y sitemap.

## Acceptance Criteria
- [x] Se contempla landing de “Otros temas de interés/Estado” con enlaces y explicaciones.
- [x] Se contemplan pantallas de domicilio, bienes inmuebles y vehículos con sus campos relevantes.
- [x] Se contempla soporte a paginación/iteración de elementos, titulares y cartografía donde aplique.
- [x] Se contemplan mensajes de aclaración sobre la procedencia y actualización de los datos.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-22]
  - Blocks:
    - None.
  - Related to:
    - [EPIC-3]
    - [STORY-28]
- Confirmed contracts:
  - /ine/datos-residencia/{numDocumento}
  - /catastro/datos-catastrales/{numDocumento}
  - /dgt/lista-vehiculos/{numDocumento}
- Data handling considerations:
  - Iteración/paginación de elementos para inmuebles y vehículos.
  - Titularidad, cartografía y procedencia estatal como metadatos visibles.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - endpoint /ine/datos-residencia/{numDocumento}
  - endpoint /catastro/datos-catastrales/{numDocumento}
  - endpoint /dgt/lista-vehiculos/{numDocumento}
  - image_references/Administración general del Estado _ Domicilio.png
  - image_references/Administración general del Estado _ Bienes inmuebles.png
  - image_references/Administración general del Estado _ Vehículos.png
  - image_references/Landing logado - Otras temas de interés.png
- Provisional hierarchy:
  - Epic candidate: [EPIC-3]
- Dependency map:
  - Blocked by [STORY-22].
  - Related to [STORY-28] para la experiencia de enlaces y retorno.

## Notes
### Comments
- 2026-05-05T08:00:00+02:00 | author: Copilot | comment: Sprint-3 baseline shipped UI only with mocked repository data; real Dio wiring against `/ine/datos-residencia/{numDocumento}`, `/catastro/datos-catastrales/{numDocumento}` and `/dgt/lista-vehiculos/{numDocumento}` is left as a follow-up story (TODO markers in `state_affairs_repository.dart` / `state_affairs_repository_impl.dart`). Vehicles section uses a per-section `error` mock to exercise the UI states surface; properties section uses `PaginatedListView` with page size 5. External-links section reuses existing `sede_dgt` and `carpeta_ciudadana_age` catalog ids — no STORY-28 changes required.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-05-05T08:00:00+02:00 | status | To Do -> In Progress | by Copilot
- 2026-05-05T08:00:00+02:00 | status | In Progress -> Done | by Copilot
