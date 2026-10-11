import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:l4_incidencias/data/s2100_data.dart';

void main() {
  test('Totes les referències tenen fitxer privat inventariat i pàgina', () {
    final manifest =
        (jsonDecode(File('docs/manual-images.json').readAsStringSync())
            as List);
    final paths = manifest.map((i) => i['path']).toSet();
    for (final p in ramaNoDesfrenaS2100.values) {
      for (final i in p.imatgesManual) {
        expect(paths, contains(i.path), reason: p.id);
        expect(i.path, startsWith('manual/s2100/'));
        if (i.path.endsWith('/panell-anullacions.jpg') ||
            i.path.endsWith('/estado-pantografos-2100.jpg')) {
          expect(i.pagina, isNull);
        } else {
          expect(i.pagina, inInclusiveRange(2, 65));
        }
        expect(i.titol, isNotEmpty);
      }
      if (p.imagenPath != null) {
        expect(p.imagenPath, startsWith('manual/s2100/'), reason: p.id);
        expect(paths, contains(p.imagenPath), reason: p.id);
      }
    }
  });
  test('SAC01 conserva pupitre i CON/DES a la cabina habilitada', () {
    {
      final p = ramaNoDesfrenaS2100['procedimiento_rearme_disyuntor']!;
      expect(
        p.imatgesManual.map((i) => i.path),
        containsAll([
          'manual/s2100/sac_01/pupitre-disjuntor.png',
          'manual/s2100/sac_01/detall-con-des.png',
        ]),
      );
      expect(p.opcions.map((o) => o.desti), ['sac_resolt', 'sac01_reset']);
    }
  });
  test('Selectors de portes segons cotxe i piñó només etiquetat remodelat', () {
    for (final c in cotxes2100) {
      final images = ramaNoDesfrenaS2100['sac08_objecte_$c']!.imatgesManual;
      final isMa = c == 'MA1' || c == 'MA2';
      expect(images.any((i) => i.path.endsWith('selector-ma.png')), isMa);
      expect(images.any((i) => i.path.endsWith('selector-mb-r.png')), !isMa);
      expect(
        images.firstWhere((i) => i.path.contains('pinyo')).variant,
        contains('remodelat'),
      );
    }
  });
  test('1F13 exclusiu MA; EDP identificat al cotxe correcte', () {
    final p = ramaNoDesfrenaS2100['sac16_continua']!;
    expect(p.preguntaOInstruccion, contains('exclusiu MA'));
    expect(p.imatgesManual.any((i) => i.path.contains('1f13')), isTrue);
  });
  test('EDP en el pas i equip exactes', () {
    expect(
      ramaNoDesfrenaS2100['sac25_edp_ma1']!.imagenPath,
      endsWith('equip-posicio-ma1.png'),
    );
    expect(
      ramaNoDesfrenaS2100['sac25_edp_ma2']!.imagenPath,
      endsWith('termic-edp-ma2.png'),
    );
    expect(
      ramaNoDesfrenaS2100['sac25_iris']!.imagenPath,
      endsWith('termic-iris.png'),
    );
  });
  test('Variants i còpies de cabina conserven les imatges correctes', () {
    expect(ramaNoDesfrenaS2100['sac23_original']!.imatgesManual, isEmpty);
    expect(
      ramaNoDesfrenaS2100['sac23_remodelat']!.imatgesManual.single.variant,
      contains('remodelat'),
    );
    expect(
      ramaNoDesfrenaS2100['sac13_tots_persisteix']!.imatgesManual.single.path,
      contains('bolet-emergencia'),
    );
  });
  test('Els cinc recursos S2100 migrats ja no són assets', () {
    for (final name in [
      'todo a 0.jpg',
      'llave especial.jpg',
      'controlas.jpg',
      'termicos_2100.png',
      'pictogramas_s2100.png',
    ])
      expect(File('assets/resolucion/$name').existsSync(), isFalse);
  });
}
