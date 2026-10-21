import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:l4_incidencias/data/s2100_data.dart';
void main() {
 test('SAC12 mostra el display real al pas de consulta sense canviar maniobres', () {
  final g=ramaNoDesfrenaS2100;
  expect(g['sac12']!.opcions.map((o)=>o.desti), ['sac_resolt','sac12_aixeta']);
  final p=g['sac12_aixeta']!;
  expect(p.opcions.map((o)=>o.desti), ['sac_resolt','sac12_persisteix']);
  final i=p.imatgesManual.single;
  expect(i.path,'manual/s2100/sac_12/estado-pantografos-2100.jpg');
  expect(i.titol,'DISPLAY 12 · Estat dels pantògrafs');
  expect(i.pagina,isNull);
  expect(i.variant,contains('vermell = tancada, verd = oberta'));
  expect(i.variant,contains('vermell = amunt, verd = avall'));
  expect(File('assets/${i.path}').existsSync(),isFalse);
 });
}
