import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l4_incidencias/main.dart';
import 'package:l4_incidencias/imatge_manual_protegida.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  setUpAll(() async {
    await Supabase.initialize(
      url: 'https://example.supabase.co',
      publishableKey: 'build-only-placeholder',
      authOptions: const FlutterAuthClientOptions(autoRefreshToken: false),
    );
  });

  testWidgets('MA, R i MB mostren només les fotografies corresponents', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: TermicsS2100Screen()));
    await tester.pumpAndSettle();
    expect(find.text('MA (cabina)'), findsOneWidget);
    expect(find.text('R (remolque)'), findsOneWidget);
    expect(find.text('MB'), findsOneWidget);
    expect(tester.widget<ImatgeManualProtegida>(find.byType(ImatgeManualProtegida)).path,
      TermicsS2100Screen.maPath);

    await tester.tap(find.text('R (remolque)'));
    await tester.pumpAndSettle();
    expect(tester.widgetList<ImatgeManualProtegida>(find.byType(ImatgeManualProtegida))
      .map((image) => image.path), [
        TermicsS2100Screen.armariPath,
        TermicsS2100Screen.llegendaPath,
      ]);
    expect(find.text('COTXES MA'), findsNothing);

    await tester.tap(find.text('MB'));
    await tester.pumpAndSettle();
    expect(find.text('Fotografies pendents'), findsOneWidget);
    expect(find.byType(ImatgeManualProtegida), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });
}
