# TASK-63 — Discovery: Support integration strategy

Sprint: Sprint 7 (SP-EC-APP-SQ3-07)
Owner: plan-manager
Last updated: 2026-04-29

## 1. Context

`STORY-60` (Sprint 4) shipped the support form UI end-to-end with a mock
`SupportRepository` that always succeeds and a stub captcha challenge.
The form is currently disconnected from any backend. This discovery
defines the operational integration that unblocks the “send” path.

Authoritative inputs reviewed:
- `documentation/initial_documentation/DOCUMENTO_COMPRENSION_FUNCIONAL.md` (sections on transversal flows and PII)
- `documentation/initial_documentation/MAPEO_DETALLADO_ENDPOINTS.md`
- `documentation/initial_documentation/MAPEO_ENDPOINTS_PANTALLAS.md`
- `generated/dart_dio_client/` (search for `support|incidencia|soporte`)

## 2. Findings on existing endpoints

There is **no support-specific endpoint** in either MAPEO document or in
the generated Dio client. The closest reusable building blocks are:

| Concern        | Endpoint(s) available today                                  | Reusable for support? |
|----------------|--------------------------------------------------------------|------------------------|
| File upload    | `POST /procedimiento/subiradjunto` + `obtenerhashdeadjunto`  | Mechanically yes; semantically no — these are scoped to expedientes (`numexp` required). |
| Email confirm  | None in spec                                                  | No                     |
| Captcha        | None in spec                                                  | No                     |

Conclusion: support submission is **not yet a backend capability** in
the generated contract. STORY-60 cannot be fully wired without a new
endpoint or an out-of-band channel.

## 3. Decision

The recommended operational model for Sprint 7 → Sprint 9 window is a
two-track approach. Both tracks are valid; the chosen track depends on
backend availability before release:

### Track A (preferred) — dedicated `/soporte/incidencia` endpoint
The Carpeta Ciudadana backend exposes a new POST endpoint with a small
payload:

```
POST /soporte/incidencia
{
  "asunto": "string (max 120)",
  "descripcion": "string (max 4000)",
  "categoria": "tecnica|funcional|datos|otro",
  "consentimientoDatos": true,
  "captchaToken": "string",          // hCaptcha or Turnstile token
  "adjunto": {                       // optional, single file
    "nombre": "string",
    "mime": "application/pdf|image/png|image/jpeg",
    "tamanioBytes": 0,
    "contenidoBase64": "string"
  }
}
→ 202 Accepted { "ticketId": "string", "emailConfirmacion": "masked" }
```

Reasoning:
- Keeps support submission decoupled from `procedimiento/*` (which
  requires `numexp` and authenticated business context).
- Single round-trip, easy to retry idempotently if `ticketId` is keyed
  by client-generated UUID (recommended: client sends `Idempotency-Key`
  header).
- Email confirmation is server-side (operator inbox handles SMTP).

### Track B (fallback) — `mailto:` deep-link with structured body
If no backend appears before release, the form switches to building a
`mailto:` URI populated with the structured body. Attachments are not
supported in this mode (mailto cannot carry binaries reliably across
clients), so the form would surface a banner: “La copia del adjunto se
gestiona desde tu cliente de correo.”

This track keeps the citizen unblocked at the cost of operational
traceability (no ticket id, no audit trail in the support backend).

## 4. Operational definitions

### 4.1 Captcha
- **Provider**: Cloudflare Turnstile (preferred — privacy-by-default,
  no PII propagation, free tier covers expected volume <50k/month).
- **Fallback**: hCaptcha if Turnstile is rejected by infosec review.
- **Client integration**: render captcha as an `InAppWebView` widget;
  on success, the widget posts the token back to the Riverpod notifier
  via JS bridge. The token is opaque and short-lived (≤5 min).
- **Server validation**: `/soporte/incidencia` must validate the token
  server-side against the captcha provider before enqueueing.

### 4.2 Attachments
- **Limits**: 1 file per submission, ≤5 MB, MIME ∈ {PDF, PNG, JPEG}.
  Tighter than `subiradjunto` (5×50MB) on purpose — support payloads
  should not be a documentation channel.
- **Transport**: base64-encoded inline. Reason: avoids multipart for a
  single small file and aligns with REST/JSON-only stack.
- **Hash**: client computes SHA-256 and includes it as
  `adjunto.sha256` so the operator can verify integrity.
- **Storage**: server moves attachment to ticketing tool (e.g., Jira
  Service Management or Zendesk) via its own integration; not stored
  long-term in the citizen API DB.

### 4.3 Email confirmation
- Server sends confirmation email to the address the citizen provided
  (or to the email tied to the Cl@ve identity if present).
- Subject: `[Soporte Carpeta Ciudadana] Incidencia <ticketId>`.
- Body: ticketId, summary, expected SLA, contact channel for follow-up.
- The email itself is **not** rendered in the app; the app shows a
  generic confirmation: “Hemos recibido tu incidencia. Te llegará una
  copia por correo.”

### 4.4 Retention and SLA
- Operator inbox retention: **365 días** desde la última actualización
  del ticket (alineado con la política de gestión documental de JCCM).
- SLA target inicial sugerido (a confirmar con operaciones):
  - Acuse de recibo automático ≤ 5 min
  - Primera respuesta humana ≤ 2 días hábiles
  - Resolución ≤ 10 días hábiles para incidencias técnicas estándar
- Estos valores se publican en la pantalla de soporte vía l10n para no
  acoplar UI a copy de servidor.

### 4.5 PII handling
- El cuerpo de la incidencia es PII por definición. Reglas:
  - El cliente nunca registra `descripcion` ni `adjunto.contenidoBase64`
    en logs (ya implementado en `SupportRepositoryImpl`).
  - El interceptor de logging redacta `Authorization` y, para esta ruta
    concreta, también el body completo (añadir patrón
    `'/soporte/incidencia'` a la lista de redacción del
    `LoggingInterceptor`).
  - Las trazas de error que escalan a `AppLogger` solo contienen
    `ticketId`, status HTTP y categoría.

## 5. Impact on STORY-60

STORY-60 keeps su estado `Done` (UI completa, validaciones, captcha
mock, mensajes l10n). El trabajo pendiente es estrictamente de wiring,
con dos modos:

| Sub-tarea de wiring                                     | Track A | Track B |
|---------------------------------------------------------|---------|---------|
| Reemplazar `SupportRepositoryImpl` mock por cliente Dio | ✅      | n/a     |
| Sustituir captcha stub por Turnstile/hCaptcha           | ✅      | ✅      |
| Construir `mailto:` URI estructurado                    | n/a     | ✅      |
| Añadir SHA-256 de adjunto                               | ✅      | n/a     |
| Añadir patrón de redacción al `LoggingInterceptor`      | ✅      | ✅      |
| Mensajes l10n de SLA / retención                        | ✅      | ✅      |

Ninguno de estos cambios se ejecuta dentro de TASK-63 (discovery puro).
Se dejan **ready-to-wire** para una iteración posterior una vez
confirmado el track con backend / operaciones.

## 6. Open questions (escalation needed)

1. **Backend ownership**: ¿Quién implementa `/soporte/incidencia`? ¿El
   mismo equipo SAP/legacy que sirve el resto de endpoints, o un
   microservicio nuevo del equipo Carpeta?
2. **Operator tool**: ¿El backend escala a Jira Service Management,
   Zendesk, GLPI o un buzón funcional `soporte@jccm.es`? Esto define
   el contrato `ticketId`.
3. **Captcha provider**: aprobación de infosec para Turnstile (envío
   de IP a Cloudflare, residencia EU OK por DPA).
4. **SLA oficial**: validar los valores de §4.4 con el equipo de
   operaciones antes de publicarlos en l10n.

Estas cuatro preguntas se trasladan al consolidado **Open after Sprint
7** (recomendado: Sprint 8 — `Cierre operativa soporte`).

## 7. Closure status

| Acceptance Criterion (TASK-63)                                                             | Status      |
|--------------------------------------------------------------------------------------------|-------------|
| Identifica servicio/backend o canal operativo responsable                                  | ✅ §3 / §6  |
| Define tratamiento de adjuntos, confirmación por email y protección de datos               | ✅ §4.2/4.3 |
| Valida o selecciona mecanismo de captcha/antibot                                           | ✅ §4.1     |
| Documenta el impacto sobre STORY-60 y la operación posterior                               | ✅ §5       |
