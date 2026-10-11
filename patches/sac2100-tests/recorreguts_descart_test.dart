import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:l4_incidencias/data/s2100_data.dart';

void main() {
  final g = ramaNoDesfrenaS2100;
  test('NO DESFRENA recorre les set causes en ordre', () {
    final route = ['pregunta_seta', 'pregunta_modo_atp', 'pregunta_hom_muerto', 'pregunta_tdp', 'pregunta_tren_stop_iris', 'inicio_no_desfrena', 'pregunta_maniobra_estacionamiento', 'fin_no_desfrena_llamar_ccm'];
    const yes = {'pregunta_modo_atp', 'pregunta_hom_muerto'};
    for (var i=0; i<route.length-1; i++) {
      final p=g[route[i]]!;
      expect(yes.contains(p.id) ? p.botonSiDestino : p.botonNoDestino, route[i+1], reason:p.id);
    }
  });
  test('NO TRACCIONA descarta portes, estacionaments, disjuntor, EED i tensio', () {
    final route=['inicio_no_tracciona','sac_portes_reconegudes','pregunta_estacionamiento','pregunta_disyuntores_abierto','pregunta_eed','pregunta_tension','procedimiento_ccm_final'];
    for(var i=0;i<route.length-1;i++) {
      final p=g[route[i]]!;
      expect(i<3 ? p.botonSiDestino : p.botonNoDestino,route[i+1],reason:p.id);
    }
    expect(g['sac_des_comprova']!.botonSiDestino,'pregunta_disyuntores_abierto');
    expect(causasPorRama['no_tracciona']![2], 'Disjuntor (Obert)');
  });
  test('entrades generals directes i SAC independent', () {
    final main=File('lib/main.dart').readAsStringSync();
    expect(main, isNot(contains("pasoInicialId: 'sac_bahaste_identificada'")));
    expect(main, isNot(contains("pasoInicialId: 'sac_pedet_identificada'")));
    expect(main, contains("pasoInicialId: 'pregunta_seta'"));
    expect(main, contains("pasoInicialId: 'inicio_no_tracciona'"));
    expect(main, contains('Sac2100Screen'));
    expect(g['pregunta_disyuntores_abierto']!.botonSiDestino,'procedimiento_rearme_disyuntor');
    expect(g['pregunta_maniobra_estacionamiento']!.botonSiDestino,'sac13');
    expect(g['pregunta_eed']!.botonSiDestino,'procedimiento_eed_rearmar');
  });
}
