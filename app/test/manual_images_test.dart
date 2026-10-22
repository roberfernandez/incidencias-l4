import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l4_incidencias/imatge_manual_protegida.dart';
import 'package:l4_incidencias/data/s2100_data.dart';

void main() {
  final pixel = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+/l9sAAAAASUVORK5CYII=',
  );
  test('Imatges privades presents en els passos i variants correctes', () {
    for (final id in [
      'sac13_tots_cabina',
      'sac13_un_cabina',
      'sac14_1f11',
      'sac19_09',
      'sac19_11_MB1',
      'sac19_13',
      'sac20',
      'sac21',
      'sac23_remodelat',
      'sac23_anullar',
      'procedimiento_b19_ma',
      'procedimiento_b19_mb_r',
    ]) {
      expect(
        ramaNoDesfrenaS2100[id]!.imagenPath,
        startsWith('manual/s2100/'),
        reason: id,
      );
    }
    expect(ramaNoDesfrenaS2100['sac23_original']!.imagenPath, isNull);
    expect(
      ramaNoDesfrenaS2100['sac14_MA1_MA1']!.imagenPath,
      contains('termic-1f11'),
    );
  });
  testWidgets('Error de xarxa o autorització no mostra cap imatge', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ImatgeManualProtegida(
          path: 'manual/s2100/test.png',
          loader: (_) async => throw StateError('denied'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(Image), findsNothing);
    expect(find.text('Torna-ho a provar'), findsOneWidget);
  });
  testWidgets('Canviar ruta descarta la resposta antiga', (tester) async {
    final old = Completer<Uint8List>();
    Future<Uint8List> load(String path) => path.endsWith('old.png')
        ? old.future
        : Future.error(StateError('denied'));
    await tester.pumpWidget(
      MaterialApp(
        home: ImatgeManualProtegida(path: 'manual/s2100/old.png', loader: load),
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: ImatgeManualProtegida(path: 'manual/s2100/new.png', loader: load),
      ),
    );
    await tester.pump();
    old.complete(pixel);
    await tester.pumpAndSettle();
    expect(find.byType(Image), findsNothing);
  });
  testWidgets('Vista completa utilitza zoom i una nova lectura protegida', (
    tester,
  ) async {
    int calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ImatgeManualProtegida(
            path: 'manual/s2100/test.png',
            loader: (_) async {
              calls++;
              return pixel;
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();
    expect(find.byType(InteractiveViewer), findsOneWidget);
    expect(calls, 2);
    expect(
      tester.widget<InteractiveViewer>(find.byType(InteractiveViewer)).maxScale,
      6,
    );
  });
}
