import 'package:flutter/material.dart';

/// Catàleg parcial IOS sèrie 9000: fonts L4 Avaries tècniques i fotografies DDU.
/// Destins sempre referits a procediments existents. Cap nova maniobra.
class Ios9000Entry {
  final int numero;
  final String descripcio;
  final String? desti;
  final bool relacionat;
  const Ios9000Entry(this.numero, this.descripcio, this.desti, [this.relacionat = false]);
}
const ios9000Entries = <Ios9000Entry>[
  Ios9000Entry(14, "Sistema antilliscament cotxe R", null),
  Ios9000Entry(24, "Falta d'aire comprimit", "s9000_aire"),
  Ios9000Entry(25, "Carregador de bateria en fallada", "s9000_convertidor"),
  Ios9000Entry(26, "Carregador de bateria en fallada", "s9000_convertidor"),
  Ios9000Entry(27, "Carregador de bateria en fallada", "s9000_convertidor"),
  Ios9000Entry(75, "Discrepància dels senyals V=0", "s9000_km0", true),
  Ios9000Entry(86, "Pèrdua d'una cadena de tracció", "s9000_traccio"),
  Ios9000Entry(88, "Pèrdua de fre elèctric", "s9000_fre_electric"),
  Ios9000Entry(92, "Fallada detecció d'incendis", null),
  Ios9000Entry(112, "Disjuntor obert amb autorització a tancar", "procedimiento_disyuntores_s9000"),
  Ios9000Entry(113, "Disjuntor obert amb autorització a tancar", "procedimiento_disyuntores_s9000"),
  Ios9000Entry(133, "Alguna càmera del tren està tapada", null),
  Ios9000Entry(151, "Fallada d'equips de climatització", "s9000_hvac"),
  Ios9000Entry(154, "Tren Stop cabina activa deslocalitzat", null),
  Ios9000Entry(162, "Fallada càmera posterior", "s9000_video", true),
  Ios9000Entry(165, "Fallada d'alguna càmera", "s9000_video", true),
  Ios9000Entry(166, "Fallada de càmeres laterals", "s9000_video", true),
  Ios9000Entry(167, "Pantògraf no elevat o aïllat", "s9000_pantograf"),
  Ios9000Entry(168, "Pantògraf no elevat o aïllat", "s9000_pantograf"),
  Ios9000Entry(169, "Pantògraf no elevat o aïllat", "s9000_pantograf"),
  Ios9000Entry(170, "Pantògraf no elevat o aïllat", "s9000_pantograf"),
  Ios9000Entry(171, "Pantògraf no elevat o aïllat", "s9000_pantograf"),
  Ios9000Entry(172, "Pantògraf no elevat o aïllat", "s9000_pantograf"),
  Ios9000Entry(176, "Fallada de gravació en algun DVR", "s9000_video", true),
  Ios9000Entry(207, "Fre de servei aplicat i bloquejat", "inicio_freno_servicio"),
  Ios9000Entry(208, "Fre de servei aplicat i bloquejat", "inicio_freno_servicio"),
  Ios9000Entry(209, "Fre de servei aplicat i bloquejat", "inicio_freno_servicio"),
  Ios9000Entry(210, "Fre de servei aplicat i bloquejat", "inicio_freno_servicio"),
  Ios9000Entry(211, "Fre de servei aplicat i bloquejat", "inicio_freno_servicio"),
  Ios9000Entry(218, "Pressió TDP anormalment baixa", "s9000_aire"),
  Ios9000Entry(221, "Fallada d'un compressor", "s9000_compressor"),
  Ios9000Entry(222, "Fallada d'un compressor", "s9000_compressor"),
  Ios9000Entry(223, "Fallada d'un compressor", "s9000_compressor"),
  Ios9000Entry(240, "Fallada de dues càmeres interiors", "s9000_video", true),
];
class Ios9000Screen extends StatefulWidget {
  final ValueChanged<String> onSelect;
  const Ios9000Screen({super.key, required this.onSelect});
  @override
  State<Ios9000Screen> createState() => _Ios9000ScreenState();
}
class _Ios9000ScreenState extends State<Ios9000Screen> {
  String _query = '';
  int? _selected;
  @override
  Widget build(BuildContext context) {
    final visible = ios9000Entries.where((e) =>
      e.numero.toString().contains(_query.trim()) ||
      e.descripcio.toLowerCase().contains(_query.trim().toLowerCase())).toList();
    final selected = _selected == null ? null : ios9000Entries.where((e) => e.numero == _selected).firstOrNull;
    return Scaffold(
      appBar: AppBar(title: const Text('IOS / DDU · SÈRIE 9000')),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          TextField(
            key: const ValueKey('ios9000-search'),
            onChanged: (v) => setState(() { _query = v; _selected = null; }),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search), labelText: 'Codi o incidència',
              border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10),
          Text('Llista d’estats operacionals incorrectes · ${ios9000Entries.length} IOS identificats',
            textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Expanded(child: Container(
            decoration: BoxDecoration(color: const Color(0xFF1D2D63),
              borderRadius: BorderRadius.circular(10)),
            child: ListView.separated(
              itemCount: visible.length,
              separatorBuilder: (ctx, i) => const Divider(height: 1, color: Colors.white24),
              itemBuilder: (ctx, i) {
                final entry = visible[i];
                return Material(
                  color: entry.numero == _selected ? const Color(0xFF316AD3) : Colors.transparent,
                  child: ListTile(
                    key: ValueKey('ios-${entry.numero}'),
                    dense: true,
                    leading: Icon(entry.desti == null ? Icons.help_outline : Icons.warning_amber,
                      color: Colors.amber),
                    title: Text('IOS ${entry.numero} · ${entry.descripcio}'),
                    onTap: () => setState(() => _selected = entry.numero),
                  ),
                );
              },
            ),
          )),
          if (selected != null) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFF23356A),
                borderRadius: BorderRadius.circular(10)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text('IOS ${selected.numero} · ${selected.descripcio}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                const SizedBox(height: 8),
                if (selected.desti == null)
                  const Text('Sense resolució específica establerta. Comunicar-ho al CCM.')
                else ...[
                  if (selected.relacionat)
                    const Text('Procediment general relacionat: comprova que correspongui a la incidència.',
                      style: TextStyle(color: Colors.amber)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => widget.onSelect(selected.desti!),
                    child: Text(selected.relacionat
                      ? 'CONSULTAR PROCEDIMENT RELACIONAT'
                      : 'OBRIR PROCEDIMENT EXISTENT'),
                  ),
                ],
              ]),
            ),
          ],
          const SizedBox(height: 6),
          const Text('Catàleg parcial. No substitueix la DDU ni les indicacions del CCM.',
            style: TextStyle(fontSize: 11, color: Colors.white60),
            textAlign: TextAlign.center),
        ]),
      )),
    );
  }
}
