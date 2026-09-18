# Matriz de acceso por cláusulas de consentimiento

Este documento define qué información puede consultarse en función de las cláusulas aceptadas por el ciudadano.

Refleja la matriz facilitada por el cliente (revisión del 2026-08-20), que es la
fuente de verdad. La documentación funcional del gateway dice que bienestar
social exige la cláusula de recomendaciones: es una errata, la matriz del cliente
y el propio texto de la cláusula JCCM lo desmienten.

Las cláusulas se guardan por usuario en `SharedPreferences` usando:

- Flag de paso por pantalla legal: `consent_accepted_<idAgente>`
- IDs de cláusulas aceptadas: `consent_accepted_clauses_<idAgente>`

## Cláusulas

Los identificadores son los `idClausula` que devuelve el API en
`GET /api/v1/ciudadanos/{id}/clausulas`, **no una numeración propia**: son los
valores que se envían en las altas y actualizaciones y con los que se comparan
las autorizaciones. Empiezan en 0.

| `idClausula` | Cláusula | Constante en código | Uso |
| --- | --- | --- | --- |
| 0 | Protección de datos | `requiredConsentClauseId` | Obligatoria. Acceso básico al Espacio Ciudadano. |
| 1 | Condiciones de uso (JCCM) | `jccmDataConsentClauseId` | Consulta de hechos administrativos de la JCCM en bienestar social, empleo, educación y salud. |
| 2 | Espacio Ciudadano (AGE) | `ageDataConsentClauseId` | Consulta de información de la Administración General del Estado. |
| 3 | Recomendaciones | `recommendationsConsentClauseId` | Uso de preferencias y hechos vitales para recomendaciones personalizadas. |
| 4 | Carnets | `digitalCardsConsentClauseId` | Consulta y descarga de carnets digitales. |

> Una versión anterior de este documento numeraba las cláusulas de 1 a 4, con un
> desfase de uno respecto al API. Quien tradujera la matriz a código directamente
> pedía la cláusula equivocada, y el síntoma era un 403 difícil de rastrear.

## Información

| Área | Información | Origen | 0 · Protección de datos | 1 · JCCM | 2 · AGE | 3 · Recomendaciones |
| --- | --- | --- | --- | --- | --- | --- |
| Información | Notificaciones | JCCM | Sí | No | No | No |
| Información | Expedientes | JCCM | Sí | No | No | No |
| Educación | Títulos Universitarios | AGE | Sí | No | Sí | No |
| Educación | Títulos No Universitarios | AGE | Sí | No | Sí | No |
| Educación | Títulos No Universitarios Intermediación | JCCM | No | Sí | No | No |
| Salud | Citas primaria | JCCM | Sí | Sí | No | No |
| Bienestar Social | Familia Numerosa | JCCM | Sí | Sí | No | No |
| Bienestar Social | Discapacidad | JCCM | Sí | Sí | No | No |
| Bienestar Social | Termalismo | JCCM | Sí | Sí | No | No |
| Bienestar Social | Tarjeta estacionamiento | JCCM | Sí | Sí | No | No |
| Bienestar Social | Atención a la dependencia | JCCM | Sí | Sí | No | No |
| Empleo | Demandante de empleo | AGE | Sí | No | Sí | No |
| Empleo | Inscripciones en ofertas de empleo | JCCM | Sí | Sí | No | No |
| Vivienda y vehículos | Domicilio | AGE | Sí | No | Sí | No |
| Vivienda y vehículos | Bienes inmuebles | AGE | Sí | No | Sí | No |
| Vivienda y vehículos | Vehículos | AGE | Sí | No | Sí | No |

## Carnet

| Área | Información | Origen | 0 · Protección de datos | 1 · JCCM | 2 · AGE | 3 · Recomendaciones | 4 · Carnets |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Carnet | Discapacidad | JCCM | Sí | No | No | No | Sí |
| Carnet | Familia Numerosa | JCCM | Sí | No | No | No | Sí |
| Carnet | Joven | JCCM | Sí | No | No | No | Sí |

## Agenda

| Área | Información | Origen | 0 · Protección de datos | 1 · JCCM | 2 · AGE | 3 · Recomendaciones |
| --- | --- | --- | --- | --- | --- | --- |
| Agenda | Notificaciones | JCCM | Sí | Sí | No | No |
| Agenda | Carnet discapacidad | JCCM | Sí | Sí | No | No |
| Agenda | Carnet familia numerosa | JCCM | Sí | Sí | No | No |
| Agenda | Carnet joven | JCCM | Sí | Sí | No | No |
| Agenda | Citas primaria | JCCM | Sí | Sí | No | No |

## Recomendaciones

| Área | Información | Origen | 0 · Protección de datos | 1 · JCCM | 2 · AGE | 3 · Recomendaciones |
| --- | --- | --- | --- | --- | --- | --- |
| Recomendaciones | Recomendaciones | JCCM | Sí | No | No | Sí |

## Regla de evaluación prevista

Para una ruta o funcionalidad concreta, `app_routes` debe permitir el acceso solo si el ciudadano ha aceptado todas las cláusulas marcadas como `Sí` para esa funcionalidad.

Ejemplos, con los `idClausula` reales:

- `Notificaciones`: requiere la cláusula `0`.
- `Citas primaria`: requiere las cláusulas `0` y `1`.
- `Títulos Universitarios`: requiere las cláusulas `0` y `2`.
- `Recomendaciones`: requiere las cláusulas `0` y `3`.

Si el ciudadano no ha aceptado una cláusula requerida, la ruta debería bloquear el acceso a esa funcionalidad concreta, no cerrar sesión ni forzar a repetir todo el onboarding legal.
