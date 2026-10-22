part of 's2100_data.dart';

const cotxes2100 = ['MA1', 'MB1', 'R', 'MB2', 'MA2'];

/// Cab and car are explicit choices in the navigation graph. Going back cannot
/// leave a hidden, stale cab/car selection behind in another procedure.
String? rutaFre2100(String cotxe, String cabina) {
  if (!cotxes2100.contains(cotxe) || !['MA1', 'MA2'].contains(cabina))
    return null;
  final propers = cabina == 'MA1' ? ['MA1', 'MB1'] : ['MA2', 'MB2'];
  return propers.contains(cotxe) ? 'sac14_1f11' : 'sac14_b12';
}

PasoDiagnostico copiarPasCotxe(
  PasoDiagnostico p,
  String id,
  String cotxe, {
  String? text,
  String? seguent,
}) => PasoDiagnostico(
  id: id,
  preguntaOInstruccion: 'Cotxe: $cotxe\n\n${text ?? p.preguntaOInstruccion}',
  esPregunta: p.esPregunta,
  botonSiDestino: seguent ?? p.botonSiDestino,
  botonNoDestino: p.botonNoDestino,
  advertencia: p.advertencia,
  imagenPath: p.imagenPath,
  imatgesManual: p.imatgesManual
      .where((i) => i.cotxes.isEmpty || i.cotxes.contains(cotxe))
      .toList(),
  causaDescartadaAlSi: p.causaDescartadaAlSi,
  causaDescartadaAlNo: p.causaDescartadaAlNo,
  separarTextoTrenStop: p.separarTextoTrenStop,
  opcions: p.opcions,
);

Map<String, PasoDiagnostico> configurarCotxes2100(
  Map<String, PasoDiagnostico> source,
) {
  final nodes = Map<String, PasoDiagnostico>.from(source);
  void selector(String id, String Function(String) desti) {
    nodes[id] = PasoDiagnostico(
      id: id,
      preguntaOInstruccion: id == 'sac02_un'
          ? 'Quin cotxe apareix inhibit al DISPLAY?'
          : 'Quin cotxe està afectat?',
      esPregunta: false,
      opcions: [
        for (final c in cotxes2100) OpcioSac(c, desti(c)),
        const OpcioSac('No identificat', 'sac_pendent'),
      ],
    );
  }

  // These existing shared procedures retain their actions and illustrations.
  for (final entry in {
    'procedimiento_b12_esquema': [
      'procedimiento_b12_ma',
      'procedimiento_b12_mb_r',
    ],
    'pregunta_b19_es_ma': ['procedimiento_b19_ma', 'procedimiento_b19_mb_r'],
    'pregunta_b17_es_ma': ['procedimiento_b17_ma', 'procedimiento_b17_mb_r'],
  }.entries) {
    selector(entry.key, (c) {
      final original = source[entry.value[c == 'MA1' || c == 'MA2' ? 0 : 1]]!;
      final id = '${entry.key}_$c';
      nodes[id] = copiarPasCotxe(original, id, c);
      return id;
    });
  }
  // All entry points (SAC, BAHASTE and PEDET) still target the same node IDs.
  for (final id in [
    'sac02_un',
    'sac08_objecte',
    'sac08_evacuacio_cotxe',
    'sac12',
    'sac13_un_pressio',
    'sac16_continua',
    'sac19_09',
    'sac19_11',
    'sac19_13',
    'procedimiento_eed_rearmar',
  ]) {
    final original = source[id];
    if (original == null) continue;
    selector(id, (c) {
      // Do not apply a MA-only procedure to another type of car.
      if (id == 'sac19_13' && c != 'MA1' && c != 'MA2')
        return 'sac_cotxe_incompatible';
      final dest = '${id}_$c';
      nodes[dest] = copiarPasCotxe(original, dest, c);
      return dest;
    });
  }
  nodes['sac_cotxe_incompatible'] = PasoDiagnostico(
    id: 'sac_cotxe_incompatible',
    preguntaOInstruccion:
        'La informació seleccionada no permet aplicar aquest procediment al cotxe indicat. Revisa el DISPLAY abans de continuar.',
    esPregunta: false,
  );

  selector('sac14', (c) {
    final cabNode = 'sac14_cabina_$c';
    nodes[cabNode] = PasoDiagnostico(
      id: cabNode,
      preguntaOInstruccion: 'Cotxe: $c\n\nQuina cabina està habilitada?',
      esPregunta: false,
      opcions: [
        for (final cab in ['MA1', 'MA2'])
          OpcioSac(
            cab,
            rutaFre2100(c, cab) == 'sac14_1f11'
                ? 'sac14_viable_${c}_$cab'
                : 'sac14_${c}_$cab',
          ),
        const OpcioSac('No identificada', 'sac_pendent'),
      ],
    );
    for (final cab in ['MA1', 'MA2']) {
      final route = rutaFre2100(c, cab)!;
      final dest = 'sac14_${c}_$cab';
      final mechanical = 'sac14_b12_cotxe_$c';
      nodes[mechanical] = copiarPasCotxe(
        source[c == 'MA1' || c == 'MA2'
            ? 'procedimiento_b12_ma'
            : 'procedimiento_b12_mb_r']!,
        mechanical,
        c,
      );
      if (route == 'sac14_1f11') {
        final viable = 'sac14_viable_${c}_$cab';
        nodes[viable] = PasoDiagnostico(
          id: viable,
          preguntaOInstruccion:
              'Cotxe: $c · Cabina: $cab\n\nÉs viable actuar sobre 1F11 en aquest cotxe? Si correspon actuació mecànica, selecciona No.',
          esPregunta: true,
          botonSiDestino: dest,
          botonNoDestino: mechanical,
        );
      }
      String? next;
      if (route == 'sac14_b12') {
        next = 'sac14_b12_cotxe_$c';
        nodes[next] = copiarPasCotxe(
          source[c == 'MA1' || c == 'MA2'
              ? 'procedimiento_b12_ma'
              : 'procedimiento_b12_mb_r']!,
          next,
          c,
        );
      }
      nodes[dest] = copiarPasCotxe(
        source[route]!,
        dest,
        c,
        text: 'Cabina: $cab\n\n${source[route]!.preguntaOInstruccion}',
        seguent: next,
      );
    }
    return cabNode;
  });
  // Only ask the physical cab where the procedure actually depends on it.
  for (final entry in {
    'sac19_13_pendent': (String text, String cab) => text.replaceAll(
      'cabina contrària',
      'la cabina ${cab == 'MA1' ? 'MA2' : 'MA1'}',
    ),
  }.entries) {
    final original = source[entry.key]!;
    nodes[entry.key] = PasoDiagnostico(
      id: entry.key,
      preguntaOInstruccion: 'Quina cabina està habilitada?',
      esPregunta: false,
      opcions: [
        for (final cab in ['MA1', 'MA2']) OpcioSac(cab, '${entry.key}_$cab'),
        const OpcioSac('No identificada', 'sac_pendent'),
      ],
    );
    for (final cab in ['MA1', 'MA2']) {
      final id = '${entry.key}_$cab';
      nodes[id] = PasoDiagnostico(
        id: id,
        preguntaOInstruccion:
            'Cabina: $cab\n\n${entry.value(original.preguntaOInstruccion, cab)}',
        imatgesManual: original.imatgesManual,
        esPregunta: original.esPregunta,
        botonNoDestino: original.botonNoDestino,
        opcions: original.opcions,
        advertencia: original.advertencia,
        imagenPath: original.imagenPath,
        botonSiDestino: original.botonSiDestino,
      );
    }
  }
  // Reuse the action and private images; each context retains its own outcome.
  void action(String id, String originalId, String next) {
    final p = source[originalId]!;
    nodes[id] = PasoDiagnostico(
      id: id,
      preguntaOInstruccion: p.preguntaOInstruccion,
      esPregunta: false,
      botonSiDestino: next,
      advertencia: p.advertencia,
      imagenPath: p.imagenPath,
      imatgesManual: p.imatgesManual,
    );
  }

  for (final entry in {
    'sac03_reset': 'sac03_reset_ok',
    'sac06_reset': 'sac06_reset_ok',
    'sac08_reset': 'sac08_reset_ok',
  }.entries) {
    action(entry.key, 'sac01_reset', entry.value);
  }
  action('sac16_recuperar', 'sac02_recuperar', 'sac16_recuperar_ok');
  action('sac08_controla', 'inicio_pupitre_fallo', 'sac08_tancament_ok');
  action(
    'sac08_permissio_controla',
    'inicio_pupitre_fallo',
    'sac08_permissio_ok',
  );
  action('sac25_controla', 'inicio_pupitre_fallo', 'sac25_megafonia_ok');
  for (final entry in {
    'sac07_iris': 'sac07_recomprova',
    'sac25_iris': 'sac25_despres_iris',
  }.entries) {
    nodes[entry.key] = PasoDiagnostico(
      id: entry.key,
      preguntaOInstruccion:
          'Tira i rearma el tèrmic IRIS per reiniciar l’equip.\n\nFont: L4 Avaries tècniques, pàg. 47; aplicació a comandament de portes segons criteri operatiu confirmat.',
      esPregunta: false,
      botonSiDestino: entry.value,
      imagenPath: 'manual/s2100/sac_25/termic-iris.png',
    );
  }
  // All-car parking release uses each physical car and the same B19 action.
  for (var i = 0; i < cotxes2100.length; i++) {
    final c = cotxes2100[i];
    final id = 'sac13_b19_$c';
    final original =
        source[c == 'MA1' || c == 'MA2'
            ? 'procedimiento_b19_ma'
            : 'procedimiento_b19_mb_r']!;
    nodes[id] = copiarPasCotxe(original, id, c, seguent: '${id}_ok');
    nodes['${id}_ok'] = PasoDiagnostico(
      id: '${id}_ok',
      preguntaOInstruccion:
          'S’ha alliberat realment l’estacionament del cotxe $c?',
      esPregunta: true,
      botonSiDestino: i + 1 < cotxes2100.length
          ? 'sac13_b19_${cotxes2100[i + 1]}'
          : 'sac13_tots_final',
      botonNoDestino: 'sac_pendent',
    );
  }
  // F13 never loses the mandatory tow after a B12 release.
  selector('sac19_13_b12', (c) {
    if (c != 'MA1' && c != 'MA2') return 'sac_cotxe_incompatible';
    final id = 'sac19_13_b12_$c';
    nodes[id] = copiarPasCotxe(
      source['procedimiento_b12_ma']!,
      id,
      c,
      seguent: 'sac19_13_b12_ok',
    );
    return id;
  });
  nodes['sac19_13_b12_ok'] = PasoDiagnostico(
    id: 'sac19_13_b12_ok',
    preguntaOInstruccion: 'S’ha comprovat l’alliberament amb B12?',
    esPregunta: true,
    botonSiDestino: 'sac19_13_remolcada_final',
    botonNoDestino: 'sac_pendent',
  );
  nodes['sac19_13_remolcada_final'] = PasoDiagnostico(
    id: 'sac19_13_remolcada_final',
    preguntaOInstruccion:
        'B12 aplicades: el cotxe queda sense fre pneumàtic. Cal anul·lació del llaç de fre i REMOLCADA, coordinada amb CCM. No és marxa normal.\n\nFont: L4 Avaries tècniques, pàg. 40.',
    esPregunta: false,
  );
  // A trailer has no traction motor: do not offer motor-coffer recovery for R.
  nodes['sac16_continua_R'] = copiarPasCotxe(
    source['sac16_continua']!,
    'sac16_continua_R',
    'R',
    seguent: 'sac16_R_ok',
  );
  nodes['sac16_R_ok'] = PasoDiagnostico(
    id: 'sac16_R_ok',
    preguntaOInstruccion:
        'S’ha normalitzat l’alarma del cotxe R després de reiniciar l’electrònica de fre?',
    esPregunta: true,
    botonSiDestino: 'sac_resultat_confirmat',
    botonNoDestino: 'sac16_observar',
  );
  return ajustarOperativaSac2100(simplificarUxSac2100(nodes));
}
