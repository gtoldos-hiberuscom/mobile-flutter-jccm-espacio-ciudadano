# Cl@ve: cambiar de usuario y cerrar sesión. FAQ por plataforma

**Fecha:** 03/11/2026 · **Versión de referencia:** `0.1.12+14` (`develop`)
**Para quién:** QA, soporte y JCCM. Recoge todos los fallos vistos al cambiar de ciudadano,
al cerrar sesión o cuando la sesión «se queda», y qué hacer en cada caso.

Cada afirmación lleva su grado de certeza: **medido** (reproducido, con fecha), **inferido**
(se deduce de lo medido, pero no se ha probado) o **pendiente**.

Análisis completo en `sso_portales_externos.md` §8 y §10,
`clave_certificado_sso_informe_2026-09-28.md` y `../docs/auth/`.

---

## 0. Lo que hay que saber antes de nada

**La identificación no vive en la app: vive en el navegador.** La app abre Cl@ve en el navegador
del sistema y comparte con él su almacén, que es lo que da el SSO con Empleo y Educamos. Lo
decidió JCCM, que prefirió conservar el SSO (05/10). El precio es que parte de la identidad del
ciudadano anterior puede seguir en ese navegador después de cerrar sesión en la app.

| | Android | iOS |
|---|---|---|
| Dónde se abre Cl@ve | Custom Tab **dentro de Chrome** (o del navegador por defecto) | `SFSafariViewController`, contenedor **de la propia app** |
| ¿Muere al cerrar la app? | **No**: Chrome es otro proceso | Sí |
| ¿De qué depende el comportamiento? | De **Chrome**, no de la versión de Android | Igual en iOS 18 y 26 con la build actual (ver §3) |

Hay **tres capas** de sesión, y la app solo controla la primera:

1. **Cerbero** (Keycloak de JCCM). La app la cierra con «Cerrar sesión», y desde `0.1.9+11`
   también antes de cada login si quedó abierta.
2. **Pasarela Cl@ve**: tiene su propia ventana de autoidentificación de 60 minutos. La app no
   puede cerrarla.
3. **Estado del método**, sobre todo la conexión TLS del **certificado**: vive en el navegador y
   ningún protocolo lo limpia.

---

## 1. Receta rápida: cómo cambiar de usuario

### Android (cualquier versión de Android; depende de Chrome)

1. **Cerrar sesión** en la app (menú de perfil) y esperar a volver a la pantalla de inicio.
2. Si se abrió **Educamos**, cerrar sesión **dentro de Educamos** (la app no puede cerrarla, §2 E-05).
3. Si alguno de los dos usuarios entra **con certificado**: **Ajustes › Aplicaciones › Chrome ›
   Forzar detención**. *Medido 27/10.* Matar nuestra app **no** sirve.
4. Si aun así entra el usuario anterior, o sale el error de Cerbero: **Ajustes › Aplicaciones ›
   Chrome › Almacenamiento › Borrar datos**. *Medido 28/09.* Se pierde todo lo de Chrome
   (sesiones, contraseñas no sincronizadas…), así que es el último recurso.
5. Abrir la app y pulsar **Acceder**.

> Si el navegador por defecto **no es Chrome** (Samsung Internet, Firefox…), los pasos 3 y 4 se
> aplican a **ese** navegador. *Inferido:* el plugin abre el navegador por defecto, pero solo se
> ha medido con Chrome.

### iOS (18 y 26)

1. **Cerrar sesión** en la app.
2. **Cerrar la app** desde el multitarea (deslizar hacia arriba). *Medido en iOS 18.7 y 26.5.*
3. Si se abrió **Educamos**, cerrar sesión **dentro de Educamos**.
4. Abrir la app y pulsar **Acceder**.

> **No vale esperar**: en simulador el estado del certificado se soltaba en ~30 s, pero en
> dispositivo no bastaron ni 30 s ni 1 min (30/09). **Desinstalar la app tampoco** lo suelta
> (medido en iOS 26). Lo que funciona es cerrarla.

---

## 2. Catálogo de fallos

### E-01 · «You are already authenticated as different user '…'. Please sign out first.»

| | |
|---|---|
| **Plataformas** | Android e iOS. Cualquier método de Cl@ve |
| **Cuándo** | Un ciudadano sale **sin pulsar «Cerrar sesión»** (mata la app) y entra otro |
| **Causa** | La sesión de Cerbero sigue en el navegador. Cl@ve identifica bien al nuevo, pero Cerbero corta al volver porque ya tiene a otro |
| **Estado** | **Arreglado en `0.1.9+11`** (JCCMEC-224 / JCCMEC-228, `1aea57c` + `743df9c`): antes de cada login la app cierra en Cerbero la sesión que quedó abierta |
| **Tickets** | JCCMEC-224 (Android), JCCMEC-228 (iOS) |

**Puede volver a salir aunque se tenga la versión arreglada, si:**

- La versión instalada es **anterior a `0.1.9+11`** → actualizar.
- El cierre previo falló por falta de red (no bloquea el login a propósito) → **reintentar**.
- *Inferido, no medido:* en **Android**, si se **desinstaló o se borraron los datos de la app**,
  se pierde la pista con la que cerrar, pero la sesión de Cerbero sigue en Chrome.

**Qué hacer:** Android → borrar datos de Chrome (paso 4 de §1). iOS → cerrar la app y reintentar;
si persiste, reinstalar (*inferido*: el almacén del `SFSafariViewController` es de la app).

---

### E-02 · Al elegir «Certificado», entra con el ciudadano anterior sin mostrar el selector

| | |
|---|---|
| **Plataformas** | Android e iOS. **Solo con certificado** (Cl@ve PIN pidió el flujo completo en la misma prueba, 28/09) |
| **Cuándo** | **Cerrar sesión** y volver a Acceder **sin cerrar la app** (iOS) / **sin parar Chrome** (Android). Sale el selector de métodos, pero no el de certificados |
| **Causa** | El navegador reutiliza el certificado ya elegido. No es la ventana de 60 min de Cl@ve: Cerbero cierra y Cl@ve reautentica (cambia `auth_time`), pero el método no se revalida |
| **Riesgo** | En un móvil compartido, el siguiente entra **como el anterior**. Es silencioso |
| **Estado** | **No se puede arreglar desde la app sin perder el SSO.** El aislamiento lo arregla (medido en Android y en iOS 18, 29-30/09), pero se descartó para conservar el SSO. Vías de fondo: puente SSO en Cerbero, reportar a Cl@ve |

| Plataforma | Qué lo suelta | Qué **no** |
|---|---|---|
| **Android** (Chrome 145 y 156 medidos) | **Forzar detención de Chrome** (27/10, logcat) · Borrar datos de Chrome (28/09) | Matar la app · esperar (ni tras varios minutos ni pasada 1 h) |
| **iOS 18.x** | **Cerrar la app** | Esperar (en dispositivo) |
| **iOS 26.x** | **Cerrar la app** | Esperar · desinstalar la app |

Detalle Android (27/10): el selector del sistema (`KeyChainActivity`) sale **una vez por
proceso de Chrome**, y después Chrome reutiliza el certificado que tiene en memoria. Por eso basta
con parar Chrome. **No es una regresión de Chrome 156**: con 156 borrar datos también lo suelta, y
bajar a 143 «arreglaba» solo porque reinicia Chrome.

Curiosidad medida en iOS (28/09): el camino que más limpia es el peor.

| Secuencia | ¿Pide el certificado? |
|---|---|
| Cerrar sesión → Acceder | **No** |
| Cerrar sesión → **cerrar la app** → Acceder | Sí |
| Cerrar la app sin cerrar sesión → Acceder | Sí (y E-01 ya no ocurre desde `0.1.9+11`) |

**Versiones:** hasta `0.1.5+7` el login era aislado y siempre pedía certificado. Desde `0.1.6+8`
ocurre esto. Por eso, en las mismas fechas, unos probadores podían elegir certificado y otros no.

---

### E-03 · Tras cancelar la elección de certificado: `003002 - Authentication Failed (no certificate has been submitted)` en bucle

| | |
|---|---|
| **Plataformas** | iOS **medido** (28/09). Android **pendiente** |
| **Cuándo** | Al elegir Certificado se cancela el selector (o se elige mal). Cada reintento devuelve `003002` sin volver a ofrecer la lista |
| **Causa** | La conexión queda negociada **sin** certificado y el IdP de Cl@ve la reutiliza. Vaciar el almacén del navegador **no** la suelta (medido) |
| **Riesgo** | Le pasa a **cualquiera** que se equivoque, no solo en móviles compartidos, y la salida no es intuitiva |
| **Estado** | No se puede arreglar desde la app. **A reportar a Cl@ve** |

**Qué hacer:** iOS → **cerrar la app** (o esperar menos de 5 min). Android → **forzar detención de
Chrome** (*inferido* de E-02, sin medir).

---

### E-04 · Cl@ve entra sin pedir nada (sin selector o sin PIN) dentro de la hora siguiente

| | |
|---|---|
| **Plataformas** | Ambas |
| **Cuándo** | Nuevo login a menos de **60 min** de la identificación anterior. La propia pasarela lo dice al pie del selector: «La identificación se realizará automáticamente si no han pasado más de 60 minutos desde su última identificación» |
| **Medido** | En iPhone (30/09), sin aislamiento, entra directo dentro de la ventana. **Pero** el 28/09, tras cerrar sesión, Cl@ve PIN pidió el flujo completo. **El comportamiento no es consistente** |
| **Causa** | Cookie de la pasarela Cl@ve en el navegador. El `ForceAuthn` (desde 18/09 se envía bien, `prompt=login`) debería impedirlo |
| **Estado** | No se puede arreglar desde la app. Pendiente de aclarar con Cl@ve/Cerbero por qué a veces no se respeta el `ForceAuthn` |

**Qué hacer:** Android → borrar datos de Chrome. iOS → **pendiente**: no hay remedio medido salvo
esperar a que pase la hora. Reinstalar la app es candidato (*inferido*).

> Para QA: cualquier prueba de «¿pide credenciales al volver a entrar?» tiene que hacerse
> **dentro** de esos 60 minutos. Si no, el resultado es un falso positivo.

---

### E-05 · Educamos sigue mostrando al usuario anterior

| | |
|---|---|
| **Plataformas** | Ambas (medido 28/09 y en las capturas de JCCMEC-224) |
| **Cuándo** | Tras cambiar de ciudadano en la app, Empleo CLM sí cambia de usuario, pero **Educamos CLM no** |
| **Causa** | Educamos usa el realm `educacion` de Cerbero, que no cierra nadie: ni «Cerrar sesión» ni el cierre previo al login. La app no tiene credencial sobre esa sesión |
| **Riesgo** | Privacidad: se ven **datos educativos de otra persona** |
| **Estado** | No se puede arreglar desde la app. Corresponde a Educamos/Cerbero (propagar el cierre de sesión) |

**Qué hacer:** antes de cambiar de usuario, **cerrar sesión dentro de Educamos**. Android, como
último recurso → borrar datos de Chrome.

---

### E-06 · Al verificar la identidad (elevar el nivel), se identifica otra persona

| | |
|---|---|
| **Plataformas** | Ambas |
| **Cuándo** | Citas hospitalarias, Agenda o Mi Salud Digital piden verificar la identidad, y en Cl@ve se usa el certificado o las credenciales de **otra persona** (a menudo por E-02: el certificado anterior se reutiliza) |
| **Hasta `0.1.11+13`** | La app rechazaba la sesión y **cerraba sesión sin explicar nada** |
| **Desde `0.1.12+14`** | Hace lo que la web: **la sesión pasa a ser de quien se identificó**, vuelve al inicio con un aviso, y el acceso rápido del anterior se borra (JCCMEC-278, `d13300f`) |

**Qué hacer:** si no se quería cambiar de persona, cerrar sesión y aplicar la receta de §1 antes
de volver a verificar.

---

### E-07 · Android: pide la huella justo después de Cl@ve y, si se cancela, se queda cargando

| | |
|---|---|
| **Cuándo** | Cerrar sesión → matar la app → login con Cl@ve → huella → «Cancelar» → spinner infinito |
| **Causa** | El primer acceso del proceso al almacén biométrico de `flutter_secure_storage`, y un fallo del plugin al cancelar |
| **Estado** | **Arreglado en `0.1.10+12`** (`6850c69` + `9543fa6`): la huella solo se pide al abrir la app |

**Qué hacer:** actualizar. Con una versión anterior, matar la app y volver a entrar.

---

### E-08 · No es de sesión, pero lo parece (solo entornos de prueba)

| Síntoma | Causa | Qué hacer |
|---|---|---|
| **Cl@ve Permanente** no carga («no se encuentra el servidor») en el **móvil físico** con VPN; PIN y certificado sí van | El perfil de Ivanti móvil no resuelve `*.dev.seg-social.gob.es` (UAT/PRE). No pasa en emulador ni simulador | Probar Permanente en emulador o simulador. Es una cuestión de Redes, no de la app |
| Pasarela lenta o «Se ha producido un error… null» | Fallos transitorios de red del entorno | Abrir la misma URL en el navegador del dispositivo: si va igual de mal, no es la app. Repetir pasado un rato |

---

## 3. Por versión de sistema y navegador

| | Comportamiento con la build actual |
|---|---|
| **Android** (todas las versiones) | E-02 y E-04 dependen de **Chrome**, no de Android (el estado vive en el proceso y el almacén de Chrome). E-02 se ha medido en un emulador con Android 17 (Chrome 145 y 156) y en un Samsung de un probador con Chrome 156. Con otras combinaciones no se ha medido, pero no hay nada que apunte a una diferencia |
| **iOS 18.x** | E-02: lo suelta cerrar la app |
| **iOS 26.x** | E-02: igual. **Aviso para el futuro:** si se volviera a aislar el login, en iOS 18 eso arregla E-02, pero en iOS 26 **no basta** (Apple dejó de aislar el certificado TLS en la sesión efímera; medido 30/09). Cerrar la app sigue siendo lo que funciona |

---

## 4. Para QA: cómo probar sin engañarse

1. **Preguntar «¿qué nombre aparece en pantalla?»**, no «¿ha entrado?».
2. **Probar con certificado** además de PIN: es el único método afectado por E-02 y E-03.
3. En Android, **tener ≥ 2 certificados** instalados. Para confirmarlo, mirar en logcat
   `I/KeyChain: Requested by app uid … / User chose:`.
4. **Medir con cronómetro** en iOS: dar por buena una prueba porque «se ha soltado» puede ser solo
   el tiempo que pasó compilando.
5. `auth_time` **no** demuestra que se pidiera el certificado: cambia en todos los logins aunque el
   método no se revalide.
6. Repetir con la **secuencia exacta** del ciudadano (cerrar sesión ≠ matar la app; §2 E-02).
7. Android con VPN en emulador: arrancar con `-dns-server 172.24.4.158` y
   `adb shell settings put global private_dns_mode off`. Partir de limpio con
   `adb shell pm clear com.android.chrome`, o `adb shell am force-stop com.android.chrome` si solo
   hace falta soltar el certificado.

---

## 5. Pendiente

- E-03 en Android: confirmar que forzar la detención de Chrome suelta `003002`.
- E-04: por qué la pasarela a veces autoidentifica pese al `ForceAuthn`, y qué la suelta en iOS.
- E-01 tras reinstalar la app en Android: confirmar que reaparece.
- Navegador por defecto distinto de Chrome (parque Samsung): medir dónde queda el estado.
- Reportar a Cl@ve E-02 y E-03, y a Educamos/Cerbero E-05.
- La solución de fondo para tener a la vez SSO y certificado reelegible es el **puente SSO en
  Cerbero** (`sso_portales_externos.md` §6, Opción 1).
