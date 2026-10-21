import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:l4_incidencias/data/s2100_data.dart';

void main() {
  const path = 'manual/s2100/compartits/panell-anullacions.jpg';
  test(
    'Panell privat en les maniobres revisades i no en advertiments negatius',
    () {
      for (final id in [
        'sac08_persisteix',
        'fin_freno_liberado',
        'procedimiento_sirgas_accion',
        'sac14_b12',
        'sac19_09_pendent',
        'sac19_13_cabina',
        'sac19_13_remolcada',
        'sac19_13_remolcada_final',
        'llac_estacio',
        'llac_fora_estacio',
        for (final c in cotxes2100) 'sac14_b12_cotxe_$c',
        for (final c in cotxes2100) 'procedimiento_b12_esquema_$c',
      ]) {
        final images = ramaNoDesfrenaS2100[id]!.imatgesManual;
        final panel = images.where((i) => i.path == path).single;
        expect(panel.titol, 'Panell d’anul·lacions');
        expect(panel.pagina, isNull);
      }
      for (final id in ['sac19_11_pendent', 'sac27_traccio', 'sac_resolt']) {
        expect(
          ramaNoDesfrenaS2100[id]!.imatgesManual.any((i) => i.path == path),
          isFalse,
        );
      }
      expect(File('assets/$path').existsSync(), isFalse);
    },
  );
}
