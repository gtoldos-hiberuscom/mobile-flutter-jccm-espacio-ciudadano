# Copilot ticketing pack

Paquete listo para añadir a un repositorio y usar con GitHub Copilot para gestionar tickets tipo Jira en Markdown.

## Qué incluye
- Un agente especializado en ticketing: `.github/agents/ticket-manager.agent.md`
- Instrucciones de repositorio para Copilot: `.github/copilot-instructions.md`
- Skills reutilizables para:
  - crear o actualizar tickets
  - cambiar estado
  - comentar
  - reasignar
  - gestionar enlaces y dependencias
  - completar o cerrar tickets
- Hooks para:
  - registrar sesiones y prompts sin guardar el texto completo
  - bloquear nombres inválidos en `tickets/`
  - validar nombres de ramas gestionadas `epic/`, `ticket/` y `task/`
  - bloquear comandos destructivos sobre tickets
  - validar tickets modificados después de cambios

## Estructura esperada
- los agentes de Copilot viven en `.github/agents/` y usan el sufijo `*.agent.md`
- las skills viven en `.github/skills/<skill-name>/SKILL.md`
- `tickets/` contiene todos los tickets
- cada ticket es `tickets/TICKET-{id}.md`
- el H1 visible de cada ticket es `# [<TYPE>-<id>] <Summary>`
- las ramas gestionadas usan:
  - `epic/<EPIC-id>-<epic-slug>`
  - `ticket/<EPIC-id>-<epic-slug>/<TYPE-id>-<ticket-slug>`
  - `task/<EPIC-id>-<epic-slug>/<TYPE-id>-<ticket-slug>/<task-slug>`
- `examples/` contiene ejemplos de referencia y no forma parte del backlog real

## Instalación
1. Copia el contenido del ZIP en la raíz del repositorio.
2. Haz commit de `.github/agents`, `.github/skills`, `.github/hooks`, `tickets/`.
3. Usa Copilot con el agente `ticket-manager`.

## Ejemplos de uso
- `Use the ticket-manager agent to create tickets/TICKET-40162.md from this Jira payload.`
- `Use the plan-manager agent to create branch ticket/EPIC-10-platform-foundations/STORY-42-repo-bootstrap from its parent epic branch.`
- `Use the ticket-manager agent to move tickets/TICKET-40162.md from To Do to In Progress and append the change log.`
- `Use the ticket-manager agent to add a comment to tickets/TICKET-40162.md saying that PO validation is pending.`
- `Use the ticket-manager agent to reassign tickets/TICKET-40162.md to María Pérez.`
- `Use the ticket-manager agent to link tickets/TICKET-40162.md as blocked by NAVEMP-201.`

## Validación manual
Puedes lanzar esta validación desde terminal:

```bash
python3 .github/hooks/scripts/validate_tickets.py
python3 .github/hooks/scripts/validate_tickets.py --changed-only
```
