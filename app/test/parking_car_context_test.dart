import 'package:flutter_test/flutter_test.dart';
import 'package:l4_incidencias/data/s2100_data.dart';

void main() {
  for (final car in cotxes2100) {
    test('Parking brake retains $car from pressure through B19 and B17', () {
      final g = ramaNoDesfrenaS2100;
      final pressure = g['sac13_un_pressio_$car']!;
      final cab = g[pressure.botonSiDestino]!;
      final b19 = g[cab.opcions.firstWhere((o) => o.text == 'CONTINUA APLICAT').desti]!;
      expect(b19.preguntaOInstruccion, startsWith('Cotxe: $car'));
      expect(b19.imagenPath, car.startsWith('MA')
          ? 'manual/s2100/sac_13/b19-coches-a.jpg'
          : 'manual/s2100/sac_13/b19.jpg');
      final result = g[b19.botonSiDestino]!;
      final b17 = g[result.botonNoDestino]!;
      expect(b17.preguntaOInstruccion, startsWith('Cotxe: $car'));
      expect(b17.imagenPath, car.startsWith('MA')
          ? 'manual/s2100/sac_13/b17-ma.jpg'
          : 'manual/s2100/sac_13/b17-mb-remolque.jpg');
      expect(b17.botonSiDestino, 'procedimiento_sirgas_accion');
    });
  }
}
