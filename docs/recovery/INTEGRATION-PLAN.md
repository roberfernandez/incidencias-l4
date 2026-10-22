# Preparación de integración definitiva

Estado: propuesta sin fusión ni despliegue. Rama recovery/flutter-20261021. Base revisada f25af22; TMB Agent contrastado en c07e75666cf774d6088666c2df9c9b2f07761470. No se consultaron datos reales ni se modificó Supabase.

## 1. Contrato que se conserva
- TMB Agent abre https://roberfernandez.github.io/incidencias-l4/ desde src/modules.js.
- Ambas aplicaciones deben mantenerse en el mismo origen HTTPS. Comparten el proyecto y la clave local de sesión sb-<project-ref>-auth-token; cambiar de dominio o de proyecto rompe esta continuidad.
- access-entry.js importa /tmb-agent/src/session.js. El módulo valida el token mediante Auth y consulta el estado de solicitudes_acceso usando la identidad devuelta por el servidor. Aprobado prevalece sobre pendiente/rechazado; los datos del navegador no autorizan por sí solos.
- Una sesión ausente o caducada lleva a /tmb-agent/auth/?returnTo=...; el login admite únicamente /tmb-agent/ y /incidencias-l4/, sin origen externo ni query, conservando el fragmento de navegación.
- Tras aprobarse la puerta web, Flutter vuelve a comprobar la sesión y autorización con AccesoScreen. No se elimina esta segunda comprobación ni el formulario legado.
- Se conservan las comprobaciones horarias, cambio de storage, cierre de sesión en la misma pestaña y restauración de página. Los fallos de red ocultan el contenido. La caducidad puede llevar a reidentificarse: no se introduce una política de renovación diferente.
- El botón de vuelta usa la URL HTTPS de TMB Agent. Una previsualización aislada necesita un mismo origen de pruebas y una sesión de pruebas compatible; el artefacto compilado por sí solo no constituye una aplicación autenticada independiente.
- Las pruebas de contrato usan una revisión fija del módulo real, con todas las respuestas simuladas. No certifican que el sitio desplegado coincida con esa revisión. Revalidar si TMB cambia antes de publicar.

## 2. Configuración de compilación, sin secretos
Se añade scripts/recovery/operational_config.py. Lee L4_SUPABASE_URL y L4_SUPABASE_PUBLISHABLE_KEY del entorno, exige HTTPS y clave publishable y contrasta ambos valores y la clave de almacenamiento con el módulo de sesión revisado. Rechaza valores de ejemplo, claves secretas, tokens legacy y cualquier L4_ADMIN_EMAIL no vacío. No imprime valores ni consulta el backend.

Validar sin compilar, desde la raíz:

    python3 scripts/recovery/operational_config.py --session-module RUTA_AL_CHECKOUT_TMB/src/session.js

Generar únicamente un candidato, en un runner Linux con Flutter 3.41.9 y Python 3:

    python3 scripts/recovery/operational_config.py --session-module RUTA_AL_CHECKOUT_TMB/src/session.js --build

El JSON de defines se crea temporalmente fuera del checkout y se elimina al terminar. Las dependencias quedan bloqueadas, la base es /incidencias-l4/ y se ejecuta el empaquetado existente. El script no publica. Nunca pasar un archivo de sesión obtenido de una fuente no revisada: comprobar el commit de TMB y que sus valores siguen vigentes.

Para GitHub, propuesta de futuro job manual de compilación: checkout del SHA aprobado de L4; checkout separado del SHA aprobado de TMB; Flutter fijado; variables de entorno desde vars.L4_SUPABASE_URL y vars.L4_SUPABASE_PUBLISHABLE_KEY; ejecutar el comando anterior; inspeccionar y guardar app/build/web como artefacto. Son valores públicos de cliente, no secretos de administración. Se recomienda un environment con revisión manual para controlar la promoción. Este job operativo no se ha activado ni se han configurado variables o secretos. El workflow actual continúa generando solo el artefacto ficticio de CI.

### Decisión necesaria sobre el correo
L4_ADMIN_EMAIL es una excepción del filtro de dominio al SOLICITAR acceso, no un permiso de edición ni un requisito del inicio de sesión de una cuenta aprobada. Reintroducir el correo mediante Secret o define lo publicaría dentro del JavaScript. Para retirarlo se propone compilar con la excepción vacía y conservar el login/estado aprobado existentes. Esto cambia la posibilidad de solicitar acceso con ese correo desde el formulario legado: requiere decisión del propietario y prueba con identidad sintética equivalente. No se ha eliminado el mecanismo del código ni modificado ningún usuario.

## 3. Revisión funcional pendiente
| Área | Revisión realizada | Prueba pendiente |
| --- | --- | --- |
| Horarios | Dos RPC identificadas: l4_planificacion_dia y l4_ultimos_pasaje_dia; pruebas de formato, respuesta vacía, fallo y reintento mediante callbacks | Datos sintéticos representativos, filtros, cambio de fecha, último pasaje y respuesta lenta en entorno autorizado |
| Carrusel/fichas | Lecturas de trenes; carga por id; edición de incidencias conservadas | Lectura real, permisos por rol y recarga tras cambios en entorno de pruebas |
| Cámara/galería | Ambos controles y validación previa al guardado probados sin abrir cámara | Cancelación, permiso denegado, JPEG/PNG/WebP y navegador móvil real |
| Persistencia | Alta en trenes tras uploadBinary a composiciones con upsert false; actualizaciones por id | Fallo parcial, duplicados y concurrencia con datos sintéticos; no probar en producción |
| Imágenes privadas | Visor y pruebas previas preservados; bucket manual-incidencies-private con sesión | 57 objetos, autorización/revocación y reintento, sin hacerlos públicos |
| Autenticación | Módulo TMB fijado + puerta L4 probados con respuestas simuladas; restauración Flutter aprobada/rechazada/error | Ida y vuelta en navegador real, caducidad, logout, pestañas, reanudación y ausencia de bucles |

Riesgos existentes identificados, sin alterar procedimientos ni datos:
- asegurarEditor comprueba que existe sesión; la distinción real de permisos depende del servidor/RLS. No se ha auditado RLS por la prohibición de consultar/modificar Supabase. No afirmar que todo usuario autenticado debe poder editar.
- Subida de foto y alta de ficha no son atómicas: una inserción fallida puede dejar un objeto sin ficha. No ejecutar limpiezas automáticas.
- Las incidencias se guardan como texto completo: dos ediciones simultáneas pueden sobrescribirse. Probar concurrencia antes de permitir edición intensiva.
- El bucket composiciones se usa mediante URL pública; revisar que ninguna foto de prueba o foto operativa incluya personas o información privada antes de subirla.

## 4. Privacidad y recursos
RESOURCE-REVIEW.md enumera los 81 assets por nombre y tipo probable: páginas y recortes de manual S9000, fotografías/esquemas/pictogramas, fotos de trenes e iconos. No se ha encontrado evidencia suficiente para certificar autorización de redistribución. Se conservan intactos. Las capturas golden pueden reproducir el mismo material. Las 57 imágenes privadas S2100 no se incorporan.

Para retirar el correo del bundle antiguo sin tocar producción ahora: generar después un candidato con correo vacío, escanear main.dart.js para confirmar su ausencia sin imprimirlo, validar acceso y sustituir el artefacto publicado SOLO tras autorización. Un despliegue nuevo no borra el correo del historial Git, cachés externas ni copias anteriores; no se propone reescribir el historial. Retirar cachés del sitio con el worker conservado, sin borrar la sesión del usuario. La decisión sobre privacidad histórica queda separada de la integración.

## 5. Propuesta concreta de integración y publicación
1. Aprobar la política de correo vacío y permisos de recursos; proporcionar o autorizar un entorno de pruebas con identidades sintéticas. No enviar contraseñas en el chat.
2. Fijar SHA candidato de L4 y SHA de TMB; verificar nuevamente main y su configuración de Pages. Los checks de este trabajo no cambian esos ajustes.
3. Revisar una PR de recovery a main. Su contenido conserva los archivos publicados de la raíz y añade fuentes, pruebas y documentación. La aprobación de esa PR será explícita; no se crea ni fusiona automáticamente. Comprobar antes si cualquier workflow externo o Pages publicaría automáticamente al fusionar: separar entonces la integración de la promoción.
4. Generar el candidato operativo con el validador y las variables públicas coincidentes. No promover el artefacto ficticio de CI. Conservar SHA, checksum y versión del artefacto.
5. Ejecutar la matriz anterior en un origen de pruebas que mantenga las rutas /tmb-agent/ y /incidencias-l4/ y la autenticación real de pruebas. Sin escrituras en producción.
6. Revisar visualmente móvil/escritorio, privacidad del bundle y recursos. Registrar resultados y obtener autorización personal de publicación.
7. Solo en una fase posterior autorizada: promover exactamente el artefacto aprobado mediante un mecanismo manual que no publique el árbol completo con fuentes y pruebas. Mantener disponibles los archivos antiguos necesarios hasta comprobar la retirada de caché. Esta fase no tiene un workflow de despliegue activo.

### Vuelta atrás
Antes de publicar, conservar fuera del PC el artefacto publicado y su checksum/commit (referencia actual 0a5af5e), y los ajustes de hosting vigentes. Si falla acceso, navegación o recursos, detener la promoción y volver a servir el artefacto previo mediante una acción explícita autorizada, sin reset forzado de main ni cambios de base de datos. Confirmar versión servida y caché en móvil y escritorio. Ese rollback recuperaría también el correo del bundle antiguo: documentar este coste de privacidad o preparar previamente un rollback saneado y validado. Un rollback web no revierte escrituras de datos; por eso la validación previa usa solo datos sintéticos.

## Respuestas
1. Compatibilidad de integración: preparada a nivel de código y pruebas automatizadas; pendiente de validación de extremo a extremo en navegador y entorno autorizado. No se ha sustituido autenticación.
2. Se necesita decisión sobre la excepción personal y permisos de los recursos, más un entorno autorizado con datos sintéticos. No se necesitan archivos de TARONJA-PC para compilar.
3. Próximo paso: cerrar esas decisiones y validar un candidato operativo en el entorno de pruebas; después presentar la promoción exacta para autorización. No publicar todavía.
