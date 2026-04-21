---
id: 36
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
  - registro
  - entradas
  - salidas
  - detalle
  - listados
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [STORY-36] Detalle de entradas y salidas de registro
## Functional Description
Cubrir la lectura detallada de registros de entrada y salida asociados al ciudadano, manteniendo consistencia de navegación, formatos y manejo de vacíos o errores.

## Acceptance Criteria
- [ ] Se contempla listado y detalle de entradas de registro con número, fecha y consejería de destino.
- [ ] Se contempla la variante equivalente para salidas de registro aunque la evidencia visual principal sea de entradas.
- [ ] Se contemplan breadcrumbs y retorno al listado correspondiente.
- [ ] Se contemplan mensajes vacíos o error y consistencia de formatos de fecha y número.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-34]
  - Blocks:
    - None.
  - Related to:
    - [EPIC-5]
- Endpoint coverage:
  - /publicacion/selectbynifentrada
  - /publicacion/selectbynifsalida
  - /publicacion/selectbynumreg
- Detail scope:
  - Variante de entradas y salidas alineada en navegación y presentación.
  - Breadcrumbs y retorno coherente al listado de origen.
  - Tratamiento explícito de vacíos, errores y formatos.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - /publicacion/selectbynifentrada
  - /publicacion/selectbynifsalida
  - /publicacion/selectbynumreg
  - image_references/Entradas registro - listado.png
  - image_references/Entrada registro - detalle.png
  - MAPEO_DETALLADO_ENDPOINTS.md 3.2, 3.3, 3.5
- Provisional hierarchy:
  - Epic candidate: [EPIC-5]
- Dependency map:
  - Blocked by [STORY-34].
  - Sin tickets descendientes explícitos en este corte.
  - Comparte superficie funcional de gestiones con expedientes, pero con foco en detalle de registros.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
