# Resumen de Funcionalidades - Carpeta Ciudadana CLM
## Para Presentación PowerPoint

---

## 1. Dashboard / Inicio

**Objetivo:** Vista principal que agrupa toda la información del ciudadano por áreas temáticas

**Qué incluye:**
• Educación: Títulos universitarios y no universitarios
• Salud: Citas médicas y tarjeta sanitaria
• Familia y Bienestar: Familia numerosa, discapacidad
• Empleo: Situación como demandante de empleo
• Vivienda y Vehículos: Datos catastrales y vehículos registrados
• Navegación rápida a cada sección de detalle

**Características:**
• 9 servicios federados integrados
• Actualización en tiempo real
• Manejo de errores parciales (si un servicio falla, los demás siguen funcionando)
• Estados vacíos cuando el ciudadano no tiene datos

---

## 2. Mi Agenda

**Objetivo:** Consulta de citas médicas y acceso a la tarjeta sanitaria

**Qué incluye:**
• Listado de citas futuras
• Historial de citas pasadas
• Visualización de la Tarjeta CIP (tarjeta sanitaria)
• Filtros por período (última semana, mes, año)

**Características:**
• Dos pestañas: Citas futuras / Citas pasadas
• Ordenación cronológica
• Detalle completo de cada cita (centro, especialidad, fecha/hora)
• Visualización del CIP como imagen descargable

---

## 3. Mis Gestiones / Expedientes

**Objetivo:** Acceso a todos los expedientes administrativos del ciudadano

**Qué incluye:**
• Expedientes generales del ciudadano
• Entradas de registro (documentación presentada)
• Salidas de registro (notificaciones recibidas)
• Subir documentos asociados a expedientes

**Características:**
• Tres pestañas de organización
• Búsqueda y filtrado
• Carga de hasta 5 archivos (PDF, DOC, DOCX, ZIP, XLS, XLSX)
• Validación de hash antes de subida
• Límite: 50MB por archivo

---

## 4. Consulta de Expedientes

**Objetivo:** Búsqueda de expedientes por diferentes criterios

**Qué incluye:**
• Búsqueda por NIF/NIE del ciudadano
• Búsqueda por número de expediente
• Búsqueda por número de registro
• Acceso al detalle completo
• Posibilidad de aportar documentación

**Características:**
• Formulario con validación de inputs
• Resultados en lista navegable
• Reutiliza servicios de Mis Gestiones
• Permite adjuntar documentos desde la búsqueda

---

## 5. Notificaciones

**Objetivo:** Centro de notificaciones administrativas del ciudadano

**Qué incluye:**
• Listado de todas las notificaciones
• Filtros por estado: Pendientes, Aceptadas, Expiradas
• Detalle de cada notificación
• Descarga de documentos asociados

**Características:**
• Filtrado local por estado
• Marcado visual de notificaciones no leídas
• Acceso directo a documentos firmados
• Ordenación por fecha de recepción

---

## 6. Mi Carnet Digital

**Objetivo:** Gestión de carnets digitales oficiales

**Qué incluye:**
• Carnet de Familia Numerosa
• Certificado de Discapacidad con grado
• Carnet Joven de Castilla-La Mancha
• Generación de códigos QR
• Descarga en PDF
• Integración con Apple Wallet / Google Pay (PKPass)

**Características:**
• Vista de galería con miniaturas
• Detalle individual de cada carnet
• Exportación en múltiples formatos
• Añadir directamente a la wallet del móvil
• Vista previa antes de descargar

---

## 7. Mis Recomendaciones

**Objetivo:** Trámites personalizados según la situación vital del ciudadano

**Qué incluye:**
• Lista de trámites recomendados basados en hechos vitales
• Filtro por últimos días
• Filtro por novedades
• Filtro por tramitación inmediata
• Agrupación por categoría (hecho vital)

**Características:**
• Personalización basada en perfil del ciudadano
• Información de plazos de cada trámite
• Enlaces a información detallada
• Unidad responsable y punto de contacto
• Requiere configuración previa de Hechos Vitales (pantalla 8)

---

## 8. Mis Hechos Vitales

**Objetivo:** Configuración del perfil personal para recibir recomendaciones

**Qué incluye:**
• Selección de situaciones vitales actuales (tener un hijo, cambiar de trabajo, jubilación, etc.)
• Aceptación de cláusulas de privacidad
• Gestión de preferencias
• Opción de resetear selección

**Características:**
• Interfaz con checkboxes múltiples
• Guardado incremental
• Validación de aceptación de cláusulas
• Sincronización con backend
• Permite activar/desactivar en cualquier momento

---

## 9. Firma Digital

**Objetivo:** Gestión de firma electrónica de documentos oficiales

**Qué incluye:**
• Lista de documentos pendientes de firma
• Validación de certificado electrónico (VEC)
• Proceso de firma mediante sistema Afirma
• Consulta de documentos ya firmados

**Características:**
• Integración con Cl@ve para autenticación
• Redirección a navegador para firma
• Deep linking de vuelta a la app
• Historial de documentos firmados
• Validación de certificados digitales

---

## 10. Condiciones de Uso

**Objetivo:** Información legal y términos del servicio

**Qué incluye:**
• Texto legal completo
• Condiciones de uso de la aplicación
• Política de privacidad
• Autorizaciones requeridas

**Características:**
• Contenido estático local
• Sin requerimiento de conexión
• Scroll para lectura completa
• Enlaces a recursos legales externos

---

## 11. Guía de Ayuda

**Objetivo:** Soporte y ayuda contextual para el usuario

**Qué incluye:**
• Temas de ayuda organizados por categorías
• Buscador local
• Filtros por sección
• Enlaces a vídeos tutoriales
• Recursos de contacto

**Características:**
• Búsqueda fuzzy (tolerante a errores)
• Categorización temática
• Contenido empaquetado en la app
• Funciona sin conexión
• Actualizaciones mediante versiones de la app

---

## 12. Autenticación Cl@ve (Transversal)

**Objetivo:** Sistema de identidad digital oficial

**Qué incluye:**
• Login mediante Cl@ve
• Gestión de sesión con JWT
• Renovación automática de token
• Manejo de sesión expirada
• Cierre de sesión seguro

**Características:**
• Integración OAuth con Cl@ve
• WebView embebida para proceso de login
• Deep linking de retorno
• Almacenamiento seguro de credenciales
• Interceptor automático para añadir token a todas las peticiones
• Gestión de errores 401/403

---

## 13. Infraestructura (Componentes Transversales)

**Objetivo:** Base técnica común para toda la aplicación

**Componentes UI:**
• Loading states (cargando)
• Error states (gestión de errores)
• Empty states (sin datos)
• Cards, listas, botones, formularios, diálogos

**Servicios Base:**
• Cliente HTTP con interceptor JWT
• Parser XML/JSON
• Sistema de caché local
• Logger y Analytics
• Manejo de conectividad

**Lógica Compartida:**
• Retry automático en errores de red
• Pull-to-refresh
• Validación de conectividad
• Gestión global de errores
• Cache offline

---

**Resumen del Proyecto:**
- 11 pantallas funcionales
- 41 servicios de API integrados
- 64 casos de uso implementados
- Estimación total: 662 horas (incluyendo riesgos)
- Duración estimada: 1-2 meses (equipo de 3-4 personas)
