part of 's2100_data.dart';

/// Hide audit metadata only at presentation time; original strings stay intact.
String textOperatiu2100(String text) => text
    .replaceAll(RegExp(r'^\s*Font:[^\n]*', multiLine: true), '')
    .replaceAll(
      RegExp(
        r'(?:manual/[^\s]+|[\w-]+\.(?:png|jpe?g|webp))',
        caseSensitive: false,
      ),
      '',
    )
    .replaceAll(RegExp(r'\n{3,}'), '\n\n')
    .trim();

/// Explicit local corrections requested after the UX review. Shared actions
/// retain their pictures and technical metadata.
Map<String, PasoDiagnostico> ajustarOperativaSac2100(
  Map<String, PasoDiagnostico> source,
) {
  final n = Map<String, PasoDiagnostico>.from(source);
  final aliases = <String, String>{};
  void put(
    String id,
    String text, {
    List<OpcioSac> options = const [],
    PasoDiagnostico? visual,
    String? warning,
    List<ImatgePasManual>? images,
  }) {
    n[id] = PasoDiagnostico(
      id: id,
      preguntaOInstruccion: text,
      esPregunta: false,
      opcions: options,
      advertencia: warning ?? visual?.advertencia,
      imagenPath: visual?.imagenPath,
      imatgesManual: images ?? visual?.imatgesManual ?? const [],
    );
  }

  void choices(String id, List<OpcioSac> options, {String? text}) => put(
    id,
    text ?? n[id]!.preguntaOInstruccion,
    options: options,
    visual: n[id],
  );
  const done = 'sac_resolt';
  put(done, 'Incidència resolta. Funcionament recuperat.');
  // Normal recovery is distinct from an outcome leaving equipment annulled.
  for (final p in source.values) {
    if (p.id == 'sac23_anullar' ||
        p.id == 'sac19_13_cabina' ||
        p.id == 'sac13_b19_tots') {
      continue;
    }
    // References from later SACs are left intact, per requested scope.
    if (RegExp(r'^sac(20|21|23|25|26|27|28|29)').hasMatch(p.id)) continue;
    if (p.opcions.any((o) => o.desti == 'sac_resultat_confirmat')) {
      choices(p.id, [
        for (final o in p.opcions)
          OpcioSac(
            o.text,
            o.desti == 'sac_resultat_confirmat' ? done : o.desti,
          ),
      ]);
    }
  }
  for (final id in ['procedimiento_rearme_disyuntor', 'sac01_reset']) {
    choices(id, [
      const OpcioSac('FUNCIONAMENT RECUPERAT', done),
      OpcioSac(
        "NO S’HA RECUPERAT",
        id == 'sac01_reset' ? 'sac_pendent' : 'sac01_reset',
      ),
    ]);
  }
  aliases['sac01_recuperacio'] = done;

  // 02: repetition is assessed before recovery, not after a successful rearm.
  put(
    'sac02_un',
    'És la tercera inhibició del mateix cotxe?',
    options: const [
      OpcioSac('SÍ · TERCERA INHIBICIÓ', 'sac02_tres_inhibicions'),
      OpcioSac('NO', 'sac02_zero'),
    ],
  );
  final un = source['sac02_un_MA1']!;
  put(
    'sac02_zero',
    'Passa tot per 0, inclosa la clau de govern. Comprova al DISPLAY si el cotxe continua inhibit.',
    visual: un,
    options: const [
      OpcioSac('JA NO APAREIX INHIBIT', done),
      OpcioSac('CONTINUA INHIBIT', 'sac02_seguiment'),
    ],
  );
  choices('sac02_seguiment', const [
    OpcioSac('RECUPERACIÓ ACORDADA AMB PORTACOTXERES', 'sac02_recuperar'),
    OpcioSac('CONTINUAR AMB UN COTXE INHIBIT', 'sac02_continuitat'),
  ]);
  choices('sac02_recuperar', const [
    OpcioSac('JA NO APAREIX INHIBIT', done),
    OpcioSac('CONTINUA INHIBIT', 'sac02_continuitat'),
  ]);
  aliases['sac02_recuperat'] = done;
  aliases['sac02_persisteix'] = 'sac02_continuitat';
  for (final c in cotxes2100) {
    aliases['sac02_un_$c'] = 'sac02_zero';
  }

  // 07: no IRIS reset in the door-without-tension branch.
  for (final id in ['sac07_andana', 'sac07_via']) {
    choices(id, const [
      OpcioSac('LA PORTA TÉ TENSIÓ', 'sac07_normal'),
      OpcioSac('PORTA SENSE TENSIÓ', 'sac07_sense_tensio'),
    ]);
  }
  put(
    'sac07_sense_tensio',
    'No es pot garantir que la porta romangui tancada durant el trajecte.\n\nDesallotja el passatge i coordina amb CCM la retirada del tren.',
  );
  aliases['sac07_iris'] = 'sac07_sense_tensio';
  put(
    'sac08_persisteix',
    'No es recuperen el tancament de portes i la tracció.\n\n1. Desallotja el passatge.\n2. Anul·la el llaç de portes.\n3. Coordina la retirada o el canvi amb CCM.',
  );
  // No image on this action until the user's annulment photograph exists.

  // 12: connection first, valve only after failure; Display identification
  // guides the physical visit, so an identical five-way selector adds nothing.
  final pantoImages = imatgesManual2100['sac12']!
      .where((i) => i.path == 'manual/s2100/sac_12/comandament-pantograf.png')
      .toList();
  assert(pantoImages.isNotEmpty);
  put(
    'sac12',
    'SAC 12 · Fallada posició pantògraf\n\nProva la connexió del pantògraf a la posada en marxa.',
    images: pantoImages,
    options: const [
      OpcioSac('PANTÒGRAF NORMALITZAT', done),
      OpcioSac('NO NORMALITZA', 'sac12_aixeta'),
    ],
  );
  put(
    'sac12_aixeta',
    'Identifica al DISPLAY 12 el cotxe afectat. Dirigeix-te al pantògraf afectat i verifica la seva aixeta.\n\nComprova el resultat.',
    images: const [
      ImatgePasManual(
        'manual/s2100/sac_12/estado-pantografos-2100.jpg',
        'DISPLAY 12 · Estat dels pantògrafs',
        null,
        'S2100 · Aixeta: vermell = tancada, verd = oberta. Pantògraf: vermell = amunt, verd = avall.',
      ),
    ],
    options: const [
      OpcioSac('NORMALITZAT', done),
      OpcioSac('CONTINUA SENSE NORMALITZAR', 'sac12_persisteix'),
    ],
  );
  for (final c in cotxes2100) {
    aliases['sac12_$c'] = 'sac12';
  }

  // 13: preserve normal B19/B17/sirgues; new functional confluence is separate.
  choices('sac13', const [
    OpcioSac('Tots els cotxes', 'sac13_tots_pressio'),
    OpcioSac('Un cotxe', 'sac13_tren_frenat'),
    OpcioSac('No queda clar l’abast', 'sac_pendent'),
  ]);
  put(
    'sac13_tren_frenat',
    'Amb un cotxe marcat amb fre d’estacionament, el tren també queda frenat / no desfrena?',
    options: const [
      OpcioSac('SÍ · EL TREN NO DESFRENA', 'sac13_electronica_zero'),
      OpcioSac('NO · NOMÉS ESTACIONAMENT', 'sac13_un_pressio'),
    ],
  );
  put(
    'sac13_electronica_zero',
    'Passa tot per 0, inclosa la clau de govern. Després comprova en mode de conducció i amb l’home mort polsat si persisteix el problema de frenat.',
    options: const [
      OpcioSac('FUNCIONAMENT RECUPERAT', done),
      OpcioSac('CONTINUA SENSE DESFRENAR', 'sac13_electronica'),
    ],
  );
  final thermalImages = [...imatgesManual2100['sac16_continua']!]
      .where(
        (i) => [
          'manual/s2100/sac_19/armari-1f09.png',
          'manual/s2100/sac_14/termic-1f11.png',
        ].contains(i.path),
      )
      .toList();
  assert(thermalImages.map((i) => i.path).toSet().length == 2);
  put(
    'sac13_electronica',
    'Visualitza al DISPLAY el cotxe afectat. Actua sobre 1F09 i 1F11 del cotxe afectat i comprova el resultat.\n\nFont: L4 Avaries tècniques, pàg. 34.',
    images: thermalImages,
    options: const [
      OpcioSac('NORMALITZAT', done),
      OpcioSac('NO NORMALITZA', 'sac13_electronica_b19'),
    ],
  );
  put(
    'sac13_electronica_b19',
    'Actua sobre l’electrovàlvula d’estacionament i, segons convingui, B12. Quin cotxe està afectat?',
    options: [
      for (final c in cotxes2100) OpcioSac(c, 'sac13_electro_b19_$c'),
      const OpcioSac('No identificat', 'sac_pendent'),
    ],
  );
  for (final c in cotxes2100) {
    final p =
        source[c == 'MA1' || c == 'MA2'
            ? 'procedimiento_b19_ma'
            : 'procedimiento_b19_mb_r']!;
    put(
      'sac13_electro_b19_$c',
      'Cotxe: $c\n\n${p.preguntaOInstruccion}',
      visual: p,
      options: [
        const OpcioSac('DESFRENAMENT RECUPERAT', 'sac13_electro_alliberat'),
        OpcioSac('CAL ACTUAR AMB B12', 'sac14_b12_cotxe_$c'),
      ],
    );
  }
  put(
    'sac13_electro_alliberat',
    'Desfrenament recuperat després d’actuar sobre l’electrovàlvula d’estacionament. Comunica al CCM l’actuació realitzada i les condicions de continuïtat.',
  );

  // 14: physical location decides the route, never an undefined viability.
  for (final c in cotxes2100) {
    choices('sac14_cabina_$c', [
      for (final cab in ['MA1', 'MA2']) OpcioSac(cab, 'sac14_${c}_$cab'),
      const OpcioSac('No identificada', 'sac_pendent'),
    ]);
    for (final cab in ['MA1', 'MA2']) {
      aliases['sac14_viable_${c}_$cab'] = 'sac14_${c}_$cab';
      if (rutaFre2100(c, cab) == 'sac14_b12') {
        aliases['sac14_${c}_$cab'] = 'sac14_b12_cotxe_$c';
      }
    }
  }
  // Existing B12 warnings already require the brake loop. Make the note exact.
  for (final p in n.values.toList()) {
    if (p.id.startsWith('sac14_b12_cotxe_')) {
      choices(
        p.id,
        p.opcions,
        text:
            '${p.preguntaOInstruccion}\n\nEn cas de desfrenar els bogies mitjançant B12, cal anul·lar el llaç de fre per poder desfrenar el tren.',
      );
    }
  }
  put(
    'sac15',
    'Saps per què està anul·lat el fre de servei?',
    options: const [
      OpcioSac('SÍ · S’HA ANUL·LAT DURANT LA MANIOBRA', 'sac15_informat'),
      OpcioSac('HI HA UNA FALLADA DE FRE PER RESOLDRE', 'sac14'),
      OpcioSac('NO SE’N CONEIX LA CAUSA', 'sac_pendent'),
    ],
  );

  // 16: no repeated car entry. Only the motor/trailer distinction is needed
  // if physical recovery of a traction chain is subsequently considered.
  final continuous = source['sac16_continua_MA1']!;
  put(
    'sac16_continua',
    continuous.preguntaOInstruccion.replaceFirst('Cotxe: MA1\n\n', ''),
    images: imatgesManual2100['sac16_continua']!
        .where((i) => !i.path.contains('cofre-motor'))
        .toList(),
    options: const [
      OpcioSac('ALARMA NORMALITZADA', done),
      OpcioSac('CONTINUA L’ALARMA', 'sac16_tipus_recuperacio'),
    ],
  );
  put(
    'sac16_tipus_recuperacio',
    'Si cal recuperar la cadena de tracció, confirma al DISPLAY si el cotxe afectat és motor. El remolc R no té cofre motor.',
    options: const [
      OpcioSac('COTXE MOTOR', 'sac16_cofre_acord'),
      OpcioSac('REMOLC R', 'sac16_observar'),
      OpcioSac('NO IDENTIFICAT', 'sac_pendent'),
    ],
  );
  for (final c in cotxes2100) {
    aliases['sac16_continua_$c'] = 'sac16_continua';
  }

  // 19: identical rearm, keep differing B19/B12 physical images downstream.
  for (final thermal in ['09', '13']) {
    final p = source['sac19_${thermal}_MA1']!;
    put(
      'sac19_$thermal',
      thermal == '09'
          ? 'Visualitza al DISPLAY el cotxe afectat i rearma 1F09. Comprova el resultat.'
          : '1F13 és exclusiu dels cotxes MA. Dirigeix-te al MA indicat al DISPLAY i rearma 1F13. Comprova el resultat.',
      visual: p,
      options: [
        const OpcioSac('HA REARMAT I NORMALITZAT', done),
        OpcioSac('NO REARMA / NO NORMALITZA', 'sac19_${thermal}_pendent'),
      ],
    );
    for (final c in cotxes2100) {
      aliases['sac19_${thermal}_$c'] = 'sac19_$thermal';
    }
  }
  final b12 = source['sac19_13_b12_MA1']!;
  put(
    'sac19_13_b12',
    b12.preguntaOInstruccion.replaceFirst('Cotxe: MA1\n\n', ''),
    visual: b12,
    options: b12.opcions,
  );
  for (final c in ['MA1', 'MA2']) {
    aliases['sac19_13_b12_$c'] = 'sac19_13_b12';
  }
  choices('sac19_13_cabina', const [
    OpcioSac('HA DESFRENAT', 'sac19_13_cabina_final'),
    OpcioSac('NO HA DESFRENAT', 'sac19_13_remolcada'),
  ]);
  put(
    'sac19_13_cabina_final',
    'Desfrenament des de la cabina contrària amb el llaç de fre anul·lat. Mantén aquesta condició i coordina la continuïtat amb CCM. No és marxa normal.',
  );

  // 22 and the unresolved brake-loop outcome share location-aware closure.
  choices(
    'sac22_marxa',
    const [
      OpcioSac('JA ESTACIONAT A L’ANDANA', 'sac22_estacio'),
      OpcioSac('IMMOBILITZAT FORA D’ESTACIÓ', 'sac22_fora_rearme'),
    ],
    text:
        'Quan sigui possible, no t’aturis fins a la següent estació. Un cop correctament estacionat, ves a rearmar el tirador amb claus i walkie. Coordina el cas amb CCM.',
  );
  choices('sac22_estacio', const [
    OpcioSac('TIRADOR REARMAT I RECUPERAT', done),
    OpcioSac('NO RECUPERAT', 'llac_estacio'),
  ]);
  put(
    'sac22_fora_rearme',
    'Tren immobilitzat fora d’estació: coordina amb CCM si es pot normalitzar el tirador. Identifica’l al DISPLAY i conserva les condicions d’accés segur indicades. Emporta’t claus i walkie.',
    visual: source['sac22_estacio'],
    options: const [
      OpcioSac('TIRADOR REARMAT I RECUPERAT', done),
      OpcioSac('NO ES POT NORMALITZAR', 'llac_fora_estacio'),
    ],
  );
  final tirador = n['procedimiento_tirador']!;
  choices(tirador.id, [
    ...tirador.opcions.where((o) => o.desti != 'sac_pendent'),
    const OpcioSac('IMMOBILITZAT FORA D’ESTACIÓ', 'sac22_fora_rearme'),
    const OpcioSac('NO IDENTIFICAT', 'sac_pendent'),
  ]);
  put(
    'llac_context',
    'El problema no s’ha normalitzat. On és el tren?',
    options: const [
      OpcioSac('EN ESTACIÓ', 'llac_estacio'),
      OpcioSac('IMMOBILITZAT FORA D’ESTACIÓ', 'llac_fora_estacio'),
      OpcioSac('NO CONFIRMAT', 'sac_pendent'),
    ],
  );
  put(
    'llac_estacio',
    'Coordina amb CCM. Desallotja el passatge. Si correspon segons les seves indicacions, anul·la el llaç de fre per continuar o retirar el tren. No continuïs amb un cotxe encara frenat.',
  );
  put(
    'llac_fora_estacio',
    'Coordina amb CCM. Si no es pot normalitzar, anul·la el llaç de fre segons les seves indicacions i comprova que el tren pot desfrenar. Només amb autorització operativa, arriba a la següent estació amb passatge. Un cop en estació, regularitza la situació o desallotja segons CCM.\n\nFont: criteri operatiu aportat per l’usuari, no cita literal del manual.',
  );
  choices(
    'sac24',
    [...source['sac24']!.opcions],
    text:
        'SAC24 indica que el llaç d’emergència està obert; no identifica una avaria única. Pot respondre a tirador, home mort, P7, bolet, pressió mínima, Tren Stop, tèrmics crítics o manca de mode de conducció.\n\nSelecciona la causa identificada. Sense causa concreta, continua pel diagnòstic NO DESFRENA.',
  );
  choices('fin_no_desfrena_llamar_ccm', const [
    OpcioSac('CONTINUA SENSE NORMALITZAR · CONTEXT', 'llac_context'),
  ]);

  const panellAnullacions = ImatgePasManual(
    'manual/s2100/compartits/panell-anullacions.jpg',
    'Panell d’anul·lacions',
    null, // User-supplied photograph, not a page of the manual.
    'S2100 · fotografia aportada',
  );
  final passosPanell = <String>{
    'sac08_persisteix',
    'fin_freno_liberado',
    'procedimiento_sirgas_accion',
    'sac14_b12',
    'procedimiento_b12_ma',
    'procedimiento_b12_mb_r',
    'b12_condicions',
    'sac19_09_pendent',
    'sac19_13_cabina',
    'sac19_13_remolcada',
    'sac19_13_remolcada_final',
    'sac19_13_cabina_final',
    'llac_estacio',
    'llac_fora_estacio',
    for (final c in cotxes2100) 'sac14_b12_cotxe_$c',
    for (final c in cotxes2100) 'procedimiento_b12_esquema_$c',
  };

  // Retire superseded clones and redirect all incoming edges (including shared
  // BAHASTE/PEDET entry points). No dangling or artificial old selector remains.
  String target(String id) {
    final seen = <String>{};
    while (aliases.containsKey(id)) {
      assert(seen.add(id));
      id = aliases[id]!;
    }
    return id;
  }

  for (final p in n.values.toList()) {
    if (aliases.containsKey(p.id)) {
      n.remove(p.id);
      continue;
    }
    n[p.id] = PasoDiagnostico(
      id: p.id,
      preguntaOInstruccion: p.preguntaOInstruccion,
      esPregunta: p.esPregunta,
      botonSiDestino: p.botonSiDestino == null
          ? null
          : target(p.botonSiDestino!),
      botonNoDestino: p.botonNoDestino == null
          ? null
          : target(p.botonNoDestino!),
      opcions: [for (final o in p.opcions) OpcioSac(o.text, target(o.desti))],
      advertencia: p.advertencia,
      imagenPath: p.imagenPath,
      imatgesManual: [
        ...p.imatgesManual,
        if (passosPanell.contains(p.id)) panellAnullacions,
      ],
      causaDescartadaAlSi: p.causaDescartadaAlSi,
      causaDescartadaAlNo: p.causaDescartadaAlNo,
      separarTextoTrenStop: p.separarTextoTrenStop,
    );
  }
  return n;
}
