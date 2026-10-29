import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:l4_incidencias/data/s2100_data.dart';

final g = ramaNoDesfrenaS2100;
List<String> edges(String id) {
  final p = g[id]!;
  return [
    if (p.botonSiDestino != null) p.botonSiDestino!,
    if (p.botonNoDestino != null) p.botonNoDestino!,
    ...p.opcions.map((o) => o.desti),
  ];
}

Set<String> reach(String id) {
  final found = <String>{}, todo = [id];
  while (todo.isNotEmpty) {
    final at = todo.removeLast();
    if (found.add(at)) todo.addAll(edges(at));
  }
  return found;
}

Map serialize(PasoDiagnostico p) => {
  'text': p.preguntaOInstruccion,
  'question': p.esPregunta,
  'yes': p.botonSiDestino,
  'no': p.botonNoDestino,
  'warning': p.advertencia,
  'image': p.imagenPath,
  'images': [
    for (final i in p.imatgesManual)
      [i.path, i.titol, i.pagina, i.variant, i.cotxes],
  ],
  'options': [
    for (final o in p.opcions) [o.text, o.desti],
  ],
};
void main() {
  test(
    'Procediments exclosos de la revisió íntegres, inclòs SAC23 i IRIS25',
    () {
      final baseline =
          jsonDecode(
                File(
                  'test/fixtures/sac_operativa_preservats.json',
                ).readAsStringSync(),
              )
              as Map;
      for (final e in baseline.entries) {
        expect(serialize(g[e.key]!), e.value, reason: e.key);
      }
    },
  );
  test('Traçabilitat interna, cap Font ni nom de fitxer al text operatiu', () {
    expect(
      textOperatiu2100('Acció\n\nFont: manual, pàg. 34.\n\nResultat'),
      'Acció\n\nResultat',
    );
    expect(textOperatiu2100('manual/s2100/test.png'), isEmpty);
    for (final p in g.values) {
      expect(
        textOperatiu2100(p.preguntaOInstruccion),
        isNot(contains('Font:')),
      );
      for (final i in p.imatgesManual) {
        expect(textOperatiu2100(i.titol), isNot(matches(r'\.(png|jpg|jpeg)')));
      }
    }
    expect(g['sac13_electronica']!.preguntaOInstruccion, contains('pàg. 34'));
  });
  test(
    '01 i 02 recuperats acaben sense reconfirmació ni aïllaments genèrics',
    () {
      for (final id in [
        'procedimiento_rearme_disyuntor',
        'sac01_reset',
        'sac02_zero',
        'sac02_recuperar',
      ]) {
        expect(edges(id).first, 'sac_resolt');
      }
      expect(edges('sac_resolt'), isEmpty);
      expect(
        g['sac_resolt']!.preguntaOInstruccion,
        isNot(contains('aïllament')),
      );
      expect(edges('sac02_un'), ['sac02_tres_inhibicions', 'sac02_zero']);
      expect(reach('sac02_zero'), isNot(contains('sac02_tres_inhibicions')));
    },
  );
  test('07 sense tensió exigeix retirada, mai IRIS', () {
    expect(reach('sac07'), isNot(contains('sac07_iris')));
    expect(reach('sac07'), isNot(contains('sac25_iris')));
    final text = g['sac07_sense_tensio']!.preguntaOInstruccion;
    expect(text, contains('No es pot garantir'));
    expect(text, contains('Desallotja'));
    expect(text, contains('retirada'));
  });
  test('12 connexió abans aixeta; no foto o colors inventats', () {
    expect(edges('sac12'), ['sac_resolt', 'sac12_aixeta']);
    expect(
      g['sac12']!.imatgesManual.single.path,
      'manual/s2100/sac_12/comandament-pantograf.png',
    );
    expect(g['sac12_aixeta']!.preguntaOInstruccion, contains('DISPLAY 12'));
    expect(g['sac12_aixeta']!.imatgesManual.single.path,
        'manual/s2100/sac_12/estado-pantografos-2100.jpg');
    expect(g['sac12_aixeta']!.imagenPath, isNull);
    expect(edges('sac12_aixeta'), ['sac_resolt', 'sac12_persisteix']);
    for (final id in reach('sac12')) {
      expect(g[id]!.preguntaOInstruccion, isNot(matches(r'vermell|verd')));
    }
  });
  test('13 confluència funcional, normal B19 B17 sirgues preservada', () {
    expect(edges('sac13_tren_frenat'), [
      'sac13_electronica_zero',
      'sac13_un_pressio',
    ]);
    expect(g['sac13_tren_frenat']!.preguntaOInstruccion, isNot(contains('24')));
    expect(
      reach('sac13_un_pressio'),
      containsAll([
        for (final c in cotxes2100) 'pregunta_b19_es_ma_$c',
        for (final c in cotxes2100) 'pregunta_b17_es_ma_$c',
        'procedimiento_sirgas_accion',
      ]),
    );
    final p = g['sac13_electronica']!;
    expect(
      p.imatgesManual.map((i) => i.path),
      containsAll([
        'manual/s2100/sac_19/armari-1f09.png',
        'manual/s2100/sac_14/termic-1f11.png',
      ]),
    );
    expect(reach('sac13_electronica'), isNot(contains('pregunta_b17_es_ma')));
    expect(reach('sac13_electronica'), contains('b12_condicions'));
  });
  test(
    '14 localització determina 1F11 o B12 sense viabilitat; nota del llaç',
    () {
      for (final c in cotxes2100) {
        for (final cab in ['MA1', 'MA2']) {
          final dest = g['sac14_cabina_$c']!.opcions
              .firstWhere((o) => o.text == cab)
              .desti;
          expect(g[dest]!.preguntaOInstruccion, isNot(contains('viable')));
          if (rutaFre2100(c, cab) == 'sac14_b12') {
            expect(
              g[dest]!.preguntaOInstruccion,
              contains('cal anul·lar el llaç de fre'),
            );
          } else {
            expect(g[dest]!.imagenPath, contains('1f11'));
          }
        }
      }
    },
  );
  test(
    '15 no inventa reparació, distingeix causa coneguda i fallada pendent',
    () {
      expect(edges('sac15'), ['sac15_informat', 'sac14', 'sac_pendent']);
    },
  );
  test(
    '16 i 19 no demanen cotxe per rearmar; només distinció motor quan cal',
    () {
      for (final id in [
        'sac16_continua',
        'sac19_09',
        'sac19_13',
        'sac19_13_b12',
      ]) {
        expect(g[id]!.preguntaOInstruccion, isNot(contains('Quin cotxe')));
        expect(
          g[id]!.opcions.map((o) => o.text).any(cotxes2100.contains),
          isFalse,
        );
      }
      expect(
        g['sac16_tipus_recuperacio']!.opcions
            .firstWhere((o) => o.text == 'REMOLC R')
            .desti,
        'sac16_observar',
      );
      expect(
        g['sac19_13_b12']!.opcions.first.desti,
        'sac19_13_remolcada_final',
      );
      expect(
        g['sac19_13_remolcada_final']!.preguntaOInstruccion,
        contains('REMOLCADA'),
      );
    },
  );
  test(
    '22 estació vs fora: no desallotjament previ impossible; cap foto pendent',
    () {
      expect(edges('sac22_estacio').last, 'llac_estacio');
      expect(edges('sac22_fora_rearme').last, 'llac_fora_estacio');
      final outside = g['llac_fora_estacio']!.preguntaOInstruccion;
      expect(
        outside.indexOf('següent estació'),
        lessThan(outside.indexOf('desallotja')),
      );
      expect(outside, contains('Només amb autorització operativa'));
      expect(outside, contains('no cita literal'));
      for (final id in [
        'llac_estacio',
        'llac_fora_estacio',
        'sac08_persisteix',
      ]) {
        expect(g[id]!.imagenPath, isNull);
        expect(
          g[id]!.imatgesManual.single.path,
          'manual/s2100/compartits/panell-anullacions.jpg',
        );
      }
    },
  );
  test(
    '24 reusa causes i NO DESFRENA, diagnòstic exhaurit pregunta context',
    () {
      expect(
        edges('sac24'),
        containsAll([
          'sac13',
          'sac14',
          'procedimiento_tirador',
          'procedimiento_tren_stop_rearme',
          'inicio_no_desfrena',
        ]),
      );
      expect(reach('inicio_no_desfrena'), contains('llac_context'));
      expect(edges('llac_context'), [
        'llac_estacio',
        'llac_fora_estacio',
        'sac_pendent',
      ]);
    },
  );
  test('Tots els destins existeixen i cada branca pot arribar a un final', () {
    final terminating = g.keys.where((id) => edges(id).isEmpty).toSet();
    bool changed = true;
    while (changed) {
      changed = false;
      for (final id in g.keys) {
        if (!terminating.contains(id) && edges(id).any(terminating.contains)) {
          terminating.add(id);
          changed = true;
        }
      }
    }
    for (final id in g.keys) {
      for (final to in edges(id)) {
        expect(g.containsKey(to), isTrue, reason: '$id -> $to');
      }
      expect(terminating, contains(id), reason: id);
    }
  });
}
