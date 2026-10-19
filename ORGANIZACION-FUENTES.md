# Incidències L4 — organización del código fuente Flutter

Esta rama `source/flutter` se ha creado el 19/10/2026 a partir del commit publicado `9834fe16ff30d80ca03d16a3134c8dda7d796aa4` para preparar la incorporación del proyecto Flutter original **sin modificar la web publicada**.

## Ramas y finalidad

- `main`: copia del sitio web Flutter compilado y su capa de acceso; mantenerla como referencia de publicación actual.
- `source/flutter`: destinada al código Dart editable, `pubspec.yaml`, recursos permitidos, pruebas y documentación. **No usar esta rama para publicar antes de verificar la compilación y las funciones actuales.**

## Estado de recuperación

- Hay copias recuperadas del proyecto (`incidencias-fuente.zip` y `incidencias-fuente(1).zip`) en los archivos de la conversación de 19/10/2026, además de una consolidación de preparación.
- Ninguna se ha acreditado todavía como fuente exacta del último bundle publicado, especialmente respecto a las correcciones S9000 del commit `9834fe1`.
- Por este motivo no se ha incorporado aún la copia recuperada como fuente definitiva.

## Comprobaciones obligatorias antes de importarla

1. Obtener el **resultado final** del trabajo de edición/compilación y su correspondiente fuente Flutter.
2. Confirmar coincidencia con la aplicación corregida: «No desfrena» 7 causas, «No tracciona» 5, navegación de retorno, ajustes de Bolet y comprobación de sesión horaria.
3. Verificar compilación, pruebas y recursos referenciados.
4. Revisar **secretos, correos y otros datos personales, documentación interna y derechos de redistribución de imágenes**: este repositorio es público. No incorporar imágenes de buckets privados de Supabase.
5. Mantener separada la capa web de autenticación de la aplicación compilada; un build Flutter sin los ajustes de publicación actuales no sustituye el sitio activo.

## Principio de publicación

Los cambios de fuentes no deben modificar automáticamente `main`. Publicar solo mediante un procedimiento explícito, controlado y verificado.
