import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l4_incidencias/main.dart';

void main() {
  testWidgets('S9000 pictogrames localització and DDU stay separate',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PictogramasScreen(serie: '9000', volverInicio: () {}),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Localització al tren'), findsOneWidget);
    expect(find.text('Localització al tren i DDU'), findsNothing);
    expect(find.text('Detall de la pantalla DDU'), findsOneWidget);

    final images = tester
        .widgetList<VisorImagenDiagnostico>(
          find.byType(VisorImagenDiagnostico),
        )
        .map((image) => image.imagenPath)
        .toList();
    expect(images, [
      'assets/resolucion/pictogramas_s9000_localitzacio.png',
      'assets/resolucion/pictogramas_s9000_ddu.png',
    ]);
  });
}
