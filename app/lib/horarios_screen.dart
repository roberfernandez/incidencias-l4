import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

typedef CargarPlanificacion =
    Future<List<Map<String, dynamic>>> Function(DateTime fecha);

String numeroTrenHorario(Object? valor) {
  final original = valor?.toString().trim() ?? '—';
  final partes = RegExp(r'^04\s*-\s*(\d{1,2})$').firstMatch(original);
  return partes == null ? original : '4${partes[1]!.padLeft(2, '0')}';
}

String fechaConsulta(DateTime fecha) =>
    '${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}';

Future<List<Map<String, dynamic>>> cargarPlanificacion(DateTime fecha) async {
  final respuesta = await Supabase.instance.client.rpc(
    'l4_planificacion_dia',
    params: {'p_fecha': fechaConsulta(fecha)},
  );
  return List<Map<String, dynamic>>.from(respuesta as List);
}

Future<List<Map<String, dynamic>>> cargarUltimosPasaje(DateTime fecha) async {
  final respuesta = await Supabase.instance.client.rpc(
    'l4_ultimos_pasaje_dia',
    params: {'p_fecha': fechaConsulta(fecha)},
  );
  return List<Map<String, dynamic>>.from(respuesta as List);
}

String? horaSalidaCabecera(Map<String, dynamic> datos) {
  final calendario = (datos['tipo_calendario'] ?? '').toString().toLowerCase();
  final tipo = (datos['tipo_horario'] ?? datos['tipo_calendario'] ?? '')
      .toString()
      .toLowerCase();
  if (datos['servicio_continuado'] == true) return null;
  if (calendario.contains('fins 23')) return '23:00';
  if (tipo.contains('divendres') ||
      tipo.contains('vig') ||
      tipo.contains('festiu especial')) {
    return '02:00';
  }
  if (tipo.contains('feiner') || tipo == 'diumenge' || tipo == 'festiu') {
    return '00:00';
  }
  return null;
}

class HorariosScreen extends StatefulWidget {
  const HorariosScreen({
    super.key,
    this.cargar = cargarPlanificacion,
    this.cargarUltimos = cargarUltimosPasaje,
    this.fechaInicial,
  });
  final CargarPlanificacion cargar;
  final CargarPlanificacion cargarUltimos;
  final DateTime? fechaInicial;

  @override
  State<HorariosScreen> createState() => _HorariosScreenState();
}

class _HorariosScreenState extends State<HorariosScreen> {
  late DateTime fecha;
  List<Map<String, dynamic>> filas = [];
  Map<String, dynamic>? ultimos;
  bool errorUltimos = false;
  String deposito = 'Totes';
  String movimiento = 'Tot';
  String? error;
  bool cargando = true;
  int peticion = 0;

  @override
  void initState() {
    super.initState();
    final hoy = widget.fechaInicial ?? DateTime.now();
    fecha = DateTime(hoy.year, hoy.month, hoy.day);
    consultar();
  }

  Future<void> consultar() async {
    final actual = ++peticion;
    setState(() {
      cargando = true;
      error = null;
      filas = [];
      ultimos = null;
      errorUltimos = false;
    });
    try {
      var falloUltimos = false;
      Future<List<Map<String, dynamic>>> consultarUltimos() async {
        try {
          return await widget.cargarUltimos(fecha);
        } catch (_) {
          falloUltimos = true;
          return [];
        }
      }

      final resultados = await Future.wait([
        widget.cargar(fecha),
        consultarUltimos(),
      ]);
      final resultado = resultados[0];
      resultado.sort(
        (a, b) => (a['orden'] as num).compareTo(b['orden'] as num),
      );
      if (!mounted || actual != peticion) return;
      setState(() {
        filas = resultado;
        ultimos = resultados[1].isEmpty ? null : resultados[1].single;
        errorUltimos = falloUltimos;
        cargando = false;
      });
    } catch (_) {
      if (!mounted || actual != peticion) return;
      setState(() {
        cargando = false;
        error =
            'No s’han pogut carregar els horaris. Comprova la connexió i que la sessió continuï activa.';
      });
    }
  }

  Future<void> elegirFecha() async {
    final seleccionada = await showDatePicker(
      context: context,
      initialDate: fecha,
      firstDate: DateTime(2026),
      lastDate: DateTime(2100, 12, 31),
      helpText: 'DATA DE SERVEI',
      cancelText: 'CANCEL·LAR',
      confirmText: 'VEURE',
    );
    if (seleccionada == null || !mounted) return;
    setState(() => fecha = seleccionada);
    await consultar();
  }

  @override
  Widget build(BuildContext context) {
    final provisional =
        filas.any(
          (f) =>
              f['libro'] == 'DESCONOCIDO_NAVIDAD' ||
              f['estado'] == 'PROVISIONAL_NAVIDAD',
        ) ||
        ultimos?['libro'] == 'DESCONOCIDO_NAVIDAD' ||
        (fecha.year == 2026 && fecha.month == 12 && fecha.day >= 24);

    final visibles = filas
        .where(
          (f) =>
              (deposito == 'Totes' ||
                  f['deposito']?.toString().trim().toUpperCase() ==
                      deposito.toUpperCase()) &&
              (movimiento == 'Tot' || f['movimiento'] == movimiento),
        )
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horaris L4'),
        actions: [
          IconButton(
            tooltip: 'Tornar a l’inici',
            icon: const Icon(Icons.home_outlined),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: RefreshIndicator(
              onRefresh: consultar,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'SORTIDES I RETIRADES',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: elegirFecha,
                    icon: const Icon(Icons.calendar_month),
                    label: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'Data de servei: ${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Les hores de matinada corresponen al final del servei de la data seleccionada.',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, size: 18, color: Colors.amber),
                      SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          'Els trens especials no figuren a la previsió horària.',
                          style: TextStyle(color: Colors.amber),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (cargando)
                    const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (error != null) ...[
                    Text(error!),
                    TextButton.icon(
                      onPressed: consultar,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tornar-ho a provar'),
                    ),
                  ] else if (filas.isEmpty)
                    const Text(
                      'No hi ha planificació disponible per a aquesta data.',
                    )
                  else ...[
                    Text(
                      '${filas.first['tipo_calendario']} · ${provisional ? 'Llibre de Nadal pendent' : 'Llibre ${filas.first['libro']}'}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (provisional)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'Horari provisional · El llibre de Nadal encara no està publicat. S’utilitza el de gener com a referència.',
                          style: TextStyle(color: Colors.amber),
                        ),
                      ),
                    if (filas.any(
                      (f) =>
                          f['ajuste_aplicado'] != null &&
                          f['ajuste_aplicado'] != false &&
                          f['ajuste_aplicado'] != 0 &&
                          f['ajuste_aplicado'] != '0',
                    ))
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'Aquest dia inclou un ajust d’horari, ja aplicat a les hores mostrades.',
                        ),
                      ),
                    const SizedBox(height: 16),
                    UltimosPasajeCard(datos: ultimos, error: errorUltimos),
                    if (errorUltimos)
                      TextButton(
                        onPressed: consultar,
                        child: const Text('Tornar a carregar els últims trens'),
                      ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: ['Totes', 'TRINITAT NOVA', 'LA PAU']
                          .map(
                            (valor) => ChoiceChip(
                              label: Text(
                                valor == 'Totes'
                                    ? valor
                                    : valor == 'LA PAU'
                                    ? 'La Pau'
                                    : 'Trinitat Nova',
                              ),
                              selected: deposito == valor,
                              onSelected: (_) =>
                                  setState(() => deposito = valor),
                            ),
                          )
                          .toList(),
                    ),
                    Wrap(
                      spacing: 8,
                      children: ['Tot', 'SORTIDA', 'RETIRADA']
                          .map(
                            (valor) => ChoiceChip(
                              label: Text(
                                valor == 'Tot'
                                    ? valor
                                    : valor == 'SORTIDA'
                                    ? 'Sortides'
                                    : 'Retirades',
                              ),
                              selected: movimiento == valor,
                              onSelected: (_) =>
                                  setState(() => movimiento = valor),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                    Text('${visibles.length} moviments'),
                    if (visibles.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('No hi ha moviments amb aquests filtres.'),
                      ),
                    for (final fila in visibles)
                      MovimientoHorarioCard(fila: fila),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UltimosPasajeCard extends StatelessWidget {
  const UltimosPasajeCard({super.key, required this.datos, this.error = false});
  final Map<String, dynamic>? datos;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final continuado = datos?['servicio_continuado'] == true;
    final hora = datos == null ? null : horaSalidaCabecera(datos!);
    final nova = datos?['tren_desde_trinitat_nova'];
    final pau = datos?['tren_desde_la_pau'];
    final completos =
        nova != null &&
        nova.toString().trim().isNotEmpty &&
        pau != null &&
        pau.toString().trim().isNotEmpty;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Últims trens de passatge',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (error)
              const Text(
                'No s’han pogut carregar els últims trens de passatge.',
              )
            else if (datos == null)
              const Text(
                'No hi ha informació dels últims trens per a aquesta data.',
              )
            else if (continuado)
              const Text('Servei Non Stop · No hi ha últims trens de passatge')
            else if (!completos)
              const Text(
                'La informació dels últims trens és incompleta per a aquesta data.',
              )
            else ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  'Trinitat Nova → La Pau: ${numeroTrenHorario(nova)}',
                  style: const TextStyle(fontSize: 17),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  'La Pau → Trinitat Nova: ${numeroTrenHorario(pau)}',
                  style: const TextStyle(fontSize: 17),
                ),
              ),
              Text(
                hora == null
                    ? 'Hora de sortida de les capçaleres pendent de confirmar.'
                    : 'Sortida de les capçaleres: $hora${hora == '23:00' ? '' : ' de l’endemà'}.',
                style: const TextStyle(color: Colors.white70),
              ),
              const Text(
                'No inclou la recollida de personal.',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class MovimientoHorarioCard extends StatelessWidget {
  const MovimientoHorarioCard({super.key, required this.fila});
  final Map<String, dynamic> fila;

  @override
  Widget build(BuildContext context) {
    final salida = fila['movimiento'] == 'SORTIDA';
    final color = salida ? Colors.lightBlueAccent : Colors.orangeAccent;
    final direccion = fila['direccion']?.toString().trim() ?? '';
    return Card(
      margin: const EdgeInsets.only(top: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                Text(
                  salida ? 'SORTIDA' : 'RETIRADA',
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Tren ${numeroTrenHorario(fila['tren'])}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  fila['deposito'] == 'LA PAU'
                      ? 'La Pau'
                      : fila['deposito'] == 'TRINITAT NOVA'
                      ? 'Trinitat Nova'
                      : '${fila['deposito']}',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 32,
              runSpacing: 12,
              children: [
                hora('Hora de línia', fila['hora_linea']),
                hora('Hora de dipòsit', fila['hora_deposito']),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Trens en línia: ${fila['trenes_en_linea']} · Direcció: ${direccion.isEmpty ? '—' : direccion}',
            ),
            if (direccion.startsWith('REC-'))
              const Text(
                'Recollida de personal',
                style: TextStyle(color: Colors.white70),
              ),
          ],
        ),
      ),
    );
  }

  Widget hora(String titulo, dynamic valor) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(titulo, style: const TextStyle(color: Colors.white70)),
      Text(
        valor?.toString() ?? '—',
        style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
      ),
    ],
  );
}
