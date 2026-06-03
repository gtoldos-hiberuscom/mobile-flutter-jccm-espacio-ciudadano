# Matriz de acceso por cláusulas de consentimiento

Este documento define qué información puede consultarse en función de las cláusulas aceptadas por el ciudadano.

Las cláusulas se guardan por usuario en `SharedPreferences` usando:

- Flag de paso por pantalla legal: `consent_accepted_<idAgente>`
- IDs de cláusulas aceptadas: `consent_accepted_clauses_<idAgente>`

## Cláusulas

| ID | Cláusula | Uso |
| --- | --- | --- |
| 1 | Cláusula inicial | Acceso básico a la información inicial del Espacio Ciudadano. |
| 2 | Cláusula JCCM | Consulta y tratamiento de información gestionada por JCCM. |
| 3 | Cláusula AGE | Consulta de información procedente de la Administración General del Estado. |
| 4 | Cláusula recomendaciones | Uso de preferencias y hechos vitales para recomendaciones personalizadas. |

## Información

| Área | Información | Origen | Cláusula inicial | Cláusula JCCM | Cláusula AGE | Cláusula recomendaciones |
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

| Área | Información | Origen | Cláusula inicial | Cláusula JCCM | Cláusula AGE | Cláusula recomendaciones |
| --- | --- | --- | --- | --- | --- | --- |
| Carnet | Discapacidad | JCCM | Sí | Sí | No | No |
| Carnet | Familia Numerosa | JCCM | Sí | Sí | No | No |
| Carnet | Joven | JCCM | Sí | Sí | No | No |

## Agenda

| Área | Información | Origen | Cláusula inicial | Cláusula JCCM | Cláusula AGE | Cláusula recomendaciones |
| --- | --- | --- | --- | --- | --- | --- |
| Agenda | Notificaciones | JCCM | Sí | No | No | No |
| Agenda | Carnet discapacidad | JCCM | Sí | Sí | No | No |
| Agenda | Carnet familia numerosa | JCCM | Sí | Sí | No | No |
| Agenda | Carnet joven | JCCM | Sí | Sí | No | No |
| Agenda | Citas primaria | JCCM | Sí | Sí | No | No |

## Recomendaciones

| Área | Información | Origen | Cláusula inicial | Cláusula JCCM | Cláusula AGE | Cláusula recomendaciones |
| --- | --- | --- | --- | --- | --- | --- |
| Recomendaciones | Recomendaciones | JCCM | Sí | No | No | Sí |

## Regla de evaluación prevista

Para una ruta o funcionalidad concreta, `app_routes` debe permitir el acceso solo si el ciudadano ha aceptado todas las cláusulas marcadas como `Sí` para esa funcionalidad.

Ejemplos:

- `Notificaciones`: requiere cláusula `1`.
- `Citas primaria`: requiere cláusulas `1` y `2`.
- `Títulos Universitarios`: requiere cláusulas `1` y `3`.
- `Recomendaciones`: requiere cláusulas `1` y `4`.

Si el ciudadano no ha aceptado una cláusula requerida, la ruta debería bloquear el acceso a esa funcionalidad concreta, no cerrar sesión ni forzar a repetir todo el onboarding legal.
