# Guia de entrega y uso

## Imagen Docker para Jenkins y compilacion Android

### 1. Objeto del documento

El presente documento unifica la informacion funcional y tecnica asociada a la
imagen Docker preparada para la Junta de Comunidades de Castilla-La Mancha
(JCCM).

Su finalidad es servir como guia total de entrega, explicando:

- que es la imagen;
- que componentes incluye;
- que tareas permite realizar;
- como construirla y arrancarla;
- como utilizar los jobs disponibles;
- que ajustes seran necesarios para conectarla al repositorio definitivo de la
  JCCM.

### 2. Descripcion general

Se ha preparado una imagen Docker que encapsula el entorno tecnico necesario
para automatizar compilaciones Android y ejecuciones de Jenkins sobre un
proyecto Flutter.

La imagen incluye:

- Jenkins LTS como servidor de automatizacion;
- Flutter `3.41.7`;
- Android SDK y herramientas de compilacion;
- Java y Gradle;
- Fastlane y utilidades auxiliares;
- soporte de autenticacion SSH para acceso a repositorios privados.

La imagen no contiene embebido el codigo fuente del proyecto, sino el entorno
de ejecucion necesario para descargarlo desde el repositorio configurado y
trabajar sobre el de forma controlada y repetible.

### 3. Objetivo de la solucion

La solucion se ha preparado para cubrir estos objetivos:

- disponer de un entorno unico de compilacion para Android;
- reducir dependencias de configuracion manual en puestos locales;
- poder ejecutar Jenkins de forma inmediata sobre Docker;
- permitir descarga del repositorio y ejecucion de jobs;
- facilitar compilaciones repetibles y trazables;
- dejar preparada una base valida para evolucionar hacia integracion continua.

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

### 6. Flujo general de funcionamiento

El funcionamiento previsto es el siguiente:

1. Se construye la imagen Docker.
2. Se arranca un contenedor a partir de la imagen entregada.
3. Jenkins queda disponible mediante interfaz web.
4. Jenkins utiliza la clave SSH suministrada en tiempo de arranque para acceder
   al repositorio privado.
5. Se lanza un job o pipeline.
6. Jenkins descarga el codigo y ejecuta la compilacion.
7. El artefacto resultante queda disponible como salida del job.

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

### 8. Requisitos previos

Para utilizar la imagen correctamente deben estar disponibles:

- Docker Desktop o motor Docker equivalente;
- acceso de red al servidor Git de la JCCM;
- una clave SSH con permisos sobre el repositorio;
- el valor de `known_hosts` o conectividad suficiente para generarlo;
- la URL real del repositorio GitLab de la JCCM;
- la rama sobre la que se desee operar.

En entornos con restricciones de red, VPN o firewalls, puede ser necesario
adaptar la configuracion SSH o el endpoint remoto utilizado para el acceso al
repositorio.

### 9. Construccion de la imagen

Desde la raiz del repositorio:

```sh
docker buildx build \
  --progress=plain \
  --load \
  -t jccm-espacio-ciudadano/flutter-android-ci:3.41.7 \
  gitlab-ci/docker/flutter-android
```

### 10. Arranque de Jenkins

Ejemplo de arranque.

Sustituir los valores entre `<>` por los datos reales del entorno de la JCCM:

```sh
docker rm -f jccm-jenkins 2>/dev/null || true
docker volume rm jccm-jenkins-home 2>/dev/null || true

docker run -d \
  --name jccm-jenkins \
  -p 8080:8080 \
  -v jccm-jenkins-home:/var/lib/jenkins \
  -v "<RUTA_CLAVE_PRIVADA_SSH>:/run/secrets/git_ssh_key:ro" \
  -e JENKINS_ADMIN_USER=admin \
  -e JENKINS_ADMIN_PASSWORD=<PASSWORD_ADMIN_JENKINS> \
  -e JENKINS_PIPELINE_REPO_URL=<URL_REPOSITORIO_GITLAB_JCCM> \
  -e JENKINS_PIPELINE_BRANCH=<RAMA_PIPELINE> \
  -e JENKINS_JOB_REPO_URL=<URL_REPOSITORIO_GITLAB_JCCM> \
  -e JENKINS_JOB_BRANCH=<RAMA_FREESTYLE> \
  -e JENKINS_GIT_SSH_PRIVATE_KEY_FILE=/run/secrets/git_ssh_key \
  -e JENKINS_GIT_SSH_PASSPHRASE=<PASSPHRASE_CLAVE_SSH> \
  -e JENKINS_GIT_KNOWN_HOSTS="$(ssh-keyscan <HOST_GITLAB> 2>/dev/null)" \
  jccm-espacio-ciudadano/flutter-android-ci:3.41.7
```

### 11. Verificacion del arranque

Consultar logs:

```sh
docker logs -f jccm-jenkins
```

Se considera correcto cuando Jenkins:

- termina el arranque sin errores;
- deja accesible la interfaz web en `http://localhost:8080`;
- crea el job `flutter-repo-pipeline`;
- deja disponible el job `flutter-repo-job`.

Acceso web:

```txt
http://localhost:8080
```

### 12. Uso de los jobs

#### 12.1. flutter-repo-pipeline

Es el flujo principal. Lee el `Jenkinsfile` del repositorio y ejecuta la receta
de compilacion versionada en Git.

Uso recomendado:

- builds ordinarios;
- ejecuciones repetibles por rama;
- proceso principal de CI/CD.

#### 12.2. flutter-repo-job

Es un job freestyle parametrizable para ejecuciones manuales. Permite definir:

- repositorio;
- rama;
- profundidad del clone;
- `appbundle`, `apk` o comando custom;
- fichero de `dart-define`;
- argumentos extra de build;
- ejecucion de tests;
- limpieza previa del workspace;
- comando shell personalizado.

Uso recomendado:

- pruebas manuales;
- builds puntuales;
- comprobaciones tecnicas o diagnostico.

### 13. Salidas esperadas

Los jobs pueden generar:

- `AAB` para distribucion Android;
- `APK` para instalacion y pruebas;
- logs de ejecucion y trazabilidad completa en Jenkins.

### 14. Exportacion de la imagen

Si se desea entregar la imagen como fichero:

```sh
docker save -o jccm-espacio-ciudadano_flutter-android-ci_3.41.7.tar \
  jccm-espacio-ciudadano/flutter-android-ci:3.41.7
```

Opcionalmente puede comprimirse:

```sh
gzip jccm-espacio-ciudadano_flutter-android-ci_3.41.7.tar
```

La carga posterior en otro entorno puede realizarse con:

```sh
docker load -i jccm-espacio-ciudadano_flutter-android-ci_3.41.7.tar
```

o bien:

```sh
gunzip -c jccm-espacio-ciudadano_flutter-android-ci_3.41.7.tar.gz | docker load
```

### 15. Situacion actual y adaptacion al repositorio de la JCCM

La configuracion actualmente preparada se ha montado y validado contra un
repositorio de desarrollo utilizado durante la implantacion.

Esto significa que:

- los ejemplos iniciales de arranque y conexion se validaron sobre ese
  repositorio;
- la clave SSH probada correspondia a ese entorno;
- el pipeline y los jobs se verificaron sobre esa estructura de ramas y
  ficheros.

Para dejar la solucion operativa sobre el repositorio definitivo de la JCCM en
GitLab, sera necesario realizar un ajuste de configuracion. No implica rehacer
la imagen desde cero, pero si adaptar su integracion al repositorio final.

Las tareas previstas para esa adaptacion son:

1. Configurar la URL real del repositorio GitLab de la JCCM.
2. Crear o suministrar la credencial de acceso adecuada para GitLab, bien por
   SSH o por el mecanismo corporativo que se defina.
3. Registrar la clave publica correspondiente en GitLab con los permisos
   necesarios.
4. Ajustar en Jenkins los jobs y el pipeline para que apunten al repositorio y
   ramas definitivas de la JCCM.
5. Verificar que el `Jenkinsfile` y los parametros de build se corresponden con
   la estructura final del proyecto en GitLab.
6. Validar conectividad de red entre el contenedor y el servidor GitLab de la
   JCCM, especialmente si existe VPN, firewall o restricciones de salida.
7. Ejecutar una compilacion de validacion completa contra el repositorio de la
   JCCM.

En funcion de como trabaje la JCCM con GitLab, pueden darse dos escenarios:

- **GitLab accesible por SSH estandar**: bastara con sustituir la URL del
  repositorio y registrar la clave correspondiente.
- **GitLab con requisitos corporativos adicionales**: puede ser necesario
  adaptar puertos, politicas de red, credenciales, proxies o certificados.

La recomendacion es considerar esta entrega como una base tecnica ya operativa,
pendiente de una ultima fase de conexion y validacion sobre el repositorio
definitivo de la JCCM.

### 16. Alcance y limitaciones

El alcance actual de la solucion es:

- compilacion Android del proyecto Flutter;
- automatizacion de jobs y pipelines en Jenkins;
- generacion de artefactos Android.

Queda fuera del alcance de esta imagen:

- compilacion iOS, que requiere un entorno macOS con Xcode;
- publicacion automatica en tiendas, salvo futuras ampliaciones;
- gestion de credenciales corporativas externas no suministradas en el arranque;
- resolucion de restricciones de red ajenas al contenedor.

### 17. Seguridad y gestion de credenciales

La imagen no debe distribuirse con claves privadas embebidas.

La operativa prevista es:

- suministrar claves SSH en tiempo de arranque del contenedor;
- mantener las credenciales fuera de la imagen;
- limitar los permisos de la clave al acceso estrictamente necesario;
- preferir claves dedicadas para automatizacion cuando sea posible.

### 18. Entregables

Como resultado del trabajo se entregan:

- la imagen Docker preparada para Jenkins y compilacion Android;
- este documento unificado de entrega y uso;
- la definicion del pipeline versionada en el repositorio;
- un job freestyle parametrizable para ejecuciones manuales.

### 19. Recomendacion de uso

Se recomienda utilizar:

- `flutter-repo-pipeline` como flujo principal de compilacion del proyecto;
- `flutter-repo-job` como herramienta auxiliar de soporte.

Con esta separacion se consigue un uso mas ordenado:

- el pipeline queda como referencia oficial del proceso;
- el freestyle queda como utilidad operativa flexible.

### 20. Conclusion

La imagen Docker entregada permite disponer de un entorno funcional de Jenkins
preparado para descargar el repositorio del proyecto, ejecutar compilaciones
Android y generar artefactos de salida de forma repetible, trazable y portable.

La solucion deja cubierto el escenario de automatizacion Android del proyecto y
proporciona una base valida para evolucionar posteriormente hacia un esquema
completo de integracion continua y despliegue.
