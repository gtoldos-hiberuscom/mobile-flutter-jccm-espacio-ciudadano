---
id: 61
jira_key: JCCMEC-60
type: Story
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link: JCCMEC-31
parent: JCCMEC-31
sprint: Tablero Sprint 2
reporter:
assignee:
story_points:
labels:
  - legal
  - privacidad
  - accesibilidad
  - aviso-legal
  - contenidos-estaticos
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-05-11T16:36:00+02:00
due_date:
jira_url: https://hiberusmobile.atlassian.net/browse/JCCMEC-60
---
# [STORY-61] Páginas legales y estáticas de uso, privacidad, accesibilidad y aviso legal
## Functional Description
Cubrir las páginas estáticas o semiestáticas que forman parte del cumplimiento legal y la navegación global, incluyendo condiciones de uso, protección de datos, accesibilidad y aviso legal, con especial atención a contenido empaquetado y reutilización de textos ya presentes en onboarding.

## Acceptance Criteria
- [x] Se contemplan Condiciones de uso, Protección de datos, Accesibilidad y Aviso legal.
- [x] Se contempla lectura completa con scroll, enlaces externos y contenido empaquetado cuando aplique.
- [x] Se contempla reutilización del contenido de protección de datos mostrado en el onboarding.
- [x] Se contemplan estados sin conexión para contenidos estáticos locales.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-14]
    - [STORY-19]
  - Blocks:
    - None.
  - Related to:
    - [EPIC-9]
- Legal/static scope:
  - Pantallas legales accesibles desde navegación global.
  - Reutilización del contenido de protección de datos ya mostrado en onboarding.
  - Soporte de contenido local empaquetado y enlaces externos cuando proceda.
  - Estados offline para contenido estático disponible en la app.
- Consistency requirements:
  - Mantener coherencia entre onboarding, footer, menú y páginas estáticas.
  - Diferenciar piezas 100% locales frente a contenido con dependencia externa.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - image_references/Acceso - Condiciones-1.png
  - image_references/Acceso - Condiciones-2.png
  - image_references/Servicios - Mis carnets digitales-1.png
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md pantallas 10 y 11
  - RESUMEN_FUNCIONALIDADES_PPT.md secciones 10 y 11
- Provisional hierarchy:
  - Epic candidate: [EPIC-9]
- Dependency map:
  - Blocked by [STORY-14] y [STORY-19].
  - Sin descendientes explícitos en este corte.
  - Da soporte legal y de contenidos estáticos a la navegación global del epic [EPIC-9].

## Notes
### Comments
- 2026-05-04T19:30:00+02:00 | by Copilot | Added `lib/features/legal/` with 4 bundled documents (terms/privacy/accessibility/legalNotice). Privacy reuses the RGPD/LOPDGDD copy from the consent flow. Wired all four legal `Routes.*` to `LegalDocumentPage`. Mini-Markdown rendering (paragraphs + bullets) without new deps. Test `legal_documents_repository_test.dart` (4 tests, pass). Analyze 46 issues (+1 info vs baseline, within budget).

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-05-04T19:30:00+02:00 | status | To Do -> In Progress | by Copilot
- 2026-05-04T19:30:00+02:00 | status | In Progress -> Done | by Copilot
- 2026-05-04T19:30:00+02:00 | sprint | (none) -> Sprint 2 | by Copilot
