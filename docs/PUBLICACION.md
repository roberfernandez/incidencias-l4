# Publicar Incidències L4 desde Flutter sin TARONJA-PC

Este sistema **no toca Supabase** y **nunca publica al fusionar una PR ni al modificar main**. La publicación solo puede iniciarse manualmente desde GitHub Actions, eligiendo `publish` y escribiendo la confirmación **PUBLICAR**.

## Flujo normal

1. Crear una rama desde main y modificar los fuentes Flutter. Al abrir una PR, GitHub compila una versión ficticia (solo pruebas), analiza Dart, verifica navegación, TMB Agent y recursos. **No publica nada**.
2. Fusionar la PR después de revisar las pruebas. La web actual no cambia.
3. Desde main abrir **Actions → Incidencies L4 - verificar y publicar manualmente → Run workflow**. Seleccionar `operation = check` para compilar con configuración operativa y guardar un artefacto durante siete días, sin publicarlo.
4. Comprobar el candidato y decidir si hay autorización para publicar. Para publicar: **Run workflow**, seleccionar `operation = publish`, escribir `PUBLICAR` en `confirmation` y, opcionalmente, el SHA completo del commit aprobado en `expected_sha`. El propio workflow **vuelve a pasar pruebas y recompila** antes del despliegue. Si main cambia o la configuración falla, el proceso se detiene sin publicar.

Las pruebas del acceso compartido con TMB Agent se ejecutan con respuestas **simuladas**, no con cuentas ni escrituras reales.

## Preparación, solo una vez

- En **Settings → Secrets and variables → Actions → Secrets**, crear `L4_ADMIN_EMAIL` con la excepción personal que debe mantenerse para solicitar acceso. No enviar aquí la dirección ni contraseñas.
- La URL y la clave **publishable** de Supabase se extraen automáticamente del módulo `src/session.js` de TMB Agent, revisado y fijado en el commit `c07e75666cf774d6088666c2df9c9b2f07761470`. No hay que configurar esos dos valores. Se verifica que URL, clave y nombre de la sesión coinciden. Nunca utilizar `sb_secret_`, `service_role` ni contraseñas.
- **Antes de la primera publicación real**, y solo después de tener un candidato `check` correcto, cambiar en **Settings → Pages → Build and deployment → Source** de «Deploy from a branch» a **GitHub Actions**. Este cambio administrativo necesita autorización expresa. Mientras no se haga, la web sigue publicada desde `pages-production / (root)`. Si se intenta `publish` antes, el workflow aborta sin tocar Pages.
- Se puede configurar el entorno `github-pages` con revisores adicionales en Settings.

**Privacidad:** el secreto de Actions protege el valor en el repositorio y los logs, pero **L4_ADMIN_EMAIL termina incrustado en el JavaScript público** porque la excepción actual se comprueba en el cliente. La web actual ya funciona así. Mantenerla sin exponer su dirección exige una comprobación del lado del servidor, que **no** se implementa en este cambio.

## Qué protege el proceso

- Los tests y la compilación siguen anclados a Flutter 3.41.9 y al lockfile.
- El candidato debe conservar la puerta de acceso, ruta de vuelta a TMB Agent, imagen «Localització al tren», imagen DDU, manifest, iconos y assets.
- No acepta compilación de ejemplo como publicación operativa.
- Solo un `workflow_dispatch` en `main` puede solicitar producción. `publish` necesita la palabra exacta `PUBLICAR`; opcionalmente exige un SHA de main.
- El artefacto publicado es **exactamente el candidato** probado en esa ejecución, no una edición manual de `main.dart.js`.
- El workflow no modifica ni elimina `pages-production`, ni escribe en Supabase. Probar en móvil/escritorio la sesión, imágenes privadas, cámara y escritura antes de autorizar versiones importantes.
- Si cambia el contrato real de TMB Agent, revisar de nuevo el commit anclado.

## Vuelta atrás

La rama `pages-production` conserva la web anterior estable. Si una futura publicación con GitHub Actions falla, cambiar **Settings → Pages → Source** a **Deploy from a branch → pages-production / (root)**, guardar y confirmar que el despliegue termina y la entrada/retorno a TMB Agent funciona.

La vuelta atrás restaura **archivos web**, pero nunca datos escritos en Supabase. No realizar pruebas de escritura en producción.

**No editar a mano los ficheros JS generados.** Cambiar Flutter, probar y publicar con el procedimiento anterior.
