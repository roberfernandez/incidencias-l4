import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l4_incidencias/main.dart';
import 'package:l4_incidencias/data/s2100_data.dart' as s2100;
import 'package:l4_incidencias/data/s9000_data.dart' as s9000;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/shared_preferences'),
      (call) async => call.method == 'getAll' ? <String, Object>{} : true,
    );
    await Supabase.initialize(
      url: 'https://example.supabase.co',
      publishableKey: 'test',
      authOptions: const FlutterAuthClientOptions(
        persistSession: false, autoRefreshToken: false, detectSessionInUri: false,
      ),
    );
  });
  tearDownAll(() => Supabase.instance.dispose());
  for (final dades in [
    (s2100.ramaNoDesfrenaS2100, s2100.causasPorRama, s2100.enlacesCausasAIr),
    (s9000.arbolS9000, s9000.causasPorRamaS9000, s9000.enlacesCausasAIrS9000),
  ]) {
    test(
      'Les causes traduïdes mantenen els enllaços i els descartaments ${dades.$1.keys.first}',
      () {
        final causes = dades.$2.values.expand((llista) => llista).toSet();
        for (final causa in causes) {
          expect(dades.$3.containsKey(causa), isTrue, reason: causa);
          expect(dades.$1.containsKey(dades.$3[causa]), isTrue, reason: causa);
        }
        for (final pas in dades.$1.values) {
          for (final causa in [
            pas.causaDescartadaAlSi,
            pas.causaDescartadaAlNo,
          ]) {
            if (causa != null) expect(causes, contains(causa), reason: pas.id);
          }
          for (final desti in [pas.botonSiDestino, pas.botonNoDestino]) {
            if (desti != null) {
              expect(dades.$1.containsKey(desti), isTrue, reason: pas.id);
            }
          }
        }
      },
    );
  }
  test('Retroceder un descarte repetido conserva el descarte original', () {
    final sesion = SesionDiagnostico('inicio');
    sesion.avanzar('segundo', causa: 'causa');
    sesion.avanzar('tercero', causa: 'causa');
    sesion.retroceder();
    expect(sesion.causasDescartadas, contains('causa'));
    sesion.retroceder();
    expect(sesion.causasDescartadas, isEmpty);
  });

  for (final serie in ['2100', '9000']) {
    testWidgets(
      serie == '2100'
          ? 'Home abandona el diagnòstic S2100'
          : 'Home conserva el avance y los descartes de $serie',
      (tester) async {
        tester.view.physicalSize = const Size(800, 1000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: serie == '2100'
                ? const TriajeS2100Screen()
                : const TriajeS9000Screen(),
          ),
        );
        await tester.tap(find.text('NO\nDESFRENA'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('NO'));
        await tester.pumpAndSettle();
        final causa = serie == '2100'
            ? 'Bolet de cabina / Selector'
            : 'Tirador d’alarma';
        expect(find.byIcon(Icons.check_circle), findsOneWidget);
        expect(
          tester.widget<Text>(find.text(causa)).style!.decoration,
          TextDecoration.lineThrough,
        );
        final pregunta = serie == '2100'
            ? 'Tens el mode ATP seleccionat correctament i respon?'
            : 'El bolet d’emergència està activat o el manipulador de tracció/fre és al punt 7?';
        expect(find.text(pregunta), findsOneWidget);
        await tester.tap(find.byTooltip('Inici de Resolució d’avaries'));
        await tester.pumpAndSettle();
        expect(find.text('SÈRIE $serie'), findsOneWidget);
        await tester.tap(find.text('NO\nDESFRENA'));
        await tester.pumpAndSettle();
        if (serie == '2100') {
          expect(
            find.text('El bolet d’emergència està activat o el selector de marxes és a zero?'),
            findsOneWidget,
          );
          expect(find.byIcon(Icons.check_circle), findsNothing);
          expect(tester.takeException(), isNull);
          return;
        }
        expect(find.text(pregunta), findsOneWidget);
        expect(find.byIcon(Icons.check_circle), findsOneWidget);
        await tester.tap(find.text(causa));
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.check_circle), findsOneWidget);
        expect(find.text(pregunta), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('Home sale del submenú 9000 al inicio de su serie', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: TriajeS9000Screen()));
    await tester.ensureVisible(
      find.text('MODES DE CONDUCCIÓ\n(especial / socors)'),
    );
    await tester.tap(find.text('MODES DE CONDUCCIÓ\n(especial / socors)'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Inici de Resolució d’avaries'));
    await tester.pumpAndSettle();
    expect(find.text('SÈRIE 9000'), findsOneWidget);
  });

  testWidgets('Imagen inexistente no reserva espacio', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              VisorImagenDiagnostico(imagenPath: 'assets/no-existe.jpg'),
              Text('Pregunta'),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.text('Pregunta')).dy, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Causas grandes no desbordan una pantalla pequeña', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MaterialApp(home: TriajeS2100Screen()));
    await tester.tap(find.text('NO\nDESFRENA'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, -450));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('SÍ'), findsOneWidget);
  });
}
