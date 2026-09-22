# Sesión compartida con TMB Agent

El punto de entrada carga `access-entry.js`, que reutiliza directamente
`/tmb-agent/src/session.js`: Supabase Auth valida el token y la tabla existente
`solicitudes_acceso` debe autorizar al usuario. Sin autorización se abre el
formulario original, ahora alojado en TMB Agent, con retorno a Incidencias.
No se transmiten tokens por URL ni se confía en la procedencia del visitante.

Solo después se carga el Flutter existente. Su restauración de sesión y su
comprobación interna de autorización permanecen como segunda comprobación.
El bundle compilado no se recompila: el repositorio contiene el sitio exportado,
y la copia local de fuentes no coincide con ese bundle. El formulario legado
sigue incluido en él, pero el acceso normal pasa por el formulario compartido.
No se cambian navegación, datos ni funcionalidades de Incidencias.

Se oculta la aplicación durante comprobaciones, al abandonar la página y ante
errores de red. Se revisan cambios de sesión, retorno a la pestaña y autorización
periódicamente. Un cierre de sesión desde el Flutter se detecta también en esta
pestaña. Navegadores o perfiles distintos no comparten localStorage.

Esto es control de entrada de una web estática, no protección de sus archivos
públicos. Los datos protegidos dependen de las reglas RLS y funciones existentes
del backend. No se modifica ese backend ni se añaden secretos al frontend.

Pruebas focalizadas: `node --test tests/access-gate.test.mjs`.
