import 'dart:io';

import '../lib/data/s9000_data.dart';

void main() {
  var count = 0;
  void check(bool b, String msg) {
    count++;
    if (!b) throw StateError(msg);
  }

  check(
    causasPorRamaS9000['no_desfrena']!.length == 7,
    'No desfrena: exactament 7 causes',
  );
  check(
    causasPorRamaS9000['no_tracciona']!.length == 5,
    'No tracciona: exactament 5 causes',
  );
  check(
    !arbolS9000['pregunta_seta_s9000']!.preguntaOInstruccion.contains(
      'manipulador',
    ),
    'Bolet sense manipulador',
  );
  final graph = <String, Set<String>>{};
  for (final e in arbolS9000.entries) {
    final p = e.value;
    check(e.key == p.id, 'Clau/id: ${e.key}');
    graph[e.key] = {
      if (p.botonSiDestino != null) p.botonSiDestino!,
      if (p.botonNoDestino != null) p.botonNoDestino!,
      for (final o in p.opcions) o.desti,
    };
    for (final d in graph[e.key]!)
      check(arbolS9000.containsKey(d), 'Desti inexistent ${e.key} -> $d');
    if (p.esPregunta)
      check(
        p.botonSiDestino != null && p.botonNoDestino != null,
        'Pregunta sense sortides: ${e.key}',
      );
    if (p.imagenPath != null)
      check(File(p.imagenPath!).existsSync(), 'Imatge absent: ${p.imagenPath}');
    for (final image in p.imatgesManual) {
      check(File(image.path).existsSync(), 'Imatge absent: ${image.path}');
    }
  }
  for (final list in causasPorRamaS9000.values)
    for (final c in list)
      check(
        arbolS9000.containsKey(enlacesCausasAIrS9000[c]),
        'Causa sense destí: $c',
      );
  Set<String> reach(String id) {
    final seen = <String>{};
    void visit(String n) {
      if (!seen.add(n)) return;
      for (final d in graph[n]!) visit(d);
    }

    visit(id);
    return seen;
  }

  void accessible(String root, List<String> ids) {
    final r = reach(root);
    for (final id in ids) check(r.contains(id), 'No accessible $root -> $id');
  }

  accessible('pregunta_seta_s9000', [
    's9000_aire',
    's9000_fuita',
    's9000_compressor',
    'inicio_tirador',
    'inicio_b19',
  ]);
  accessible('inicio_no_tracciona_s9000', [
    'inicio_lazo_puertas',
    'procedimiento_eed_s9000',
    'procedimiento_tension_nula_s9000',
    'procedimiento_disyuntores_s9000',
  ]);
  final consulta = <String>{
    for (final root in [
      's9000_menu_0',
      's9000_menu_1',
      's9000_menu_2',
      's9000_menu_3',
      's9000_termics',
      'procedimiento_tren_stop_s9000',
      'inicio_tirador',
    ])
      ...reach(root),
  };
  for (final id in [
    's9000_convertidor',
    's9000_compressor',
    's9000_fre_electric',
    's9000_portes_seleccio',
    's9000_portes_permis',
    's9000_km0',
    's9000_condemnar',
    's9000_fuita_enganxall',
    's9000_fuita_mb',
    's9000_fuita_r',
    's9000_fuita_ma',
    's9000_remolc_socors',
    's9000_remolc_avariat',
    's9000_desacoblament',
    's9000_traccio',
    's9000_pantograf',
    's9000_hvac',
    's9000_video',
    's9000_anunciador',
    's9000_ddu',
    's9000_cabina',
    's9000_termics_ma',
    's9000_termics_mb',
    's9000_termics_r',
  ])
    check(consulta.contains(id), 'Procediment no accessible: $id');
  check(
    arbolS9000['pregunta_tdp_s9000']!.botonSiDestino == 's9000_aire',
    'Baixa pressió deriva al fre',
  );
  check(
    !reach('fin_b17').contains('fin_freno_liberado_s9000'),
    'B17 comparteix final B19',
  );
  check(
    arbolS9000['fin_b17']!.preguntaOInstruccion.contains('LLAÇ DE TRACCIÓ'),
    'B17 omet llaç',
  );
  check(
    !arbolS9000['fin_no_tracciona_ccm_s9000']!.preguntaOInstruccion.contains(
      'anul·la tracció/portes',
    ),
    'Anul·lació genèrica',
  );
  check(
    !arbolS9000['fin_no_desfrena_ccm_s9000']!.preguntaOInstruccion.contains(
      '1F11',
    ),
    'Tèrmics S2100',
  );
  check(
    arbolS9000['paso2_tirador']!.preguntaOInstruccion.contains(
      'INTERCOM. ACTIVO',
    ),
    'Comunicacions preexistents perdudes',
  );
  check(
    arbolS9000['fin_tirador']!.botonSiDestino == 's9000_tirador_condicions',
    'Condicions tirador no enllaçades',
  );
  check(
    arbolS9000['fin_modo_socorro']!.preguntaOInstruccion.contains('3 segons') &&
        arbolS9000['fin_modo_socorro']!.preguntaOInstruccion.contains('75 %'),
    'Condicions mode socors',
  );
  for (final id in ['s9000_fuita_mb', 's9000_fuita_r', 's9000_fuita_ma'])
    check(
      reach(id).contains('s9000_pendent') &&
          !reach(id).contains('s9000_resolt'),
      'Fuita aïllada amb final normal',
    );
  final roots = {
    'pregunta_seta_s9000',
    'inicio_no_tracciona_s9000',
    'inicio_menu_modos',
    'inicio_menu_operativa_1',
    's9000_menu_0',
    's9000_menu_1',
    's9000_menu_2',
    's9000_menu_3',
    's9000_termics',
    'procedimiento_tren_stop_s9000',
    'inicio_tirador',
    ...enlacesCausasAIrS9000.values,
  };
  final all = {for (final r in roots) ...reach(r)};
  check(
    all.length == arbolS9000.length,
    'Nodes orfes: ${arbolS9000.keys.toSet().difference(all)}',
  );
  for (final id in graph.keys)
    check(reach(id).any((d) => graph[d]!.isEmpty), 'Bucle sense sortida: $id');
  stdout.writeln(
    'OK: $count comprovacions; ${arbolS9000.length} nodes; ${arbolS9000.values.map((p) => p.imagenPath).whereType<String>().toSet().length} imatges referenciades.',
  );
}
