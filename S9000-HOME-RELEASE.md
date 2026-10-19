# S9000 · portada compacta · 19/10/2026

Base publicada: `f43f676379bb37a712c690cfee28048f790dd285`.

La pantalla «Què li passa al tren?» presenta diez casillas compactas en dos columnas, con colores distintos: Modes de conducció, Operativa bàsica, Tèrmics, Pictogrames, Equips i serveis, Portes, Aire i frens, Remolcada i desacoblament, Tren Stop y Tirador d'alarma. Carrusel de trens ocupa la última fila completa y reutiliza el botón lila de la serie 2100.

Se eliminan los accesos intermedios Avaries i procediments y Làmines originals del manual. Tèrmics abre directamente el selector MA/MB/R. MA muestra la tabla y la foto real de los térmicos de los coches A; ambas se amplían con el visor existente. Se retira la casilla independiente de imagen de referencia. Esquema equips pasa a Equips i serveis. Remolcada i desacoblament mantiene únicamente esos dos procedimientos. Las imágenes del manual utilizadas por los procedimientos se conservan.

Las casillas compactas mantienen 115 px de alto y el ancho anterior de media fila; las dos casillas de averías no cambian. Se conservan exactamente siete causas en No desfrena y cinco en No tracciona, ATP y el recorrido PEDET con su pregunta inicial de puertas.

Validación: 54 pruebas Flutter aprobadas, 598 comprobaciones de integridad, 10 pruebas de acceso web, análisis sin incidencias y compilación web release correcta con Flutter 3.41.9 / Dart 3.11.5. Se han revisado vistas móvil y escritorio. La comparación de fuentes confirma cero nodos nuevos y 113 nodos existentes intactos; solo cambian los menús de equipos y remolcada y las imágenes de MA, además de retirar los menús y páginas sueltas indicados. El pie de imagen omite la página de manual cuando se trata de una foto sin página.

La prueba antigua `tests/train-camera.test.mjs` depende de nombres minificados históricos: sus ocho fallos se reproducen también sobre el bundle original f43f676. Las fuentes de cámara, guardado y demás pantallas permanecen sin cambios. La capa de acceso, su comprobación horaria y los archivos del motor publicados se conservan; solo se renuevan las claves de caché.

La entrega local incluye `incidencias-fuente.zip` con las fuentes completas recuperadas y actualizadas, pruebas y resultados. `patches/s9000-home-20261019.dart.patch` conserva el cambio sobre la fuente recuperada; `patches/s9000-home-preservation.json` documenta la comparación.
