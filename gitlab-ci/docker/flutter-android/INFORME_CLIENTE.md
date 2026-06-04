# Informe de entrega

## Imagen Docker para compilacion y automatizacion Android

### 1. Objeto del documento

El presente documento describe la imagen Docker entregada para la
automatizacion de procesos de compilacion y ejecucion de jobs sobre el proyecto
Flutter Android.

Su finalidad es servir como referencia funcional para el cliente, explicando
que contiene la imagen, para que sirve, que tareas permite realizar y cuales
son sus limites de uso.

### 2. Descripcion general

Se ha preparado una imagen Docker que encapsula el entorno tecnico necesario
para trabajar con el proyecto de forma controlada y repetible.

La imagen incluye:

- Jenkins LTS como servidor de automatizacion.
- Flutter `3.41.7`.
- Android SDK y herramientas de compilacion.
- Java y Gradle.
- Fastlane y utilidades auxiliares.
- Soporte de autenticacion SSH para acceso a repositorios privados.

La imagen no contiene el codigo fuente del proyecto embebido, sino el entorno
necesario para descargarlo desde el repositorio configurado y ejecutar sobre el
las tareas definidas.

### 3. Objetivo de la solucion

La solucion se ha preparado para cubrir estos objetivos:

- disponer de un entorno unico de compilacion para Android;
- reducir dependencias de configuracion manual en puestos locales;
- poder ejecutar Jenkins de forma inmediata sobre Docker;
- permitir descarga del repositorio y ejecucion de jobs;
- facilitar compilaciones repetibles y trazables;
- dejar preparado un punto de partida para integracion continua.

### 4. Capacidades de la imagen

Con la imagen entregada se pueden realizar las siguientes acciones:

- arrancar una instancia de Jenkins accesible por navegador;
- conectarse por SSH a un repositorio Git privado;
- clonar el repositorio del proyecto;
- lanzar jobs manuales parametrizados;
- ejecutar un pipeline versionado dentro del propio repositorio;
- compilar la aplicacion Android;
- generar artefactos `APK` o `AAB`;
- archivar los artefactos resultantes en Jenkins;
- consultar logs, historico de ejecuciones y resultado de cada build.

### 5. Modos de uso disponibles

La imagen deja disponibles dos formas de trabajo dentro de Jenkins.

#### 5.1. Job pipeline

Se ha preparado un job de tipo pipeline para que Jenkins lea la receta de
compilacion desde el propio repositorio a traves del fichero `Jenkinsfile`.

Este modo es el recomendado para ejecuciones normales del proyecto, ya que:

- la logica del proceso queda versionada junto al codigo;
- los cambios del pipeline se gestionan por ramas y commits;
- el build es mas trazable y mantenible;
- evita depender de configuraciones manuales dentro de Jenkins.

Uso previsto:

- compilaciones ordinarias del proyecto;
- ejecuciones controladas por rama;
- automatizaciones repetibles;
- evoluciones del proceso CI/CD.

#### 5.2. Job freestyle parametrizable

Se ha preparado tambien un job freestyle orientado a pruebas operativas y
ejecuciones manuales.

Este job permite parametrizar:

- repositorio;
- rama;
- profundidad del clone;
- tipo de build (`APK`, `AAB` o comando custom);
- fichero de `dart-define`;
- argumentos extra de build;
- ejecucion opcional de tests;
- limpieza previa del workspace;
- comando shell personalizado.

Uso previsto:

- pruebas puntuales;
- ejecuciones manuales sobre ramas concretas;
- builds con variantes especificas;
- comprobaciones tecnicas ad hoc.

### 6. Flujo de funcionamiento

El funcionamiento general es el siguiente:

1. Se arranca un contenedor a partir de la imagen entregada.
2. Jenkins queda disponible mediante interfaz web.
3. Jenkins utiliza la clave SSH suministrada en tiempo de arranque para acceder
   al repositorio privado.
4. Se lanza un job o pipeline.
5. Jenkins descarga el codigo y ejecuta la compilacion.
6. El artefacto resultante queda disponible como salida del job.

### 7. Beneficios principales

Los beneficios de esta solucion son los siguientes:

- **Estandarizacion del entorno**: todas las ejecuciones utilizan la misma base
  tecnica.
- **Reproducibilidad**: el proceso es repetible sin depender del puesto desde
  el que se lance.
- **Trazabilidad**: Jenkins conserva logs, historico y estado de cada build.
- **Reduccion de configuracion manual**: no es necesario instalar localmente
  todas las herramientas del stack.
- **Separacion entre entorno y codigo**: la imagen aporta el entorno y el
  repositorio aporta la logica del build.

### 8. Requisitos de uso

Para utilizar la imagen correctamente es necesario:

- disponer de Docker operativo;
- contar con acceso al repositorio Git del proyecto;
- proporcionar una clave SSH valida para el repositorio privado;
- disponer de conectividad de red desde el contenedor hacia el servidor Git.

En entornos con restricciones de red, VPN o firewalls, puede ser necesario
adaptar la configuracion SSH o el endpoint remoto utilizado para el acceso al
repositorio.

### 9. Situacion actual y adaptacion al repositorio del cliente

La configuracion actualmente preparada se ha montado y validado contra el
repositorio de desarrollo utilizado durante la implantacion.

Esto significa que:

- los ejemplos de arranque y conexion actualmente apuntan a ese repositorio;
- la clave SSH probada corresponde a ese entorno;
- el pipeline y los jobs han sido verificados sobre esa estructura de ramas y
  ficheros.

Para dejar la solucion operativa sobre el repositorio definitivo del cliente en
GitLab, sera necesario realizar un ajuste de configuracion. No implica rehacer
la imagen desde cero, pero si adaptar su integracion al repositorio final.

Las tareas previstas para esa adaptacion son:

1. Configurar la URL real del repositorio GitLab del cliente.
2. Crear o suministrar la credencial de acceso adecuada para GitLab, bien por
   SSH o por el mecanismo corporativo que se defina.
3. Registrar la clave publica correspondiente en GitLab con los permisos
   necesarios.
4. Ajustar en Jenkins los jobs y el pipeline para que apunten al repositorio y
   ramas definitivas del cliente.
5. Verificar que el `Jenkinsfile` y los parametros de build se corresponden con
   la estructura final del proyecto en GitLab.
6. Validar conectividad de red entre el contenedor y el servidor GitLab del
   cliente, especialmente si existe VPN, firewall o restricciones de salida.
7. Ejecutar una compilacion de validacion completa contra el repositorio del
   cliente.

En funcion de como trabaje el cliente con GitLab, pueden darse dos escenarios:

- **GitLab accesible por SSH estandar**: bastara con sustituir la URL del
  repositorio y registrar la clave correspondiente.
- **GitLab con requisitos corporativos adicionales**: puede ser necesario
  adaptar puertos, politicas de red, credenciales, proxies o certificados.

La recomendacion es considerar esta entrega como una base tecnica ya operativa,
pendiente de una ultima fase de conexion y validacion sobre el repositorio
definitivo del cliente.

### 10. Alcance y limitaciones

El alcance actual de la solucion es:

- compilacion Android del proyecto Flutter;
- automatizacion de jobs y pipelines en Jenkins;
- generacion de artefactos Android.

Queda fuera del alcance de esta imagen:

- compilacion iOS, que requiere un entorno macOS con Xcode;
- publicacion automatica en tiendas, salvo futuras ampliaciones;
- gestion de credenciales corporativas externas no suministradas en el arranque;
- resolucion de restricciones de red ajenas al contenedor.

### 11. Seguridad y gestion de credenciales

La imagen no debe distribuirse con claves privadas embebidas.

La operativa prevista es:

- suministrar claves SSH en tiempo de arranque del contenedor;
- mantener las credenciales fuera de la imagen;
- limitar los permisos de la clave al acceso estrictamente necesario;
- preferir claves dedicadas para automatizacion cuando sea posible.

### 12. Entregables

Como resultado del trabajo se entregan:

- la imagen Docker preparada para Jenkins y compilacion Android;
- la configuracion necesaria para lanzar jobs y pipelines;
- la documentacion de uso;
- la definicion del pipeline versionada en el repositorio;
- un job freestyle parametrizable para ejecuciones manuales.

### 13. Recomendacion de uso

Se recomienda utilizar:

- el **job pipeline** como flujo principal de compilacion del proyecto;
- el **job freestyle** como herramienta de soporte para pruebas y ejecuciones
  manuales.

Con esta separacion se consigue un uso mas ordenado:

- el pipeline queda como referencia oficial del proceso;
- el freestyle queda como utilidad operativa flexible.

### 14. Conclusion

La imagen Docker entregada permite disponer de un entorno funcional de Jenkins
preparado para descargar el repositorio del proyecto, ejecutar compilaciones
Android y generar artefactos de salida de forma repetible, trazable y portable.

La solucion deja cubierto el escenario de automatizacion Android del proyecto y
proporciona una base valida para evolucionar posteriormente hacia un esquema
completo de integracion continua y despliegue.
