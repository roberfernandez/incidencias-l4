# Cierre de recuperación e integración de fuentes — 22/10/2026

Esta decisión sustituye las propuestas anteriores de eliminar o vaciar L4_ADMIN_EMAIL y de condicionar la integración de fuentes a pruebas de una futura publicación. El propietario exige conservar todos los mecanismos actuales, incluida su excepción de correo personal.

## Integración preparada
Destino main; origen recovery/flutter-20261021. Solo se incorporan fuentes, recursos recuperados, pruebas, scripts y documentación. Los 151 archivos existentes del árbol publicado se mantienen sin cambios respecto a 0a5af5e5690e513afce9ef9a98f4c104037caddc. No se fusiona ni se publica en esta fase.

El único workflow versionado es flutter-recovery.yml: compila y prueba en pushes a recovery/** y pull requests. No tiene pasos de despliegue ni permisos de Pages. Esto NO desactiva el publicador automático administrado por GitHub.

## Bloqueo real de fusión sin despliegue
Verificado en Settings → Pages el 22/10/2026: Source = Deploy from a branch; Branch = main; carpeta = / (root). La última publicación corresponde al workflow pages build and deployment, ejecución 39290596592, commit 0a5af5e.

Con esa configuración no es posible asegurar que fusionar a main no publique: la fusión activaría Pages y podría añadir las nuevas carpetas de fuentes y pruebas al sitio servido. La igualdad de los archivos antiguos no evita el despliegue.

Antes de autorizar la fusión hay que desacoplar Pages de main. Propuesta limitada: pasar la fuente de Pages a GitHub Actions sin añadir ni ejecutar un workflow de despliegue; comprobar que la publicación existente sigue accesible y que no se ha iniciado un despliegue. Este cambio de hosting requiere autorización separada y no se ha realizado. No usar Unpublish ni borrar la rama publicada. Solo después de verificar el desacoplamiento, autorizar y realizar la fusión de la PR.

## Excepción personal conservada
El fuente AccesoScreen mantiene la comparación con L4_ADMIN_EMAIL y el resto de autenticación permanece intacto. No se escribe ni duplica la dirección en el repositorio. El preparador operativo ahora exige que la excepción se proporcione externamente y la transmite sin sustituirla por un valor vacío; los tests usan un marcador sintético. La aplicación publicada sigue conteniendo su excepción original sin alteración.

Una compilación futura incorporará el valor al JavaScript del cliente: una variable o Secret de CI no lo hace privado una vez publicado. La revisión de esa exposición se aplaza a la publicación; no se cambia ni se retira la excepción por iniciativa del agente. En esta fase no se compila ni se publica un artefacto con la dirección personal.

## Pendientes de publicación, no bloqueos de integrar fuentes
Se mantienen documentados en INTEGRATION-PLAN.md, REVIEW-20261021.md y RESOURCE-REVIEW.md: configuración operativa; validación real de sesión, cámara, horarios, fichas, persistencia e imágenes privadas; permisos de recursos; privacidad del bundle y plan de retorno al artefacto anterior. No se abren nuevas investigaciones ni se amplía la recuperación.

La última suite completa antes de este cierre pasó en d7e7a46 (Actions 39723048816): 62 pruebas Flutter, 6 de contrato TMB, 5 de configuración, 10 web y 598 comprobaciones S9000. El ajuste de configuración de este cierre se verifica de nuevo en la PR/CI. Las fuentes funcionales Flutter y sus recursos no se modifican.
