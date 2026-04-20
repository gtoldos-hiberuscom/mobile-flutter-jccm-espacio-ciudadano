# Planificación del Proyecto - Carpeta Ciudadana CLM

**Fecha de elaboración:** 17 de febrero de 2026  
**Estimación total:** 662 horas (536h base + 126h riesgos)  
**Duración estimada:** 11-12 semanas (~2.5-3 meses)

---

## Composición del Equipo

### Tech Lead
- **Dedicación:** Primera semana (parcial, ~50% tiempo)
- **Responsabilidades:**
  - Definir arquitectura del proyecto
  - Configurar estructura inicial y CI/CD
  - Establecer estándares de código
  - Implementar base de autenticación Cl@ve
  - Sentar las bases de componentes reutilizables
- **Horas totales:** ~20 horas

### Senior Developer
- **Dedicación:** Tiempo completo durante todo el proyecto
- **Responsabilidades:**
  - Integración de APIs complejas (Dashboard, Gestiones, Carnets, Firma)
  - Implementación de servicios críticos
  - Liderazgo técnico de tareas complejas
  - Code review y mentoría de Mid/Junior
  - Testing de integración
- **Horas totales:** ~330 horas

### Mid/Junior Developer
- **Dedicación:** Desde semana 2, tiempo completo
- **Responsabilidades:**
  - Implementación de interfaces de usuario
  - Funcionalidades menos complejas (Agenda, Consulta, Notificaciones)
  - Contenido estático (Condiciones, Guía de Ayuda)
  - Tests UI
  - Soporte en testing E2E
- **Horas totales:** ~312 horas

---

## Cronograma por Fases

### Fase 1: Infraestructura (Semana 1-2)
**Duración:** 10 días laborables  
**Equipo:** Tech Lead (parcial) + Senior + Mid/Junior

**Entregas:**
- ✅ Setup del proyecto con estructura CLEAN Architecture
- ✅ Autenticación Cl@ve (OAuth, JWT, gestión de sesión)
- ✅ HTTP Client con interceptores JWT
- ✅ Componentes UI base (loading, error, empty states, cards)
- ✅ Parsers XML/JSON y sistema de caché

**Horas:** 96h

---

### Fase 2: Dashboard & Mi Agenda (Semana 3-4)
**Duración:** 10 días laborables  
**Equipo:** Senior + Mid/Junior (paralelo)

**Entregas:**
- ✅ Dashboard con integración de 9 APIs federadas
- ✅ UI del Dashboard con bloques temáticos navegables
- ✅ Mi Agenda: Citas futuras, pasadas y CIP
- ✅ Tests unitarios e integración de Dashboard

**Distribución:**
- Senior: Integración APIs + Tests (56h)
- Mid/Junior: UI Dashboard + Mi Agenda (56h)

**Horas:** 112h

---

### Fase 3: Gestiones & Expedientes (Semana 5-6)
**Duración:** 7 días laborables  
**Equipo:** Senior + Mid/Junior (paralelo)

**Entregas:**
- ✅ Mis Gestiones: 7 APIs (expedientes, entradas, salidas, upload)
- ✅ UI de Mis Gestiones con tabs y subida de archivos
- ✅ Consulta de Expedientes con formulario de búsqueda
- ✅ Tests unitarios e integración

**Distribución:**
- Senior: APIs + Tests (40h)
- Mid/Junior: UI + Consulta (40h)

**Horas:** 80h

---

### Fase 4: Carnets & Notificaciones (Semana 7-8)
**Duración:** 6 días laborables  
**Equipo:** Senior + Mid/Junior (paralelo)

**Entregas:**
- ✅ Mi Carnet Digital: 8 APIs (QR, PDF, PKPass, wallet)
- ✅ Notificaciones con filtros y descarga de documentos
- ✅ Tests unitarios e integración

**Distribución:**
- Senior: Carnets + Tests (48h)
- Mid/Junior: Notificaciones (16h)

**Horas:** 64h

---

### Fase 5: Hechos Vitales & Recomendaciones (Semana 9)
**Duración:** 5 días laborables  
**Equipo:** Senior + Mid/Junior (paralelo)

**Entregas:**
- ✅ Mis Hechos Vitales: 6 APIs (GET, PATCH, DELETE)
- ✅ Mis Recomendaciones con filtros
- ✅ Tests unitarios e integración

**Distribución:**
- Senior: Hechos Vitales + Tests (40h)
- Mid/Junior: Recomendaciones (16h)

**Horas:** 56h

---

### Fase 6: Firma Digital (Semana 10)
**Duración:** 6 días laborables  
**Equipo:** Senior + Mid/Junior (paralelo)

**Entregas:**
- ✅ Integración con sistema Afirma
- ✅ Validación de certificados (VEC)
- ✅ UI con redirección a navegador y deep linking
- ✅ Tests unitarios e integración

**Distribución:**
- Senior: Integración Afirma + Tests (48h)
- Mid/Junior: UI (16h)

**Horas:** 64h

---

### Fase 7: Contenido Estático (Semana 9-10)
**Duración:** 2 días laborables  
**Equipo:** Mid/Junior

**Entregas:**
- ✅ Condiciones de Uso (pantalla estática)
- ✅ Guía de Ayuda con búsqueda local

**Horas:** 16h

---

### Fase 8: Testing & QA Final (Semana 11-12)
**Duración:** 11 días laborables  
**Equipo:** Senior + Mid/Junior

**Entregas:**
- ✅ Tests de integración E2E
- ✅ Tests UI completos
- ✅ Buffer para ajustes y resolución de riesgos
- ✅ Revisión final y entrega

**Horas:** 88h (+ 64h ya distribuidas en fases anteriores)

---

## Estrategia de Trabajo en Paralelo

### Semana 1-2: Fundamentos
- **Tech Lead + Senior:** Arquitectura + Autenticación
- **Mid/Junior:** Componentes UI bajo supervisión

### Semana 3-10: Desarrollo Paralelo
- **Senior:** APIs complejas y servicios críticos
- **Mid/Junior:** UI y funcionalidades simples
- **Sincronización:** Reuniones diarias de 15 min

### Semana 11-12: Convergencia
- **Todo el equipo:** Testing conjunto y ajustes finales

---

## Calendario Estimado

| Hito | Fecha Aproximada |
|------|------------------|
| **Inicio del proyecto** | 17 febrero 2026 |
| Fin Fase 1 (Infraestructura) | 28 febrero 2026 |
| Fin Fase 2 (Dashboard) | 14 marzo 2026 |
| Fin Fase 3 (Gestiones) | 24 marzo 2026 |
| Fin Fase 4 (Carnets) | 1 abril 2026 |
| Fin Fase 5 (Hechos Vitales) | 7 abril 2026 |
| Fin Fase 6 (Firma) | 10 abril 2026 |
| **Entrega final** | **15 abril 2026** |

*Nota: Calendario excluye fines de semana y festivos.*

---

## Distribución de Horas Total

| Concepto | Horas |
|----------|-------|
| Infraestructura | 96h |
| Dashboard & Agenda | 112h |
| Gestiones & Expedientes | 80h |
| Carnets & Notificaciones | 64h |
| Hechos Vitales & Recomendaciones | 56h |
| Firma Digital | 64h |
| Contenido Estático | 16h |
| Testing E2E | 64h |
| Buffer Riesgos | 110h |
| **TOTAL** | **662h** |

---

## Ventajas de esta Configuración de Equipo

### ✅ Velocidad
- Trabajo en paralelo reduce tiempo de entrega de ~4 meses a ~2.5 meses
- Tech Lead acelera arranque sin comprometer todo el proyecto

### ✅ Calidad
- Senior asegura integración correcta de APIs críticas
- Code review continuo mejora calidad del código
- Testing distribuido evita deuda técnica

### ✅ Costo-Eficiencia
- Tech Lead solo primera semana (menor costo total)
- Mid/Junior maneja tareas adecuadas a su nivel
- Senior maximiza valor en tareas complejas

### ✅ Mentoría
- Mid/Junior aprende de Senior en tiempo real
- Transferencia de conocimiento continua
- Mejora capacidades del equipo a largo plazo

---

## Riesgos y Mitigaciones

### R1: Respuestas string no estructuradas
- **Impacto:** +16h
- **Mitigación:** Acceso temprano a preproducción en Fase 1

### R2: Endpoint Notificaciones no confirmado
- **Impacto:** +24h
- **Mitigación:** Validación con backend antes de Fase 4

### R3: Parámetro idAgente no formalizado
- **Impacto:** +4h
- **Mitigación:** Confirmación antes de Fase 5

### R4: Servicios Dashboard sin API
- **Impacto:** +10h
- **Mitigación:** Diseño flexible desde inicio

### R5: Inconsistencias documentación API
- **Impacto:** +40h
- **Mitigación:** Buffer distribuido en todo el proyecto

### R6: Gestión ciclo vida sesión Cl@ve
- **Impacto:** +20h
- **Mitigación:** Prioridad en Fase 1

### R7: Restricciones subida ficheros
- **Impacto:** +12h
- **Mitigación:** Validación temprana en Fase 3

**Total buffer riesgos:** 126h (distribuido a lo largo del proyecto)

---

## Supuestos de la Planificación

1. ✅ Equipo disponible desde día 1
2. ✅ Acceso a entorno de preproducción desde semana 1
3. ✅ API estable y disponible
4. ✅ Sin cambios de alcance durante desarrollo
5. ✅ Herramientas de desarrollo configuradas
6. ✅ Jornadas de 8 horas efectivas
7. ✅ Exclusión de fines de semana

---

## Recomendaciones

### Alta Prioridad
1. Confirmar disponibilidad del equipo antes del 17/02/2026
2. Solicitar acceso a preproducción la primera semana
3. Validar endpoints críticos (Notificaciones, Hechos Vitales) en Fase 1
4. Establecer canal de comunicación directa con backend

### Media Prioridad
5. Configurar CI/CD en primera semana
6. Definir estrategia de testing desde inicio
7. Planificar demos semanales con stakeholders

### Baja Prioridad
8. Documentación técnicacontinua
9. Knowledge sharing semanal interno
10. Retrospectivas al final de cada fase

---

*Documento generado el 17 de febrero de 2026.*  
*Planificación sujeta a confirmación de disponibilidad del equipo y acceso a entornos.*
