import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l4_incidencias/horarios_screen.dart';
import 'package:l4_incidencias/main.dart';
import 'package:l4_incidencias/acceso_screen.dart';

void main() {
  test('Dates and train numbers retain display contract', () {
    expect(fechaConsulta(DateTime(2026, 10, 22)), '2026-10-22');
    expect(numeroTrenHorario('04 - 3'), '403');
    expect(numeroTrenHorario(null), '—');
  });
  testWidgets('Horaris: empty response is not a connection failure', (t) async {
    await t.pumpWidget(MaterialApp(home: HorariosScreen(
      fechaInicial: DateTime(2026, 10, 22),
      cargar: (_) async => [], cargarUltimos: (_) async => [])));
    await t.pumpAndSettle();
    expect(find.text('No hi ha planificació disponible per a aquesta data.'), findsOneWidget);
    expect(t.takeException(), isNull);
  });
  testWidgets('Horaris: failed load can retry without real data', (t) async {
    var calls = 0;
    await t.pumpWidget(MaterialApp(home: HorariosScreen(
      fechaInicial: DateTime(2026, 10, 22),
      cargar: (_) async {
        if (++calls == 1) throw StateError('simulated offline');
        return [];
      }, cargarUltimos: (_) async => [])));
    await t.pumpAndSettle();
    await t.ensureVisible(find.text('Tornar-ho a provar'));
    await t.tap(find.text('Tornar-ho a provar'));
    await t.pumpAndSettle();
    expect(calls, 2);
    expect(find.text('No hi ha planificació disponible per a aquesta data.'), findsOneWidget);
    expect(t.takeException(), isNull);
  });
  testWidgets('New train validates input before any persistence', (t) async {
    await t.pumpWidget(const MaterialApp(home: NuevoTrenScreen(serie:'2100')));
    expect(find.text('FER FOTO'), findsOneWidget);
    expect(find.text('SELECCIONAR FOTO'), findsOneWidget);
    await t.ensureVisible(find.text('DESAR TREN'));
    await t.tap(find.text('DESAR TREN'));
    await t.pumpAndSettle();
    expect(find.text('Introdueix el número del tren'), findsOneWidget);
    expect(t.takeException(), isNull);
  });

  for (final state in ['aprobado', 'rechazado', 'offline']) {
    testWidgets('Saved session UI: $state', (t) async {
      await t.pumpWidget(MaterialApp(home: AccesoScreen(
        pantallaPrincipal: const Scaffold(body: Text('Synthetic authorized page')),
        comprobarSesionGuardada: () async {
          if (state == 'offline') throw StateError('simulated offline');
          return state;
        })));
      await t.pumpAndSettle();
      expect(find.text('Synthetic authorized page'),
          state == 'aprobado' ? findsOneWidget : findsNothing);
      if (state == 'offline') {
        expect(find.text('Tornar-ho a provar'), findsOneWidget);
      }
      if (state == 'rechazado') {
        expect(find.text('El teu compte no té l’accés aprovat actualment.'), findsOneWidget);
      }
      expect(t.takeException(), isNull);
    });
  }
}
