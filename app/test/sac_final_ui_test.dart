import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:l4_incidencias/main.dart';
import 'package:l4_incidencias/sac2100_screen.dart';
import 'package:l4_incidencias/data/s2100_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/shared_preferences'),
          (call) async => call.method == 'getAll' ? <String, Object>{} : true,
        );
    await Supabase.initialize(
      url: 'https://example.supabase.co',
      publishableKey: 'test',
      authOptions: const FlutterAuthClientOptions(
        persistSession: false,
        autoRefreshToken: false,
        detectSessionInUri: false,
      ),
    );
  });
  tearDownAll(() => Supabase.instance.dispose());
  final g = ramaNoDesfrenaS2100;
  List<String> edges(String id) {
    final p = g[id]!;
    return [
      if (p.botonSiDestino != null) p.botonSiDestino!,
      if (p.botonNoDestino != null) p.botonNoDestino!,
      ...p.opcions.map((o) => o.desti),
    ];
  }

  testWidgets(
    'SAC ocupa les dues columnes després de les dues vies principals',
    (t) async {
      t.view.physicalSize = const Size(390, 844);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      await t.pumpWidget(
        MaterialApp(theme: ThemeData.dark(), home: const TriajeS2100Screen()),
      );
      await t.pumpAndSettle();
      final buttons = find.byType(BotonTriajePrincipal);
      final a = t.getRect(buttons.at(0)), b = t.getRect(buttons.at(1));
      final card = t.getRect(find.byKey(const ValueKey('sac-display-entry')));
      expect(card.top, greaterThan(a.bottom));
      expect(card.top, greaterThan(b.bottom));
      expect(card.left, closeTo(a.left, 1));
      expect(card.right, closeTo(b.right, 1));
      expect(
        t.getTopLeft(find.text('MODE ESPECIAL')).dy,
        greaterThan(card.bottom),
      );
      expect(t.takeException(), isNull);
    },
  );
  test('ATP: TBS 2–3 s, M+25, només després de fallar M+25 entrada ME', () {
    expect(g['pregunta_modo_atp']!.botonNoDestino, 'atp_reset_tbs');
    expect(g['atp_reset_tbs']!.preguntaOInstruccion, contains('2–3 s'));
    expect(edges('atp_reset_tbs'), ['atp_normalitzat', 'atp_m25']);
    expect(edges('atp_m25'), [
      'atp_normalitzat',
      'procedimiento_modo_especial',
    ]);
    expect(
      g['procedimiento_modo_especial']!.preguntaOInstruccion,
      contains('desallotja'),
    );
    expect(edges('procedimiento_modo_especial'), ['inicio_modo_especial']);
    expect(edges('atp_normalitzat'), isNot(contains('inicio_modo_especial')));
  });
  test('ME: 0 abans ATC, parpelleig, repetició i testera contrària', () {
    final prep = g['inicio_modo_especial']!.preguntaOInstruccion;
    for (final text in ['M/F', 'selector', 'clau de govern']) {
      expect(prep, contains(text));
    }
    expect(edges('inicio_modo_especial'), [
      'procedimiento_modo_especial_llave',
    ]);
    expect(
      g['procedimiento_modo_especial_llave']!.preguntaOInstruccion,
      contains('ja a 0'),
    );
    expect(edges('procedimiento_modo_especial_llave'), [
      'me_establert',
      'me_repetir',
    ]);
    expect(edges('me_repetir'), ['me_establert', 'me_testera_contraria']);
    expect(edges('me_testera_contraria'), ['me_retorn', 'me_no_establert']);
    expect(edges('me_retorn'), ['me_establert', 'me_no_establert']);
    for (final id in ['me_repetir', 'me_testera_contraria']) {
      final text = g[id]!.preguntaOInstruccion;
      expect(text.indexOf('a 0'), lessThan(text.indexOf('desconnecta')));
    }
  });
  test('ME mai amb passatge; B12 explícit', () {
    for (final p in g.values) {
      expect(
        '${p.preguntaOInstruccion} ${p.advertencia}',
        isNot(contains('25 km/h amb passatge')),
        reason: p.id,
      );
    }
    expect(
      g['me_establert']!.advertencia,
      contains('No circular amb passatge'),
    );
    final b12 = g.values.where(
      (p) => p.advertencia?.contains('COMPLETAMENT sense fre') ?? false,
    );
    expect(b12, isNotEmpty);
    for (final p in b12) {
      expect(p.advertencia, contains('Cal anul·lar el llaç de fre.'));
    }
  });
  test('UI S2100 sense caràcters de substitució i tots els destins vàlids', () {
    for (final p in g.values) {
      expect(
        '${p.preguntaOInstruccion}${p.advertencia}',
        isNot(contains('\uFFFD')),
        reason: p.id,
      );
      for (final id in edges(p.id)) {
        expect(g.containsKey(id), isTrue, reason: '${p.id} -> $id');
      }
    }
    final text = File('lib/main.dart').readAsStringSync();
    final s2100 = text.substring(
      text.indexOf('class TriajeS2100Screen'),
      text.indexOf('class TriajeS9000Screen'),
    );
    expect(s2100, isNot(contains('\uFFFD')));
    expect(text, contains("? 'Tornar a Què li passa al tren?'"));
  });
  testWidgets('SAC25 mòbil: text i botons accessibles sense overflow', (
    t,
  ) async {
    t.view.physicalSize = const Size(390, 844);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    await t.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: DiagnosticoInteractivoScreen(
          pasoInicialId: 'sac25_iris',
          sesion: SesionDiagnostico('sac25_iris'),
          volverInicio: () {},
          pasos: g,
        ),
      ),
    );
    await t.pumpAndSettle();
    for (final label in [
      'BIP-BIP I MEGAFONIA OK',
      'NOMÉS FALLA EL BIP-BIP',
      'TAMBÉ FALLA LA MEGAFONIA',
    ]) {
      await t.ensureVisible(find.text(label));
      await t.pumpAndSettle();
      expect(find.text(label).hitTestable(), findsOneWidget);
      expect(t.takeException(), isNull);
    }
    await t.pumpWidget(const SizedBox());
    await t.pumpAndSettle();
  });

  testWidgets('UI operativa oculta font i rutes però conserva imatges', (
    t,
  ) async {
    await t.pumpWidget(
      MaterialApp(
        home: DiagnosticoInteractivoScreen(
          pasoInicialId: 'sac13_electronica',
          sesion: SesionDiagnostico('sac13_electronica'),
          volverInicio: () {},
          pasos: g,
        ),
      ),
    );
    await t.pumpAndSettle();
    expect(find.textContaining('Font:'), findsNothing);
    expect(find.textContaining('Manual, pàg.'), findsNothing);
    expect(find.textContaining('manual/s2100/'), findsNothing);
    expect(find.textContaining('Actua sobre 1F09 i 1F11'), findsOneWidget);
    expect(find.byType(VisorImagenDiagnostico), findsNWidgets(2));
    expect(t.takeException(), isNull);
    await t.pumpWidget(const SizedBox());
    await t.pumpAndSettle();
  });
  testWidgets('SAC12 normalitzat acaba sense confirmació addicional', (
    t,
  ) async {
    await t.pumpWidget(
      MaterialApp(
        home: DiagnosticoInteractivoScreen(
          pasoInicialId: 'sac12',
          sesion: SesionDiagnostico('sac12'),
          volverInicio: () {},
          pasos: g,
        ),
      ),
    );
    await t.pumpAndSettle();
    await t.ensureVisible(find.text('PANTÒGRAF NORMALITZAT'));
    await t.tap(find.text('PANTÒGRAF NORMALITZAT'));
    await t.pumpAndSettle();
    expect(find.textContaining('Incidència resolta.'), findsOneWidget);
    expect(find.text('TORNAR A L’INICI'), findsOneWidget);
    expect(find.text('SÍ'), findsNothing);
    expect(find.text('NO'), findsNothing);
    expect(t.takeException(), isNull);
    await t.pumpWidget(const SizedBox());
    await t.pumpAndSettle();
  });

  testWidgets('Selector -> S2100 -> SAC -> procediment i retorn', (t) async {
    t.view.physicalSize = const Size(390, 844);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    await t.pumpWidget(MaterialApp(
      theme: ThemeData.dark(), home: const SelectorSerieScreen()));
    await t.pumpAndSettle();
    await t.ensureVisible(find.byType(SelectorSerieCard).first);
    await t.tap(find.byType(SelectorSerieCard).first);
    await t.pumpAndSettle();
    expect(find.byType(TriajeS2100Screen), findsOneWidget);
    await t.ensureVisible(find.byKey(const ValueKey('sac-display-entry')));
    await t.tap(find.byKey(const ValueKey('sac-display-entry')));
    await t.pumpAndSettle();
    expect(find.byType(Sac2100Screen), findsOneWidget);
    expect(find.byKey(const ValueKey('sac-zoom')), findsOneWidget);
    await t.tap(find.byKey(const ValueKey('sac-12')));
    await t.pumpAndSettle();
    expect(find.byType(DiagnosticoInteractivoScreen), findsOneWidget);
    expect(t.takeException(), isNull);
    final context = t.element(find.byType(DiagnosticoInteractivoScreen));
    Navigator.of(context).popUntil((route) => route.isFirst);
    await t.pumpAndSettle();
    expect(find.byType(SelectorSerieScreen), findsOneWidget);
    await t.ensureVisible(find.byType(SelectorSerieCard).last);
    await t.tap(find.byType(SelectorSerieCard).last);
    await t.pumpAndSettle();
    expect(find.byType(TriajeS9000Screen), findsOneWidget);
    expect(t.takeException(), isNull);
    await t.pumpWidget(const SizedBox());
    await t.pumpAndSettle();
  });
}
