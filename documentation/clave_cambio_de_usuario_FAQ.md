# Cl@ve: cambiar de usuario y cerrar sesión. FAQ por plataforma

**Fecha:** 03/11/2026 · **Versión de referencia:** `0.1.12+14` (`develop`)
**Para quién:** QA, soporte y JCCM. Solo los fallos que **siguen ocurriendo** con la versión
actual al cambiar de ciudadano o al cerrar sesión, y qué hacer en cada caso.

Cada afirmación lleva su grado de certeza: **medido** (reproducido, con fecha), **inferido**
(se deduce de lo medido, pero no se ha probado) o **pendiente**.

Análisis completo en `sso_portales_externos.md` §10 y `clave_certificado_sso_informe_2026-09-28.md`.

---

## Por qué pasa
◊
La identificación no vive en la app, sino en el navegador: la app comparte su almacén para tener
SSO con Empleo y Educamos (decisión de JCCM, 05/10). Parte de la identidad del ciudadano anterior
puede seguir ahí después de cerrar sesión, y la app no puede borrarla.

| | Android | iOS |
|---|---|---|
| Dónde se abre Cl@ve | Custom Tab **dentro de Chrome** | `SFSafariViewController`, contenedor **de la propia app** |
| ¿Se limpia al cerrar la app? | **No**: Chrome es otro proceso | Sí |
| Depende de | La versión de **Chrome**, no la de Android | Igual en iOS 18 y 26 |

---

## Receta: cómo cambiar de usuario

### Android

1. **Cerrar sesión** en la app y esperar a volver a la pantalla de inicio.
2. Si se abrió **Educamos**, cerrar sesión **dentro de Educamos** (E-04).
3. Si alguno de los dos usuarios entra **con certificado**: **Ajustes › Aplicaciones › Chrome ›
   Forzar detención**. *Medido 27/10.* Matar nuestra app **no** sirve.
4. Si aun así entra el usuario anterior: **Ajustes › Aplicaciones › Chrome › Almacenamiento ›
   Borrar datos**. *Medido 28/09.* Se pierde todo lo de Chrome, así que es el último recurso.
5. Abrir la app y pulsar **Acceder**.

> Si el navegador por defecto **no es Chrome** (Samsung Internet, Firefox…), los pasos 3 y 4 se
> aplican a **ese** navegador. *Inferido*: solo se ha medido con Chrome.

### iOS (18 y 26)

1. **Cerrar sesión** en la app.
2. **Cerrar la app** desde el multitarea (deslizar hacia arriba). *Medido en iOS 18.7 y 26.5.*
3. Si se abrió **Educamos**, cerrar sesión **dentro de Educamos**.
4. Abrir la app y pulsar **Acceder**.

> **No vale esperar**: en un dispositivo real no bastan ni 30 s ni 1 min. **Desinstalar la app
> tampoco** lo soluciona (medido en iOS 26).

---

## Fallos que siguen ocurriendo

### E-01 · Al elegir «Certificado», entra con el ciudadano anterior sin mostrar el selector

| | |
|---|---|
| **Plataformas** | Android e iOS. **Solo con certificado** |
| **Cuándo** | Se cierra sesión y se vuelve a Acceder sin cerrar la app (iOS) o sin parar Chrome (Android). Sale el selector de métodos de Cl@ve, pero no el de certificados |
| **Causa** | El navegador reutiliza el certificado que ya se eligió |
| **Riesgo** | En un móvil compartido, el siguiente ciudadano entra **como el anterior**, sin ningún aviso |
| **¿Se puede arreglar en la app?** | No sin perder el SSO. Hay que reportarlo a Cl@ve; la solución de fondo es el puente SSO en Cerbero |

| Plataforma | Qué lo soluciona | Qué **no** |
|---|---|---|
| **Android** | **Forzar detención de Chrome** · borrar los datos de Chrome | Matar la app · esperar (tampoco pasada una hora) |
| **iOS 18.x** | **Cerrar la app** | Esperar |
| **iOS 26.x** | **Cerrar la app** | Esperar · desinstalar la app |

En iOS importa el orden: *cerrar sesión → Acceder* falla, mientras que *cerrar sesión → cerrar la
app → Acceder* sí pide el certificado.

---

### E-02 · Tras cancelar la elección de certificado: `003002 - Authentication Failed (no certificate has been submitted)` en bucle

| | |
|---|---|
| **Plataformas** | iOS **medido** (28/09). Android **pendiente** |
| **Cuándo** | Se cancela el selector de certificados (o se elige mal). A partir de ahí, cada reintento devuelve `003002` sin volver a mostrar la lista |
| **Riesgo** | Le pasa a **cualquiera** que se equivoque al elegir, y la salida no es intuitiva |
| **¿Se puede arreglar en la app?** | No. Hay que reportarlo a Cl@ve |

**Qué hacer:** iOS → **cerrar la app** (o esperar menos de 5 min). Android → **forzar detención de
Chrome** (*inferido*, sin medir).

---

### E-03 · Cl@ve entra sin pedir nada dentro de la hora siguiente

| | |
|---|---|
| **Plataformas** | Ambas |
| **Cuándo** | Nuevo login a menos de **60 min** de la identificación anterior. La propia pasarela lo avisa al pie del selector |
| **Medido** | En iPhone (30/09) entra directo dentro de esa hora. Pero el 28/09, tras cerrar sesión, Cl@ve PIN pidió el flujo completo. **El comportamiento no es consistente** |
| **¿Se puede arreglar en la app?** | No. Hay que preguntar a Cl@ve/Cerbero por qué a veces no se respeta la orden de volver a autenticar (`ForceAuthn`) |

**Qué hacer:** Android → borrar los datos de Chrome. iOS → **pendiente**: no hay remedio medido
salvo esperar a que pase la hora.

---

### E-04 · Educamos sigue mostrando al usuario anterior

| | |
|---|---|
| **Plataformas** | Ambas (medido 28/09, y en las capturas de JCCMEC-224) |
| **Cuándo** | Después de cambiar de ciudadano en la app, Empleo CLM sí cambia de usuario, pero **Educamos CLM no** |
| **Causa** | Educamos tiene su propia sesión en Cerbero (realm `educacion`), que no cierra nadie |
| **Riesgo** | Privacidad: se ven **datos educativos de otra persona** |
| **¿Se puede arreglar en la app?** | No. Corresponde a Educamos/Cerbero |

**Qué hacer:** antes de cambiar de usuario, **cerrar sesión dentro de Educamos**. En Android, como
último recurso, borrar los datos de Chrome.

---

## Anexo · Propuesta de preguntas frecuentes para la app

Textos para el ciudadano, pensados para la categoría «Acceso y autenticación» de
**Ayuda › Preguntas frecuentes**. Siguen el tono de las que ya hay (`helpFaq*` en `app_es.arb`):
de tú, sin tecnicismos y nombrando la app como «Espacio ciudadano». **Pendiente de revisar por
UX Writing.**

**Notas para implementarlo:**

- Las respuestas con la marca **[Android]** o **[iOS]** son distintas en cada sistema. Hay que
  mostrar solo la del dispositivo, no las dos.
- Los nombres de los menús de Android cambian según el fabricante. Por eso se escribe «o similar».
- La respuesta 3 en Android y la 4 en iOS no están medidas del todo (ver E-02 y E-03). Hay que
  confirmarlas antes de publicar o suavizarlas.
- Claves ARB propuestas entre paréntesis.

---

**1. Comparto el dispositivo con otra persona. ¿Cómo cambio de usuario?**
(`helpFaqSwitchUserQ` / `helpFaqSwitchUserA`)

**[Android]**
> Para que la otra persona entre con su propia identidad:
> 1. En Espacio ciudadano, ve a tu perfil y pulsa «Cerrar sesión».
> 2. Si has usado Educamos CLM, cierra sesión también dentro de Educamos.
> 3. Si has entrado con certificado electrónico, ve a Ajustes › Aplicaciones › Chrome y pulsa
>    «Forzar detención» (o similar).
> 4. Vuelve a Espacio ciudadano y pulsa «Acceder».
>
> Si usas otro navegador por defecto en lugar de Chrome, haz el paso 3 en ese navegador.

**[iOS]**
> Para que la otra persona entre con su propia identidad:
> 1. En Espacio ciudadano, ve a tu perfil y pulsa «Cerrar sesión».
> 2. Cierra la aplicación por completo: desliza hacia arriba desde la parte inferior de la
>    pantalla y retira Espacio ciudadano de la lista.
> 3. Si has usado Educamos CLM, cierra sesión también dentro de Educamos.
> 4. Abre de nuevo Espacio ciudadano y pulsa «Acceder».

---

**2. He cerrado sesión y, al volver a entrar con certificado electrónico, no me deja elegir
certificado o entro con el de otra persona. ¿Qué hago?**
(`helpFaqCertificateReuseQ` / `helpFaqCertificateReuseA`)

**[Android]**
> Chrome recuerda el último certificado utilizado mientras sigue abierto. Ve a Ajustes ›
> Aplicaciones › Chrome y pulsa «Forzar detención» (o similar). Después vuelve a Espacio
> ciudadano y pulsa «Acceder». Esta vez podrás elegir el certificado.
>
> Si sigue sin dejarte elegir, en Ajustes › Aplicaciones › Chrome › Almacenamiento pulsa «Borrar
> datos». Ten en cuenta que así se cierran también las sesiones que tengas abiertas en Chrome.

**[iOS]**
> El dispositivo recuerda el último certificado utilizado mientras la aplicación está abierta.
> Cierra Espacio ciudadano por completo (desliza hacia arriba y retírala de la lista), vuelve a
> abrirla y pulsa «Acceder». Esta vez podrás elegir el certificado.

---

**3. Me aparece el error «003002 - Authentication Failed (no certificate has been submitted)» y
no me deja volver a elegir certificado. ¿Qué hago?**
(`helpFaqCertificateCancelledQ` / `helpFaqCertificateCancelledA`)

**[Android]**
> Ocurre si se cancela o no se completa la elección del certificado. Ve a Ajustes › Aplicaciones ›
> Chrome, pulsa «Forzar detención» (o similar) y vuelve a intentarlo desde Espacio ciudadano.

**[iOS]**
> Ocurre si se cancela o no se completa la elección del certificado. Cierra Espacio ciudadano por
> completo (desliza hacia arriba y retírala de la lista) y vuelve a intentarlo. También puedes
> esperar unos minutos antes de volver a intentarlo.

---

**4. He pulsado «Acceder» y Cl@ve no me ha pedido mis datos. ¿Es normal?**
(`helpFaqClaveAutoLoginQ` / `helpFaqClaveAutoLoginA`)

**[Android]**
> Cl@ve puede identificarte automáticamente si te has identificado en la última hora. Comprueba en
> tu perfil que el nombre que aparece es el tuyo. Si no lo es, cierra sesión y, en Ajustes ›
> Aplicaciones › Chrome › Almacenamiento, pulsa «Borrar datos». Después vuelve a pulsar «Acceder».

**[iOS]**
> Cl@ve puede identificarte automáticamente si te has identificado en la última hora. Comprueba en
> tu perfil que el nombre que aparece es el tuyo. Si no lo es, cierra sesión, cierra la aplicación
> por completo y espera a que pase una hora desde la última identificación antes de volver a
> acceder.

---

**5. Al abrir Educamos CLM aparecen los datos de otra persona. ¿Por qué?**
(`helpFaqEducamosOtherUserQ` / `helpFaqEducamosOtherUserA`) — misma respuesta en los dos sistemas

> Educamos CLM tiene su propia sesión, independiente de Espacio ciudadano, y no se cierra al cerrar
> sesión en la aplicación. Antes de que otra persona use el dispositivo, cierra sesión también
> dentro de Educamos CLM.
