---
id: 59
jira_key:
type: Story
status: In Review
priority:
project: Carpeta Ciudadana CLM
epic_link:
parent:
sprint:
reporter:
assignee:
story_points:
labels:
  - ayuda
  - faq
  - guias
  - contacto
  - contenidos-estaticos
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-22T13:03:08+00:00
due_date:
jira_url:
---
# [STORY-59] Centro de ayuda con FAQ, guías y contacto informativo
## Functional Description
Cubrir la pantalla de ayuda con preguntas frecuentes, guías y datos de contacto informativo, organizando los contenidos para consulta local y acceso a recursos externos de apoyo al ciudadano cuando aplique.

## Acceptance Criteria
- [ ] Se contempla listado FAQ en formato acordeón con respuesta expandible.
- [ ] Se contempla búsqueda local y organización temática de contenidos según documentación funcional.
- [ ] Se contemplan secciones de guías de ayuda y datos de contacto administrativo.
- [ ] Se contemplan enlaces a recursos externos como oficinas de información y registro o vídeos cuando apliquen.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-14]
    - [STORY-15]
  - Blocks:
    - [STORY-60]
  - Related to:
    - [EPIC-9]
- Help center scope:
  - FAQ en acordeón con expansión/colapso.
  - Búsqueda local y agrupación temática de contenidos.
  - Secciones informativas con teléfonos, correos o vías administrativas equivalentes.
  - Enlaces externos seguros a recursos complementarios.
- Content assumptions:
  - Parte del contenido puede venir empaquetado o precargado.
  - La estructura base de ayuda condiciona la coherencia del formulario posterior de [STORY-60].

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - image_references/Ayuda.png
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md pantalla 11
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 11
- Provisional hierarchy:
  - Epic candidate: [EPIC-9]
- Dependency map:
  - Blocked by [STORY-14] y [STORY-15].
  - Blocks [STORY-60] al definir el contexto y la entrada a soporte técnico.
  - Forma parte del frente de ayuda y contenidos informativos del epic [EPIC-9].

## Notes
### Comments
- 2026-04-22T13:03:08+00:00 | by Copilot | Implementation complete on branch `task/EPIC-9-help-support-legal/STORY-59-help-center/implement-help-center` (commit `bd3f083`).

  Delivered:
  - `lib/features/help/` — full 4-layer feature (0_entity, 1_domain, 2_presentation, 3_data)
  - Entities: `FaqItem`, `HelpGuide`, `ContactInfo` (with `HelpCategory` and `ContactType` enums)
  - `HelpRepository` abstract class (domain), `HelpRepositoryImpl` (bundled in-memory data: 6 FAQs, 3 guides, 3 contacts)
  - `helpRepositoryProvider` with hand-crafted `.g.dart`
  - `HelpPage` (`ConsumerStatefulWidget` + `SingleTickerProviderStateMixin`, 3-tab `TabBar`)
  - `FaqList` (live search, `ExpansionTile` accordion, inline empty state)
  - `HelpGuidesList` (cards with optional external link via `url_launcher`)
  - `ContactInfoList` (`tel:`, `mailto:`, `https:` URIs with semantics labels)
  - l10n keys added (9 new keys in `app_es.arb` + `app_en.arb`); `flutter gen-l10n` run
  - `url_launcher ^6.3.1` added to `pubspec.yaml`
  - `/help` route wired (`HelpPlaceholder` → `HelpPage`) in `app_router.dart`
  - Barrel file `lib/features/help/help.dart`
  - `dart analyze lib/`: **0 errors**

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-22T13:03:08+00:00 | by Copilot | Status transitioned from `To Do` → `In Review`. Implementation complete on branch `task/EPIC-9-help-support-legal/STORY-59-help-center/implement-help-center` (commit `bd3f083`).
