part of 's2100_data.dart';

/// Presentation-only composition of the documented S2100 graph. A manoeuvre
/// and its outcome share a screen; technical destinations remain explicit.
/// This is applied only to S2100, after physical-car context is resolved.
Map<String, PasoDiagnostico> simplificarUxSac2100(
  Map<String, PasoDiagnostico> source,
) {
  final nodes = Map<String, PasoDiagnostico>.from(source);
  final redundant = <String>{};

  PasoDiagnostico choices(
    PasoDiagnostico p,
    List<OpcioSac> options, {
    String? text,
    List<ImatgePasManual>? images,
  }) => PasoDiagnostico(
    id: p.id,
    preguntaOInstruccion: text ?? p.preguntaOInstruccion,
    esPregunta: false,
    opcions: options,
    advertencia: p.advertencia,
    imagenPath: p.imagenPath,
    imatgesManual: images ?? p.imatgesManual,
    separarTextoTrenStop: p.separarTextoTrenStop,
  );

  // Do not infer labels or collapse unrelated decisions automatically.
  void merge(String action, String outcome, String yes, String no) {
    final p = nodes[action]!;
    final result = nodes[outcome]!;
    assert(p.botonSiDestino == outcome && !p.esPregunta && p.opcions.isEmpty);
    assert(
      result.esPregunta &&
          result.causaDescartadaAlSi == null &&
          result.causaDescartadaAlNo == null,
    );
    nodes[action] = choices(p, [
      OpcioSac(yes, result.botonSiDestino!),
      OpcioSac(no, result.botonNoDestino!),
    ], text: '${p.preguntaOInstruccion}\n\n${result.preguntaOInstruccion}');
    redundant.add(outcome);
  }

  void nominal(String id, String yes, String no) {
    final p = nodes[id]!;
    assert(
      p.esPregunta &&
          p.causaDescartadaAlSi == null &&
          p.causaDescartadaAlNo == null,
    );
    nodes[id] = choices(p, [
      OpcioSac(yes, p.botonSiDestino!),
      OpcioSac(no, p.botonNoDestino!),
    ]);
  }

  // 07: one physical side check, then one recovery if required.
  nodes['sac07'] = choices(
    nodes['sac07']!,
    const [
      OpcioSac('Costat andana', 'sac07_andana'),
      OpcioSac('Costat via', 'sac07_via'),
    ],
    text:
        'SAC 07 · Comandament portes\n\nIdentifica la porta afectada.\nQuin costat és?\n\nFont: criteri operatiu confirmat.',
  );
  for (final id in ['sac07_andana', 'sac07_via']) {
    merge(id, 'sac07_tensio', 'LA PORTA TÉ TENSIÓ', 'NO TÉ TENSIÓ');
  }
  merge(
    'sac07_iris',
    'sac07_recomprova',
    'TENSIÓ RECUPERADA',
    'CONTINUA SENSE TENSIÓ',
  );

  // 03: preparation is a real safety gate; rearm and outcome share a screen.
  merge(
    'sac03_tots',
    'sac03_zero',
    'PANTÒGRAFS BAIXATS I LÍNIA A 0 V',
    'CONDICIONS NO CONFIRMADES',
  );
  merge('sac03_cofres', 'sac03_ok', 'RECUPERAT', 'CONTINUEN AÏLLATS');
  merge('sac03_reset', 'sac03_reset_ok', 'RECUPERAT', 'NO RECUPERAT');

  // 06: show both instruments and control next to the actual three outcomes.
  final converter = nodes['sac06']!;
  final command = nodes['sac06_con']!;
  nodes['sac06'] = PasoDiagnostico(
    id: 'sac06',
    preguntaOInstruccion:
        '${converter.preguntaOInstruccion}\n\n${command.preguntaOInstruccion}\n\nComprova el rearme i la recuperació del funcionament. Si apareix SAC 05, selecciona aquesta opció: el fusible no rearmarà.',
    esPregunta: false,
    imatgesManual: [
      for (final image in imatgesManual2100['sac06_pendent']!)
        ImatgePasManual(
          image.path,
          image.path.contains('instruments')
              ? 'Instruments de bateria A / B'
              : 'Comandament CONVERTIDOR P.M.M.',
          image.pagina,
          image.variant,
        ),
    ],
    opcions: const [
      OpcioSac('APAREIX SAC 05', 'sac05'),
      OpcioSac('HA REARMAT', 'sac_resultat_confirmat'),
      OpcioSac('NO REARMA', 'sac06_reset_acord'),
    ],
  );
  redundant.addAll(['sac06_con', 'sac06_fusible', 'sac06_ok']);
  merge(
    'sac06_reset',
    'sac06_reset_ok',
    'CONVERTIDOR RECUPERAT',
    'NO RECUPERAT',
  );

  // 08: keep the five scenarios separate; eliminate outcome-only screens.
  for (final id in [
    'sac08_controla',
    ...cotxes2100.map((c) => 'sac08_objecte_$c'),
  ]) {
    merge(
      id,
      'sac08_tancament_ok',
      'NORMALITZADA I RECONEGUDA',
      'CONTINUA MARCANT',
    );
  }
  final open = nodes['sac08_oberta']!;
  nodes['sac08_oberta'] = choices(
    open,
    const [
      OpcioSac('NORMALITZADA I RECONEGUDA', 'sac_resultat_confirmat'),
      OpcioSac('CONTINUA MARCANT', 'sac08_persisteix'),
      OpcioSac('HI HA UN OBJECTE', 'sac08_objecte'),
    ],
    text:
        '${open.preguntaOInstruccion}\n\nComprova que la porta està tancada i reconeguda al SAC/DISPLAY.',
  );
  merge(
    'sac08_permissio_controla',
    'sac08_permissio_ok',
    'PERMISSIÓ RECUPERADA',
    'NO PERMET PERMISSIÓ',
  );
  merge(
    'sac08_reset',
    'sac08_reset_ok',
    'PORTES RECUPERADES',
    'NO RECUPERADES',
  );
  nominal('sac08_seleccio', 'PERMET PERMISSIÓ', 'NO PERMET PERMISSIÓ');
  nominal(
    'sac08_seleccio_zero',
    'SELECCIÓ / PERMISSIÓ RECUPERADA',
    'CONTINUA SENSE PERMISSIÓ',
  );
  nominal('sac08_permissio', 'PERMISSIÓ RECUPERADA', 'NO PERMET PERMISSIÓ');

  merge('sac09', 'sac09_ok', 'FUITA RESOLTA', 'CONTINUA LA FUITA');
  for (final c in cotxes2100) {
    merge('sac12_$c', 'sac12_ok', 'PANTÒGRAF NORMALITZAT', 'NO NORMALITZA');
  }

  // 13: all-car B19 is a single physical round, not ten separate screens.
  final ma = nodes['procedimiento_b19_ma']!;
  final mb = nodes['procedimiento_b19_mb_r']!;
  nodes['sac13_b19_tots'] = PasoDiagnostico(
    id: 'sac13_b19_tots',
    preguntaOInstruccion:
        'Electrovàlvules de tots els cotxes: MA1 – MB1 – R – MB2 – MA2.\n\n${ma.preguntaOInstruccion}\n\n${mb.preguntaOInstruccion}\n\nEn acabar el recorregut, comprova l’alliberament real de TOTS els estacionaments.\n\nFont: L4 Avaries tècniques, pàg. 32.',
    esPregunta: false,
    advertencia: [
      ma.advertencia,
      mb.advertencia,
    ].whereType<String>().toSet().join('\n'),
    imatgesManual: [
      ImatgePasManual(
        ma.imagenPath!,
        'B19 · MA1 / MA2',
        32,
        'S2100 · recurs existent',
        const ['MA1', 'MA2'],
      ),
      ImatgePasManual(
        mb.imagenPath!,
        'B19 · MB1 / R / MB2',
        32,
        'S2100 · recurs existent',
        const ['MB1', 'R', 'MB2'],
      ),
      ...ma.imatgesManual,
      ...mb.imatgesManual,
    ],
    opcions: const [
      OpcioSac('TOTS ALLIBERATS', 'sac_resultat_confirmat'),
      OpcioSac('ALGUN CONTINUA APLICAT', 'sac_pendent'),
    ],
  );
  final alternatives = nodes['sac13_alternatives']!;
  nodes[alternatives.id] = choices(alternatives, [
    for (final option in alternatives.opcions)
      OpcioSac(
        option.text,
        option.desti == 'sac13_b19_MA1' ? 'sac13_b19_tots' : option.desti,
      ),
  ]);
  redundant.addAll([
    for (final c in cotxes2100) ...['sac13_b19_$c', 'sac13_b19_${c}_ok'],
  ]);
  for (final id in ['sac13_tots_cabina', 'sac13_un_cabina']) {
    merge(
      id,
      id == 'sac13_tots_cabina' ? 'sac13_tots_ok' : 'sac13_un_ok',
      'ESTACIONAMENT ALLIBERAT',
      'CONTINUA APLICAT',
    );
  }
  merge(
    'sac13_tots_persisteix',
    'sac13_bolet_ok',
    'TOTS ALLIBERATS',
    'CONTINUA APLICAT',
  );
  merge(
    'sac13_canvi_cabina',
    'sac13_tots_final',
    'TOTS ALLIBERATS',
    'ALGUN CONTINUA APLICAT',
  );

  // 14: explicit operational alternative, retaining car/cab routing.
  for (final id
      in nodes.keys.where((id) => id.startsWith('sac14_viable_')).toList()) {
    final p = nodes[id]!;
    nodes[id] = choices(
      p,
      [
        OpcioSac('REARMAR 1F11', p.botonSiDestino!),
        OpcioSac('ACTUACIÓ MECÀNICA B12', p.botonNoDestino!),
      ],
      text:
          '${p.preguntaOInstruccion.split('\n\n').first}\n\nSelecciona l’actuació aplicable segons la ubicació i l’operativitat. Actua sobre 1F11 només si és viable; si correspon actuació mecànica, utilitza B12.',
    );
  }
  for (final id
      in nodes.keys
          .where(
            (id) =>
                id == 'sac14_1f11' ||
                RegExp(r'^sac14_(MA1|MB1|R|MB2|MA2)_(MA1|MA2)$').hasMatch(id),
          )
          .toList()) {
    if (nodes[id]!.botonSiDestino == 'sac14_ok')
      merge(id, 'sac14_ok', 'DESFRENAMENT RECUPERAT', 'NO RECUPERAT');
  }
  // B12 mechanical work and actual result stay together, preserving the warning.
  for (final id
      in nodes.keys
          .where((id) => nodes[id]!.botonSiDestino == 'b12_resultat')
          .toList()) {
    merge(id, 'b12_resultat', 'ALLIBERAT AMB B12', 'CONTINUA FRENAT');
  }

  for (final c in cotxes2100) {
    merge(
      'sac16_continua_$c',
      c == 'R' ? 'sac16_R_ok' : 'sac16_ok',
      'ALARMA NORMALITZADA',
      'CONTINUA L’ALARMA',
    );
  }
  merge(
    'sac16_recuperar',
    'sac16_recuperar_ok',
    'ALARMA NORMALITZADA',
    'CONTINUA L’ALARMA',
  );

  // 19: never offer inapplicable trailer/MB choices for a MA-only thermal.
  for (final id in ['sac19_13', 'sac19_13_b12']) {
    final p = nodes[id]!;
    nodes[id] = choices(
      p,
      p.opcions
          .where((o) => ['MA1', 'MA2', 'No identificat'].contains(o.text))
          .toList(),
    );
  }
  for (final thermal in ['09', '11', '13']) {
    for (final c in cotxes2100) {
      final id = 'sac19_${thermal}_$c';
      if (nodes.containsKey(id))
        merge(
          id,
          'sac19_${thermal}_ok',
          'HA REARMAT I NORMALITZAT',
          'NO REARMA / NO NORMALITZA',
        );
    }
  }
  merge(
    'sac19_13_cabina',
    'sac19_13_cabina_ok',
    'HA DESFRENAT',
    'NO HA DESFRENAT',
  );
  for (final c in ['MA1', 'MA2']) {
    merge(
      'sac19_13_b12_$c',
      'sac19_13_b12_ok',
      'ALLIBERAT AMB B12',
      'CONTINUA FRENAT',
    );
  }
  merge('sac20', 'sac20_ok', 'HA REPOSAT', 'NO REPOSA');
  merge(
    'sac22_estacio',
    'sac22_ok',
    'TIRADOR REARMAT I RECUPERAT',
    'NO RECUPERAT',
  );
  merge('sac23_remodelat', 'sac23_ok', 'HA REARMAT', 'NO REARMA');
  merge(
    'sac23_anullar',
    'sac23_anullat_ok',
    'RESOLT AMB TREN STOP ANUL·LAT',
    'NO RESOLT',
  );

  // 25: auxiliary closing and PA testing are cumulative, never alternatives.
  final iris = nodes['sac25_iris']!;
  final controla = nodes['inicio_pupitre_fallo']!;
  nodes['sac25_iris'] = choices(
    iris,
    const [
      OpcioSac('BIP-BIP I MEGAFONIA OK', 'sac_resultat_confirmat'),
      OpcioSac('NOMÉS FALLA EL BIP-BIP', 'sac25_canvi'),
      OpcioSac('TAMBÉ FALLA LA MEGAFONIA', 'sac25_iris_ko'),
    ],
    text:
        '${iris.preguntaOInstruccion}\n\nSi cal tancar portes, pots fer servir la controla: el tancament és independent d’IRIS.\n\n${controla.preguntaOInstruccion}\n\nComprova també la megafonia del tren i el tancament de portes. Selecciona el resultat conjunt; usar controla no substitueix la prova de megafonia.',
    images: controla.imatgesManual,
  );
  redundant.addAll([
    'sac25_despres_iris',
    'sac25_controla',
    'sac25_megafonia_ok',
    'sac25_bip_ok',
  ]);
  for (final c in ['ma1', 'ma2'])
    merge(
      'sac25_edp_$c',
      'sac25_edp_ok',
      'ANUNCIS CORRECTES',
      'CONTINUA LA FALLADA',
    );

  merge('sac26', 'sac26_mirall', 'ES TANCA A ~5 KM/H', 'NO ES TANCA');
  merge('sac26_cesis', 'sac26_ok', 'ALARMA NORMALITZADA', 'CONTINUA L’ALARMA');
  merge(
    'sac27_display',
    'sac27_display_ok',
    'DISPLAY RECUPERAT',
    'CONTINUA CONGELAT',
  );
  merge('sac27_pma', 'sac27_pma_ok', 'EQUIPS RECUPERATS', 'NO RECUPERATS');
  final riom = nodes['sac27_riom']!;
  nodes[riom.id] = choices(riom, const [
    OpcioSac('TRACCIONA I DESFRENA · RETIRADA', 'sac27_retirada'),
    OpcioSac('NO TRACCIONA O NO DESFRENA · INFORMAR CCM', 'sac27_retirada'),
  ]);

  // 01/02: only the unambiguous action -> outcome pairs. Recovery and
  // repeated-inhibition decisions remain separate and unchanged.
  merge(
    'procedimiento_rearme_disyuntor',
    'sac01_comprova',
    'DISJUNTOR CONNECTAT',
    'NO CONNECTA',
  );
  merge(
    'sac01_reset',
    'sac01_despres_reset',
    'DISJUNTOR CONNECTAT',
    'NO CONNECTA',
  );
  for (final c in cotxes2100)
    merge('sac02_un_$c', 'sac02_un_ok', 'COTXE RECUPERAT', 'CONTINUA INHIBIT');
  merge(
    'sac02_recuperar',
    'sac02_recuperar_ok',
    'COTXE RECUPERAT',
    'CONTINUA INHIBIT',
  );
  merge(
    'sac02_selector_normalitzar',
    'sac02_selector_ok',
    'EQUIPS RECUPERATS',
    'CONTINUEN INHIBITS',
  );
  final reset = nodes['sac02_reset']!;
  final result = nodes['sac02_reset_resultat']!;
  nodes[reset.id] = choices(
    reset,
    result.opcions,
    text: '${reset.preguntaOInstruccion}\n\n${result.preguntaOInstruccion}',
  );
  redundant.add(result.id);

  // Only remove screens whose incoming links disappeared. Shared diagnostic
  // entry points retain their IDs and continue working from BAHASTE/PEDET.
  bool referenced(String id) => nodes.values.any(
    (p) =>
        p.botonSiDestino == id ||
        p.botonNoDestino == id ||
        p.opcions.any((o) => o.desti == id),
  );
  var changed = true;
  while (changed) {
    changed = false;
    for (final id in redundant.toList()) {
      if (!referenced(id)) {
        nodes.remove(id);
        redundant.remove(id);
        changed = true;
      }
    }
  }
  return nodes;
}
