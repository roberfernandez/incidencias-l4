# Recuperación Flutter de Incidències L4

Estado: fuentes recuperadas; validación remota pendiente hasta registrar el resultado de Actions.

## Referencia y límites
Referencia funcional: `0a5af5e5690e513afce9ef9a98f4c104037caddc`.
Rama de trabajo: `recovery/flutter-20261021`.
Los 151 archivos del árbol publicado se conservan sin cambios en la raíz.
No se ha modificado Supabase ni la configuración de Pages. No hay pasos de despliegue.
No fusionar esta rama ni publicar sus artefactos sin autorización.

## Organización
- `app/lib`: las 12 fuentes Dart recuperadas.
- `app/assets`: recursos públicos originales.
- `app/web`: entrada, autenticación web, iconos y retirada de cachés.
- `app/test` y `app/test-web`: pruebas recuperadas, fuentes tipográficas y referencias visuales.
- `app/pubspec.yaml`, `app/pubspec.lock`: dependencias originales.
- `scripts/recovery`: verificación y empaquetado sin publicación.
- `docs/recovery/inventory.json`: inventario y trazabilidad por SHA-256.

## Procedencia y conservación
Se recuperó la entrega final local del 19/10/2026, no la copia antigua de Documents/incidencias.
Sus 135 archivos de aplicación, dependencias y pruebas coinciden byte a byte con el ZIP final de 146 entradas (las otras 11 son documentación histórica).
El bundle conservado junto a estas fuentes coincide con el blob de main.dart.js de 0a5af5e.
Todos los assets de la aplicación coinciden con los recursos de esa publicación.

Se comparó además el ZIP previo e5c6dfc con la entrega final: esta última conserva los cambios posteriores en main.dart, s9000_data.dart, pruebas, referencias visuales y entrada web. No se reaplicaron parches antiguos.
El respaldo de preparación de 153 archivos no se ha podido descargar; no se utiliza como fuente definitiva.

## Configuración privada
Se retiró del fuente una dirección personal utilizada como excepción del formulario legado.
Se sustituyeron únicamente los literales de configuración por valores de compilación:
- `L4_SUPABASE_URL`
- `L4_SUPABASE_PUBLISHABLE_KEY`
- `L4_ADMIN_EMAIL`

Los dos primeros usan valores ficticios en una compilación sin configuración. El correo queda vacío.
Esto permite comprobar la compilación sin credenciales ni conexión al backend.
Para reproducir el comportamiento de acceso original en una futura publicación autorizada deben suministrarse los tres valores correctos fuera del repositorio.
No se ha configurado ningún secreto de GitHub. Una clave publishable es pública; nunca debe sustituirse por service_role o una clave secreta.
Las constantes Dart quedan incluidas en el JavaScript al compilar: no es un almacén de secretos.
No se han subido imágenes de buckets privados. Sus rutas y el visor protegido se conservan.

## Trabajar desde otro ordenador o Work
Clonar el repositorio y seleccionar esta rama; instalar Flutter 3.41.9 (Dart 3.11.5), Node 22 y Python 3.
Desde app:
```sh
flutter pub get --enforce-lockfile
flutter analyze
dart test/s9000_integrity.dart
node --test test-web/access-gate.test.mjs
flutter test
flutter build web --release --base-href /incidencias-l4/ --pwa-strategy=none --no-web-resources-cdn
```
Desde la raíz, ejecutar `python3 scripts/recovery/package_web.py`.
La salida está en `app/build/web`. No copiarla a main.

En Work también se puede editar la rama mediante GitHub. Cada push a recovery/** ejecuta compilación y pruebas en un runner alojado por GitHub, sin TARONJA-PC.
Los artefactos de Actions caducan a los 7 días; las fuentes permanecen en GitHub.

## Publicación futura
La publicación sigue deliberadamente desactivada en este flujo.
Una futura fase autorizada debe suministrar la configuración original, verificar login/sesión y recursos privados en un entorno apropiado, revisar móvil y escritorio y definir una promoción manual del artefacto aprobado.
El artefacto de esta fase usa configuración ficticia y NO es apto para producción.

## Pruebas pendientes de certificar
- Resultado nuevo de GitHub Actions (compilación, análisis, pruebas e integridad).
- Pruebas visuales golden en Linux: las referencias se conservan; no se regeneran para ocultar diferencias.
- Login real, aprobación, sesión horaria, cámara, guardado y carga de imágenes privadas no se prueban contra producción.
- Las pruebas antiguas de cámara sobre JavaScript minificado de la raíz se conservan; la entrega original documenta ocho fallos por identificadores minificados históricos. No forman parte de la suite Dart recuperada.
