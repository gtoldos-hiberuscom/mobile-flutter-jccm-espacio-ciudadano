---
id: 26
jira_key:
type: Story
status: To Do
priority:
project: Carpeta Ciudadana CLM
epic_link:
parent:
sprint:
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
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [STORY-26] Dominio Estado y otros temas de interés con domicilio, inmuebles y vehículos
## Functional Description
Cubrir la experiencia de datos procedentes de otras administraciones o registros estatales visibles en la portada y sitemap.

## Acceptance Criteria
- [ ] Se contempla landing de “Otros temas de interés/Estado” con enlaces y explicaciones.
- [ ] Se contemplan pantallas de domicilio, bienes inmuebles y vehículos con sus campos relevantes.
- [ ] Se contempla soporte a paginación/iteración de elementos, titulares y cartografía donde aplique.
- [ ] Se contemplan mensajes de aclaración sobre la procedencia y actualización de los datos.

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
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
