import 'imatge_manual_protegida.dart';
import 'sac2100_screen.dart';
import 'ios9000_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'acceso_screen.dart';
import 'horarios_screen.dart';
import 'data/s2100_data.dart';
import 'data/s9000_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: const String.fromEnvironment('L4_SUPABASE_URL', defaultValue: 'https://example.supabase.co'),
    publishableKey: const String.fromEnvironment('L4_SUPABASE_PUBLISHABLE_KEY', defaultValue: 'build-only-placeholder'),
  );

  runApp(const L4IncidenciasApp());
}

class L4IncidenciasApp extends StatelessWidget {
  const L4IncidenciasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Incidències L4',
      locale: const Locale('ca', 'ES'),
      supportedLocales: const [Locale('ca', 'ES')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF101010),
      ),
      home: const AccesoScreen(pantallaPrincipal: SelectorSerieScreen()),
    );
  }
}
// =====================================================
// UTILIDADES SUPABASE / LOGIN
// =====================================================

SupabaseClient get supabase => Supabase.instance.client;

Future<bool> asegurarEditor(BuildContext context) async {
  if (supabase.auth.currentSession != null) {
    return true;
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool cargando = false;
  String? error;

  final resultado = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          Future<void> iniciarSesion() async {
            final email = emailController.text.trim();
            final password = passwordController.text;

            if (email.isEmpty || password.isEmpty) {
              setState(() {
                error = 'Introdueix el correu i la contrasenya';
              });
              return;
            }

            setState(() {
              cargando = true;
              error = null;
            });

            try {
              await supabase.auth.signInWithPassword(
                email: email,
                password: password,
              );

              if (dialogContext.mounted) {
                Navigator.pop(dialogContext, true);
              }
            } catch (e) {
              setState(() {
                cargando = false;
                error = 'No s’ha pogut iniciar la sessió.\n$e';
              });
            }
          }

          return AlertDialog(
            title: const Text('Accés d’edició'),
            content: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Per afegir, editar o eliminar incidències has d’identificar-te com a editor.',
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Correu',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Contrasenya',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) {
                      if (!cargando) {
                        iniciarSesion();
                      }
                    },
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      error!,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: cargando
                    ? null
                    : () => Navigator.pop(dialogContext, false),
                child: const Text('CANCEL·LAR'),
              ),
              FilledButton(
                onPressed: cargando ? null : iniciarSesion,
                child: cargando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('ENTRAR'),
              ),
            ],
          );
        },
      );
    },
  );

  emailController.dispose();
  passwordController.dispose();

  return resultado == true;
}

// =====================================================
// PANTALLA 1: SELECTOR DE SERIE
// =====================================================

class SelectorSerieScreen extends StatelessWidget {
  const SelectorSerieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'INCIDÈNCIES L4 - TMB',
          style: TextStyle(
            color: Colors.yellow,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF181818),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF121212), Color(0xFF0D0D0D)],
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    right: -10,
                    top: -25,
                    child: Icon(
                      Icons.train_outlined,
                      size: 110,
                      color: Colors.white.withValues(alpha: 0.035),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'SELECCIONA MATERIAL MÒBIL',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.25,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              FilledButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HorariosScreen()),
                ),
                icon: const Icon(Icons.schedule),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('HORARIS · SORTIDES I RETIRADES'),
                ),
              ),
              const SizedBox(height: 20),
              SelectorSerieCard(
                serie: '2100',
                imagenPath: 'assets/2100.jpg',
                colorAcento: const Color(0xFFE65353),
                textoADerecha: true,
                alPulsar: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TriajeS2100Screen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 14),
              PictogramesPortadaFranja(
                imatge: 'assets/resolucion/pictogramas_s9000_localitzacio.png',
              ),
              const SizedBox(height: 14),

              SelectorSerieCard(
                serie: '9000',
                imagenPath: 'assets/9000.jpg',
                colorAcento: const Color(0xFF4295E8),
                alPulsar: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TriajeS9000Screen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),
              PictogramesPortadaFranja(
                imatge: 'assets/resolucion/pictogramas_s9000_ddu.png',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PictogramesPortadaFranja extends StatelessWidget {
  final String imatge;

  const PictogramesPortadaFranja({super.key, required this.imatge});

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _MarcDiscontinuGroc(),
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 105),
        child: Center(
          child: Image.asset(
            imatge,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const Text(
              'Imatge no disponible',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ),
    ),
  );
}

class _MarcDiscontinuGroc extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.yellow..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    final path = Path()..addRRect(RRect.fromRectAndRadius(
      Offset.zero & size, const Radius.circular(14)));
    for (final metric in path.computeMetrics()) {
      for (double distance = 0; distance < metric.length; distance += 12) {
        canvas.drawPath(metric.extractPath(distance,
          (distance + 7).clamp(0.0, metric.length)), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SelectorSerieCard extends StatelessWidget {
  final String serie;
  final String imagenPath;
  final Color colorAcento;
  final VoidCallback alPulsar;
  final bool textoADerecha;

  const SelectorSerieCard({
    super.key,
    required this.serie,
    required this.imagenPath,
    required this.colorAcento,
    required this.alPulsar,
    this.textoADerecha = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 235,
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colorAcento.withValues(alpha: 0.72),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: colorAcento.withValues(alpha: 0.12),
            blurRadius: 18,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: alPulsar,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  imagenPath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) {
                    return Center(
                      child: Icon(Icons.train, size: 70, color: colorAcento),
                    );
                  },
                ),

                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: textoADerecha
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      end: textoADerecha
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      colors: [
                        Colors.black.withValues(alpha: 0.93),
                        Colors.black.withValues(alpha: 0.68),
                        Colors.black.withValues(alpha: 0.08),
                      ],
                      stops: const [0.0, 0.38, 0.78],
                    ),
                  ),
                ),

                Positioned(
                  left: textoADerecha ? null : 20,
                  right: textoADerecha ? 20 : null,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: textoADerecha
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SÈRIE',
                          style: TextStyle(
                            color: colorAcento,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          serie,
                          style: TextStyle(
                            color: colorAcento,
                            fontSize: 43,
                            height: 1,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 13),
                        Container(
                          width: 38,
                          height: 3,
                          decoration: BoxDecoration(
                            color: colorAcento,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  left: textoADerecha ? 16 : null,
                  right: textoADerecha ? null : 16,
                  bottom: 16,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorAcento,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colorAcento.withValues(alpha: 0.35),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================
// BOTONES REUTILIZABLES
// =====================================================

class BotonTriaje extends StatelessWidget {
  final String texto;
  final Color colorFondo;
  final VoidCallback alPulsar;

  const BotonTriaje({
    super.key,
    required this.texto,
    required this.colorFondo,
    required this.alPulsar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorFondo,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: alPulsar,
        child: Text(
          texto,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}

class BotonTriajePrincipal extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final Color colorFondo;
  final String? imagenFondo;
  final IconData icono;
  final VoidCallback alPulsar;

  const BotonTriajePrincipal({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.colorFondo,
    this.imagenFondo,
    required this.icono,
    required this.alPulsar,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 178),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: alPulsar,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: imagenFondo == null
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorFondo,
                        Color.lerp(colorFondo, Colors.black, 0.20)!,
                      ],
                    )
                  : null,
              image: imagenFondo != null
                  ? DecorationImage(
                      image: AssetImage(imagenFondo!),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withValues(alpha: 0.58),
                        BlendMode.darken,
                      ),
                    )
                  : null,
              border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
              boxShadow: [
                BoxShadow(
                  color: colorFondo.withValues(alpha: 0.18),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icono, size: 32, color: Colors.white),
                  const SizedBox(height: 11),
                  Text(
                    titulo,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.05,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitulo,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BotonTriajeCompacto extends StatelessWidget {
  final String texto;
  final Color colorFondo;
  final VoidCallback alPulsar;

  const BotonTriajeCompacto({
    super.key,
    required this.texto,
    required this.colorFondo,
    required this.alPulsar,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: alPulsar,
          child: Ink(
            decoration: BoxDecoration(
              color: colorFondo,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
              child: Center(
                child: Text(
                  texto,
                  maxLines: 5,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.2,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BotonCarruselTrenes extends StatelessWidget {
  final VoidCallback alPulsar;

  const BotonCarruselTrenes({super.key, required this.alPulsar});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: alPulsar,
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple[800]!, Colors.purple[600]!],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.train_rounded, color: Colors.white, size: 26),
                  SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      'CARRUSEL DE TRENS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================
// SÈRIE 2100
// =====================================================

class TriajeS2100Screen extends StatefulWidget {
  const TriajeS2100Screen({super.key});

  @override
  State<TriajeS2100Screen> createState() => _TriajeS2100ScreenState();
}

class _TriajeS2100ScreenState extends State<TriajeS2100Screen> {
  final Map<String, SesionDiagnostico> _sesiones = {};

  SesionDiagnostico _sesion(String inicio) =>
      _sesiones.putIfAbsent(inicio, () => SesionDiagnostico(inicio));

  void _volverInicio() {
    // Home abandons the current S2100 incident; Back keeps normal navigation.
    _sesiones.clear();
    final inicio = ModalRoute.of(context);
    Navigator.of(context).popUntil((route) => route == inicio);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SÈRIE 2100',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: const Color(0xFF181818),
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Tornar a selecció de material',
            icon: const Icon(Icons.home_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF121212), Color(0xFF0D0D0D)],
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'QUÈ LI PASSA AL TREN?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 22),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: BotonTriajePrincipal(
                      titulo: 'NO\nDESFRENA',
                      subtitulo: 'Llaç d’emergència 3,5 kg',
                      colorFondo: const Color(0xFFD92F2F),
                      imagenFondo: 'assets/triaje/no_desfrena.png',
                      icono: Icons.warning_amber_rounded,
                      alPulsar: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DiagnosticoInteractivoScreen(
                              pasoInicialId: 'pregunta_seta',
                              sesion: _sesion('pregunta_seta'),
                              volverInicio: _volverInicio,
                              pasos: ramaNoDesfrenaS2100,
                              causasPorRama: causasPorRama,
                              enlacesCausasAIr: enlacesCausasAIr,
                              claveCausas: 'no_desfrena',
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: BotonTriajePrincipal(
                      titulo: 'NO\nTRACCIONA',
                      subtitulo: 'Llaç de portes',
                      colorFondo: const Color(0xFFF27600),
                      imagenFondo: 'assets/triaje/no_tracciona.png',
                      icono: Icons.bolt_rounded,
                      alPulsar: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DiagnosticoInteractivoScreen(
                              pasoInicialId: 'inicio_no_tracciona',
                              sesion: _sesion('inicio_no_tracciona'),
                              volverInicio: _volverInicio,
                              pasos: ramaNoDesfrenaS2100,
                              causasPorRama: causasPorRama,
                              enlacesCausasAIr: enlacesCausasAIr,
                              claveCausas: 'no_tracciona',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Card(
                key: const ValueKey('sac-display-entry'),
                margin: EdgeInsets.zero,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  leading: const Icon(
                    Icons.grid_view,
                    color: Colors.deepOrangeAccent,
                  ),
                  title: const Text('SAC / DISPLAY'),
                  subtitle: const Text('Avaria identificada pel tren'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Sac2100Screen(
                        onSelect: (desti) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DiagnosticoInteractivoScreen(
                                pasoInicialId: desti,
                                sesion: _sesion(desti),
                                volverInicio: _volverInicio,
                                pasos: ramaNoDesfrenaS2100,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: BotonTriajeCompacto(
                      texto: 'MODE ESPECIAL',
                      colorFondo: Colors.teal[700]!,
                      alPulsar: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DiagnosticoInteractivoScreen(
                              pasoInicialId: 'inicio_modo_especial',
                              sesion: _sesion('inicio_modo_especial'),
                              volverInicio: _volverInicio,
                              pasos: ramaNoDesfrenaS2100,
                              causasPorRama: causasPorRama,
                              enlacesCausasAIr: enlacesCausasAIr,
                              claveCausas: 'modo_especial',
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: BotonTriajeCompacto(
                      texto: 'Apertura/tancament portes des de CONTROLAS',
                      colorFondo: Colors.blue[800]!,
                      alPulsar: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DiagnosticoInteractivoScreen(
                              pasoInicialId: 'inicio_pupitre_fallo',
                              sesion: _sesion('inicio_pupitre_fallo'),
                              volverInicio: _volverInicio,
                              pasos: ramaNoDesfrenaS2100,
                              causasPorRama: causasPorRama,
                              enlacesCausasAIr: enlacesCausasAIr,
                              claveCausas: 'apertura_cierre_pupitre',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: BotonTriajeCompacto(
                      texto: 'PICTOGRAMES',
                      colorFondo: const Color(0xFF8D6E63),
                      alPulsar: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PictogramasScreen(
                            serie: '2100',
                            volverInicio: _volverInicio,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: BotonTriajeCompacto(
                      texto: 'TÈRMICS',
                      colorFondo: Colors.blueGrey[700]!,
                      alPulsar: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PantallaImagenCompleta(
                              volverInicio: _volverInicio,
                              imagenPath:
                                  'manual/s2100/compartits/termics-existents.jpg',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              BotonCarruselTrenes(
                alPulsar: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CarruselTrenesScreen(serie: '2100'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================
// SÈRIE 9000
// =====================================================

class TriajeS9000Screen extends StatefulWidget {
  const TriajeS9000Screen({super.key});

  @override
  State<TriajeS9000Screen> createState() => _TriajeS9000ScreenState();
}

class _TriajeS9000ScreenState extends State<TriajeS9000Screen> {
  final Map<String, SesionDiagnostico> _sesiones = {};

  SesionDiagnostico _sesion(String inicio) =>
      _sesiones.putIfAbsent(inicio, () => SesionDiagnostico(inicio));

  void _volverInicio() {
    final inicio = ModalRoute.of(context);
    Navigator.of(context).popUntil((route) => route == inicio);
  }

  static const Map<String, String> pasoInicialPorRamaS9000 = {
    "no_desfrena": "pregunta_seta_s9000",
    "no_tracciona": "inicio_no_tracciona_s9000",
    "modos_conduccion": "inicio_menu_modos",
    "operativa_basica": "inicio_menu_operativa_1",
  };

  void _abrirCategoria(BuildContext context, String claveCausas) {
    final pasoInicialId = pasoInicialPorRamaS9000[claveCausas]!;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DiagnosticoInteractivoScreen(
          pasoInicialId: pasoInicialId,
          sesion: _sesion(pasoInicialId),
          volverInicio: _volverInicio,
          pasos: arbolS9000,
          causasPorRama: causasPorRamaS9000,
          enlacesCausasAIr: enlacesCausasAIrS9000,
          claveCausas: claveCausas,
        ),
      ),
    );
  }

  void _abrirPasoDirecto(
    BuildContext context, {
    required String pasoInicialId,
    required String claveCausas,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DiagnosticoInteractivoScreen(
          pasoInicialId: pasoInicialId,
          sesion: _sesion(pasoInicialId),
          volverInicio: _volverInicio,
          pasos: arbolS9000,
          causasPorRama: causasPorRamaS9000,
          enlacesCausasAIr: enlacesCausasAIrS9000,
          claveCausas: claveCausas,
        ),
      ),
    );
  }

  void _abrirMenuModos(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MenuS9000Screen(
          volverInicio: _volverInicio,
          titulo: 'MODES DE CONDUCCIÓ',
          opciones: [
            OpcionMenuS9000(
              texto: 'MODE ESPECIAL',
              color: Colors.teal,
              alPulsar: () => _abrirPasoDirecto(
                context,
                pasoInicialId: 'inicio_modo_especial_s9000',
                claveCausas: 'modos_conduccion',
              ),
            ),
            OpcionMenuS9000(
              texto: 'MODE SOCORS',
              color: Colors.deepPurple,
              alPulsar: () => _abrirPasoDirecto(
                context,
                pasoInicialId: 'inicio_modo_socorro',
                claveCausas: 'modos_conduccion',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _abrirMenuOperativa(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MenuS9000Screen(
          volverInicio: _volverInicio,
          titulo: 'OPERATIVA BÀSICA',
          opciones: [
            OpcionMenuS9000(
              texto: 'POSADA EN MARXA (P.A.)',
              color: Colors.green,
              alPulsar: () => _abrirPasoDirecto(
                context,
                pasoInicialId: 'inicio_puesta_marcha',
                claveCausas: 'operativa_basica',
              ),
            ),
            OpcionMenuS9000(
              texto: 'RESET DE BATERIES\n(final de línia)',
              color: Colors.orange,
              alPulsar: () => _abrirPasoDirecto(
                context,
                pasoInicialId: 'inicio_reset_baterias',
                claveCausas: 'operativa_basica',
              ),
            ),
            OpcionMenuS9000(
              texto: 'DESCONNEXIÓ\n(portes tancades)',
              color: Colors.blue,
              alPulsar: () => _abrirPasoDirecto(
                context,
                pasoInicialId: 'inicio_desc_cerradas',
                claveCausas: 'operativa_basica',
              ),
            ),
            OpcionMenuS9000(
              texto: 'DESCONNEXIÓ\n(portes obertes)',
              color: Colors.indigo,
              alPulsar: () => _abrirPasoDirecto(
                context,
                pasoInicialId: 'inicio_desc_abiertas',
                claveCausas: 'operativa_basica',
              ),
            ),
            OpcionMenuS9000(
              texto: 'INTRODUIR NÚMERO DE TREN',
              color: Colors.blueGrey,
              alPulsar: () => _abrirPasoDirecto(
                context,
                pasoInicialId: 'inicio_num_tren',
                claveCausas: 'operativa_basica',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _abrirTermics(BuildContext context) {
    _abrirPasoDirecto(
      context,
      pasoInicialId: 's9000_termics',
      claveCausas: 'avaries_s9000',
    );
  }

  void _abrirIos9000(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => Ios9000Screen(
        onSelect: (id) => _abrirPasoDirecto(
          context, pasoInicialId: id, claveCausas: 'avaries_s9000'),
      ),
    ));
  }

  Widget _casellesConsulta(BuildContext context) {
    OpcionMenuS9000 procediment(String text, Color color, String id) =>
        OpcionMenuS9000(
          texto: text,
          color: color,
          alPulsar: () => _abrirPasoDirecto(
            context,
            pasoInicialId: id,
            claveCausas: 'avaries_s9000',
          ),
        );
    final caselles = [
      OpcionMenuS9000(
        texto: 'MODES DE CONDUCCIÓ\n(especial / socors)',
        color: Colors.teal[700]!,
        alPulsar: () => _abrirMenuModos(context),
      ),
      OpcionMenuS9000(
        texto: 'OPERATIVA BÀSICA\n(P.A. / reset / desconnexió)',
        color: Colors.blue[800]!,
        alPulsar: () => _abrirMenuOperativa(context),
      ),
      OpcionMenuS9000(
        texto: 'TÈRMICS',
        color: Colors.blueGrey[700]!,
        alPulsar: () => _abrirTermics(context),
      ),
      OpcionMenuS9000(
        texto: 'PICTOGRAMES',
        color: const Color(0xFF8D6E63),
        alPulsar: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                PictogramasScreen(serie: '9000', volverInicio: _volverInicio),
          ),
        ),
      ),
      procediment('EQUIPS I SERVEIS', Colors.indigo[700]!, 's9000_menu_0'),
      procediment('PORTES', Colors.green[800]!, 's9000_menu_1'),
      procediment('AIRE I FRENS', Colors.cyan[800]!, 's9000_menu_2'),
      procediment(
        'REMOLCADA I DESACOBLAMENT',
        Colors.deepOrange[800]!,
        's9000_menu_3',
      ),
      procediment(
        'TREN STOP',
        Colors.pink[800]!,
        'procedimiento_tren_stop_s9000',
      ),
      procediment("TIRADOR D'ALARMA", Colors.red[900]!, 'inicio_tirador'),
    ];
    return LayoutBuilder(
      builder: (context, constraints) => Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final casella in caselles)
            SizedBox(
              width: (constraints.maxWidth - 10) / 2,
              child: BotonTriajeCompacto(
                texto: casella.texto,
                colorFondo: casella.color,
                alPulsar: casella.alPulsar,
              ),
            ),
          SizedBox(
            width: constraints.maxWidth,
            child: BotonCarruselTrenes(
              alPulsar: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CarruselTrenesScreen(serie: '9000'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SÈRIE 9000',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: const Color(0xFF181818),
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Tornar a selecci� de material',
            icon: const Icon(Icons.home_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF121212), Color(0xFF0D0D0D)],
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'QUÈ LI PASSA AL TREN?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 22),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: BotonTriajePrincipal(
                      titulo: 'NO\nDESFRENA',
                      subtitulo: 'Llaç d’emergència 3,5 kg',
                      colorFondo: const Color(0xFFD92F2F),
                      imagenFondo: 'assets/triaje/no_desfrena.png',
                      icono: Icons.warning_amber_rounded,
                      alPulsar: () => _abrirCategoria(context, 'no_desfrena'),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: BotonTriajePrincipal(
                      titulo: 'NO\nTRACCIONA',
                      subtitulo: 'Llaç de tracció',
                      colorFondo: const Color(0xFFF27600),
                      imagenFondo: 'assets/triaje/no_tracciona.png',
                      icono: Icons.bolt_rounded,
                      alPulsar: () => _abrirCategoria(context, 'no_tracciona'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: Card(
                  color: const Color(0xFF211F27),
                  child: ListTile(
                    key: const ValueKey('ios-ddU-entry-s9000'),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 17),
                    leading: const Icon(Icons.list_alt, color: Colors.amber, size: 32),
                    title: const Text('IOS / DDU',
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                    subtitle: const Text('Incidència detectada per la DDU'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _abrirIos9000(context),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _casellesConsulta(context),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================
// MENÚ SÈRIE 9000
// =====================================================

class OpcionMenuS9000 {
  final String texto;
  final Color color;
  final VoidCallback alPulsar;

  const OpcionMenuS9000({
    required this.texto,
    required this.color,
    required this.alPulsar,
  });
}

class MenuS9000Screen extends StatelessWidget {
  final VoidCallback volverInicio;
  final String titulo;
  final List<OpcionMenuS9000> opciones;

  const MenuS9000Screen({
    super.key,
    required this.volverInicio,
    required this.titulo,
    required this.opciones,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
        actions: [BotonHomeDiagnostico(onPressed: volverInicio)],
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        itemCount: opciones.length,
        itemBuilder: (context, index) {
          final opcion = opciones[index];

          return BotonTriaje(
            texto: opcion.texto,
            colorFondo: opcion.color,
            alPulsar: opcion.alPulsar,
          );
        },
      ),
    );
  }
}

// =====================================================
// CUADRÍCULA DE TRENES
// SOLO CARGA ID + NUMERO + SERIE
// =====================================================

class CarruselTrenesScreen extends StatefulWidget {
  final String serie;

  const CarruselTrenesScreen({super.key, required this.serie});

  @override
  State<CarruselTrenesScreen> createState() => _CarruselTrenesScreenState();
}

class _CarruselTrenesScreenState extends State<CarruselTrenesScreen> {
  late Future<List<Map<String, dynamic>>> _futureTrenes;

  @override
  void initState() {
    super.initState();
    _futureTrenes = _cargarTrenes();
  }

  Future<List<Map<String, dynamic>>> _cargarTrenes() async {
    final respuesta = await supabase
        .from('trenes')
        .select('id, numero, serie')
        .eq('serie', widget.serie)
        .order('numero', ascending: true);

    return List<Map<String, dynamic>>.from(respuesta);
  }

  Future<void> _recargar() async {
    setState(() {
      _futureTrenes = _cargarTrenes();
    });

    await _futureTrenes;
  }

  Future<void> _abrirNuevoTren() async {
    final autorizado = await asegurarEditor(context);

    if (!autorizado || !mounted) return;

    final creado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => NuevoTrenScreen(serie: widget.serie)),
    );

    if (creado == true) {
      await _recargar();
    }
  }

  @override
  Widget build(BuildContext context) {
    final editor = supabase.auth.currentSession != null;

    return Scaffold(
      appBar: AppBar(
        title: Text('TRENS SÈRIE ${widget.serie}'),
        backgroundColor: const Color(0xFF1E1E1E),
        actions: [
          if (editor)
            IconButton(
              tooltip: widget.serie == '2100'
                  ? 'Tornar a Què li passa al tren?'
                  : 'Tornar a Qu� li passa al tren?',
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () async {
                if (mounted) {
                  Navigator.pop(context);
                }
              },
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirNuevoTren,
        icon: const Icon(Icons.add),
        label: const Text('AFEGIR TREN'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureTrenes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.cloud_off,
                      size: 60,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No s’han pogut carregar els trens',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('${snapshot.error}', textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _recargar,
                      icon: const Icon(Icons.refresh),
                      label: const Text('TORNAR-HO A PROVAR'),
                    ),
                  ],
                ),
              ),
            );
          }

          final trenes = snapshot.data ?? [];

          if (trenes.isEmpty) {
            return RefreshIndicator(
              onRefresh: _recargar,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: Center(
                      child: Text(
                        'No hi ha trens carregats de la sèrie ${widget.serie}.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _recargar,
            child: GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 100),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.15,
              ),
              itemCount: trenes.length,
              itemBuilder: (context, index) {
                final tren = trenes[index];

                final numero = (tren['numero'] ?? '').toString();

                return Card(
                  color: const Color(0xFF1E1E1E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: Colors.white12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FichaTrenScreen(trenInicial: tren),
                        ),
                      );

                      await _recargar();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.train,
                            size: 34,
                            color: Colors.white54,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            numero,
                            style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// =====================================================
// FICHA INDIVIDUAL DEL TREN
// =====================================================

class FichaTrenScreen extends StatefulWidget {
  final Map<String, dynamic> trenInicial;

  const FichaTrenScreen({super.key, required this.trenInicial});

  @override
  State<FichaTrenScreen> createState() => _FichaTrenScreenState();
}

class _FichaTrenScreenState extends State<FichaTrenScreen> {
  late Map<String, dynamic> tren;

  bool guardando = false;
  bool cargandoFicha = true;
  String? errorCarga;

  @override
  void initState() {
    super.initState();

    tren = Map<String, dynamic>.from(widget.trenInicial);

    _cargarFichaCompleta();
  }

  Future<void> _cargarFichaCompleta() async {
    try {
      final respuesta = await supabase
          .from('trenes')
          .select('id, numero, serie, imagen, incidencias')
          .eq('id', tren['id'])
          .single();

      if (mounted) {
        setState(() {
          tren = Map<String, dynamic>.from(respuesta);

          cargandoFicha = false;
          errorCarga = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          cargandoFicha = false;
          errorCarga = e.toString();
        });
      }
    }
  }

  Future<void> _recargarTren() async {
    await _cargarFichaCompleta();
  }

  List<String> _listaIncidencias() {
    final texto = (tren['incidencias'] ?? '').toString().trim();

    if (texto.isEmpty) {
      return [];
    }

    return texto
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Future<void> _anadirIncidencia() async {
    final autorizado = await asegurarEditor(context);

    if (!autorizado || !mounted) return;

    final controller = TextEditingController();

    final nueva = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Nova incidència · ${tren['numero']}'),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLines: 5,
            minLines: 2,
            decoration: const InputDecoration(
              hintText: 'Escriu la incidència...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('CANCEL·LAR'),
            ),
            FilledButton(
              onPressed: () {
                final texto = controller.text.trim();

                if (texto.isNotEmpty) {
                  Navigator.pop(dialogContext, texto);
                }
              },
              child: const Text('AFEGIR'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (nueva == null || nueva.trim().isEmpty) {
      return;
    }

    final actuales = _listaIncidencias();

    actuales.add(nueva.trim());

    final nuevoTexto = actuales.join('\n');

    setState(() {
      guardando = true;
    });

    try {
      await supabase
          .from('trenes')
          .update({'incidencias': nuevoTexto})
          .eq('id', tren['id']);

      await _recargarTren();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Incidència afegida')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('No s’ha pogut desar: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          guardando = false;
        });
      }
    }
  }

  Future<void> _eliminarIncidencia(int indice) async {
    final autorizado = await asegurarEditor(context);

    if (!autorizado || !mounted) return;

    final incidencias = _listaIncidencias();

    if (indice < 0 || indice >= incidencias.length) {
      return;
    }

    final incidencia = incidencias[indice];

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar incidència'),
          content: Text(
            'Segur que vols eliminar aquesta incidència?\n\n$incidencia',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('CANCEL·LAR'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red[700]),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('ELIMINAR'),
            ),
          ],
        );
      },
    );

    if (confirmar != true) {
      return;
    }

    incidencias.removeAt(indice);

    final nuevoTexto = incidencias.join('\n');

    setState(() {
      guardando = true;
    });

    try {
      await supabase
          .from('trenes')
          .update({'incidencias': nuevoTexto})
          .eq('id', tren['id']);

      await _recargarTren();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Incidència eliminada')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('No s’ha pogut eliminar: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          guardando = false;
        });
      }
    }
  }

  Future<void> _editarIncidencias() async {
    final autorizado = await asegurarEditor(context);

    if (!autorizado || !mounted) return;

    final controller = TextEditingController(
      text: (tren['incidencias'] ?? '').toString(),
    );

    final resultado = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Editar incidències · ${tren['numero']}'),
          content: TextField(
            controller: controller,
            maxLines: 12,
            minLines: 5,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('CANCEL·LAR'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, controller.text.trim());
              },
              child: const Text('DESAR'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (resultado == null) return;

    setState(() {
      guardando = true;
    });

    try {
      await supabase
          .from('trenes')
          .update({'incidencias': resultado})
          .eq('id', tren['id']);

      await _recargarTren();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incidències actualitzades')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No s’ha pogut actualitzar: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          guardando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final numero = (tren['numero'] ?? '').toString();

    if (cargandoFicha) {
      return Scaffold(
        appBar: AppBar(
          title: Text('TREN $numero'),
          backgroundColor: const Color(0xFF1E1E1E),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (errorCarga != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('TREN $numero'),
          backgroundColor: const Color(0xFF1E1E1E),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_off, size: 56, color: Colors.redAccent),
                const SizedBox(height: 16),
                const Text(
                  'No s’ha pogut carregar la fitxa del tren',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  errorCarga!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      cargandoFicha = true;
                      errorCarga = null;
                    });

                    _cargarFichaCompleta();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('TORNAR-HO A PROVAR'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final imagen = (tren['imagen'] ?? '').toString();

    final incidencias = _listaIncidencias();

    return Scaffold(
      appBar: AppBar(
        title: Text('TREN $numero'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: imagen.isEmpty
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PantallaImagenRedCompleta(
                            imagenUrl: imagen,
                            titulo: numero,
                          ),
                        ),
                      );
                    },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: 220,
                    maxHeight: 500,
                  ),
                  color: Colors.black,
                  child: imagen.isEmpty
                      ? const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 70,
                            color: Colors.white38,
                          ),
                        )
                      : Image.network(
                          imagen,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) {
                              return child;
                            }

                            return const SizedBox(
                              height: 280,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          },
                          errorBuilder: (_, _, _) {
                            return const SizedBox(
                              height: 280,
                              child: Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 70,
                                  color: Colors.redAccent,
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),

            const SizedBox(height: 22),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'INCIDÈNCIES',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  tooltip: 'Editar totes les incidències',
                  onPressed: guardando ? null : _editarIncidencias,
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),

            const SizedBox(height: 8),

            if (incidencias.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: const Text(
                  'Sense incidències registrades',
                  style: TextStyle(fontSize: 18, color: Colors.white54),
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  children: List.generate(incidencias.length, (index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 4, 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  incidencias[index],
                                  style: const TextStyle(
                                    fontSize: 17,
                                    height: 1.35,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: 'Eliminar incidència',
                                onPressed: guardando
                                    ? null
                                    : () => _eliminarIncidencia(index),
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (index < incidencias.length - 1)
                          const Divider(height: 1, color: Colors.white12),
                      ],
                    );
                  }),
                ),
              ),

            const SizedBox(height: 20),

            FilledButton.icon(
              onPressed: guardando ? null : _anadirIncidencia,
              icon: const Icon(Icons.add),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('AFEGIR INCIDÈNCIA'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// AFEGIR TREN NUEVO
// =====================================================

class NuevoTrenScreen extends StatefulWidget {
  final String serie;

  const NuevoTrenScreen({super.key, required this.serie});

  @override
  State<NuevoTrenScreen> createState() => _NuevoTrenScreenState();
}

class _NuevoTrenScreenState extends State<NuevoTrenScreen> {
  final numeroController = TextEditingController();

  final incidenciasController = TextEditingController();

  XFile? imagenSeleccionada;
  bool guardando = false;

  @override
  void dispose() {
    numeroController.dispose();
    incidenciasController.dispose();
    super.dispose();
  }

  Future<void> _elegirImagen([ImageSource source = ImageSource.gallery]) async {
    final picker = ImagePicker();

    final archivo = await picker.pickImage(source: source, imageQuality: 95);

    if (archivo != null && mounted) {
      setState(() {
        imagenSeleccionada = archivo;
      });
    }
  }

  String _extensionArchivo(String nombre) {
    final lower = nombre.toLowerCase();

    if (lower.endsWith('.png')) {
      return 'png';
    }

    if (lower.endsWith('.webp')) {
      return 'webp';
    }

    return 'jpg';
  }

  String _mimeType(String extension) {
    switch (extension) {
      case 'png':
        return 'image/png';

      case 'webp':
        return 'image/webp';

      default:
        return 'image/jpeg';
    }
  }

  Future<void> _guardar() async {
    final numero = numeroController.text.trim();

    if (numero.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Introdueix el número del tren')),
      );
      return;
    }

    if (imagenSeleccionada == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecciona una imatge')));
      return;
    }

    setState(() {
      guardando = true;
    });

    try {
      final existente = await supabase
          .from('trenes')
          .select('id')
          .eq('numero', numero)
          .maybeSingle();

      if (existente != null) {
        throw Exception('Ja existeix un tren amb el número $numero');
      }

      final extension = _extensionArchivo(imagenSeleccionada!.name);

      final nombreStorage = '$numero.$extension';

      final bytes = await imagenSeleccionada!.readAsBytes();

      await supabase.storage
          .from('composiciones')
          .uploadBinary(
            nombreStorage,
            bytes,
            fileOptions: FileOptions(
              contentType: _mimeType(extension),
              upsert: false,
            ),
          );

      final url = supabase.storage
          .from('composiciones')
          .getPublicUrl(nombreStorage);

      await supabase.from('trenes').insert({
        'numero': numero,
        'serie': widget.serie,
        'imagen': url,
        'incidencias': incidenciasController.text.trim(),
      });

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No s’ha pogut afegir el tren:\n$e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          guardando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AFEGIR TREN · ${widget.serie}'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: numeroController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Número del tren',
                hintText: 'Ex. 2161',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 18),

            OutlinedButton.icon(
              onPressed: guardando ? null : _elegirImagen,
              icon: const Icon(Icons.photo_library),
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text('SELECCIONAR FOTO'),
              ),
            ),

            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: guardando
                  ? null
                  : () => _elegirImagen(ImageSource.camera),
              icon: const Icon(Icons.camera_alt),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('FER FOTO'),
              ),
            ),
            if (imagenSeleccionada != null) ...[
              const SizedBox(height: 18),
              Image.network(
                imagenSeleccionada!.path,
                height: 220,
                fit: BoxFit.contain,
              ),
            ],

            const SizedBox(height: 18),

            TextField(
              controller: incidenciasController,
              minLines: 3,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: 'Incidències inicials (opcional)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: guardando ? null : _guardar,
              icon: guardando
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('DESAR TREN'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// IMAGEN DE RED A PANTALLA COMPLETA
// =====================================================

class PantallaImagenRedCompleta extends StatefulWidget {
  final String imagenUrl;
  final String titulo;

  const PantallaImagenRedCompleta({
    super.key,
    required this.imagenUrl,
    required this.titulo,
  });

  @override
  State<PantallaImagenRedCompleta> createState() =>
      _PantallaImagenRedCompletaState();
}

class _PantallaImagenRedCompletaState extends State<PantallaImagenRedCompleta> {
  final TransformationController controller = TransformationController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.titulo),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            tooltip: 'Restablir el zoom',
            onPressed: () {
              controller.value = Matrix4.identity();
            },
            icon: const Icon(Icons.center_focus_strong),
          ),
        ],
      ),
      body: SafeArea(
        child: InteractiveViewer(
          transformationController: controller,
          minScale: 1,
          maxScale: 6,
          boundaryMargin: const EdgeInsets.all(400),
          clipBehavior: Clip.none,
          child: Center(
            child: Image.network(
              widget.imagenUrl,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              loadingBuilder: (context, child, progress) {
                if (progress == null) {
                  return child;
                }

                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (_, _, _) {
                return const Icon(
                  Icons.broken_image,
                  size: 70,
                  color: Colors.redAccent,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================
// MOTOR DE DIAGNÓSTICO
// =====================================================

class SesionDiagnostico {
  String pasoActualId;
  final Set<String> causasDescartadas = {};
  final List<({String pasoId, String? causaDescartadaAqui})> historial = [];

  SesionDiagnostico(this.pasoActualId);

  void avanzar(String destino, {String? causa}) {
    final nueva = causa != null && causasDescartadas.add(causa);
    historial.add((
      pasoId: pasoActualId,
      causaDescartadaAqui: nueva ? causa : null,
    ));
    pasoActualId = destino;
  }

  bool retroceder() {
    if (historial.isEmpty) return false;
    final anterior = historial.removeLast();
    if (anterior.causaDescartadaAqui != null) {
      causasDescartadas.remove(anterior.causaDescartadaAqui);
    }
    pasoActualId = anterior.pasoId;
    return true;
  }
}

class BotonHomeDiagnostico extends StatelessWidget {
  final VoidCallback onPressed;
  const BotonHomeDiagnostico({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: 'Inici de Resolució d’avaries',
    icon: const Icon(Icons.home_outlined),
    onPressed: onPressed,
  );
}

class DiagnosticoInteractivoScreen extends StatefulWidget {
  final String pasoInicialId;
  final SesionDiagnostico sesion;
  final VoidCallback volverInicio;

  final Map<String, PasoDiagnostico> pasos;

  final Map<String, List<String>>? causasPorRama;

  final Map<String, String>? enlacesCausasAIr;

  final String? claveCausas;

  const DiagnosticoInteractivoScreen({
    super.key,
    required this.pasoInicialId,
    required this.sesion,
    required this.volverInicio,
    required this.pasos,
    this.causasPorRama,
    this.enlacesCausasAIr,
    this.claveCausas,
  });

  @override
  State<DiagnosticoInteractivoScreen> createState() =>
      _DiagnosticoInteractivoScreenState();
}

class _DiagnosticoInteractivoScreenState
    extends State<DiagnosticoInteractivoScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _procesarRespuesta(String destino, {String? causaADescartar}) {
    setState(() => widget.sesion.avanzar(destino, causa: causaADescartar));
    if (_scrollController.hasClients) _scrollController.jumpTo(0);
  }

  bool _retrocederPaso() {
    if (widget.sesion.historial.isEmpty) return false;
    setState(() => widget.sesion.retroceder());
    if (_scrollController.hasClients) _scrollController.jumpTo(0);
    return true;
  }

  Widget _construirTextoFormateado(String texto) {
    final spans = <InlineSpan>[];
    final simbolos = RegExp(r'🟥|▼|🔻');
    var inicio = 0;
    for (final match in simbolos.allMatches(texto)) {
      spans.add(TextSpan(text: texto.substring(inicio, match.start)));
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Icon(
            match.group(0) == '🟥' ? Icons.square : Icons.arrow_drop_down,
            color: Colors.redAccent,
            size: 26,
          ),
        ),
      );
      inicio = match.end;
    }
    spans.add(TextSpan(text: texto.substring(inicio)));
    return Text.rich(
      TextSpan(children: spans),
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 20, color: Colors.white, height: 1.3),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paso = widget.pasos[widget.sesion.pasoActualId];
    final causas = List<String>.from(
      widget.causasPorRama?[widget.claveCausas] ?? const <String>[],
    );
    if (widget.claveCausas == 'no_tracciona') {
      causas.sort((a, b) {
        int orden(String c) {
          if (c.startsWith('Portes')) return 0;
          if (c.contains('Estacionament') || c.contains('estacionament')) {
            return 1;
          }
          if (c.contains('Disjuntor') || c.contains('disjuntor')) return 2;
          if (c.contains('EED') || c.contains('Tirador verd')) return 3;
          if (c.contains('Tensi')) return 4;
          return 99;
        }

        return orden(a).compareTo(orden(b));
      });
    }
    String? lletraMnemonic(String causa) {
      if (widget.claveCausas == 'no_tracciona') {
        if (causa.startsWith('Portes')) return 'P';
        if (causa.contains('Estacionament') ||
            causa.contains('estacionament')) {
          return 'E';
        }
        if (causa.contains('Disjuntor') || causa.contains('disjuntor')) {
          return 'D';
        }
        if (causa.contains('EED') || causa.contains('Tirador verd')) return 'E';
        if (causa.contains('Tensi')) return 'T';
      }
      if (widget.claveCausas == 'no_desfrena') {
        if (causa.contains('Bolet')) return 'B';
        if (causa.contains('ATP')) return 'A';
        if (causa.contains('Home mort') || causa.contains('home mort'))
          return 'H';
        if (causa.contains('Aire') || causa.contains('TDP')) return 'A';
        if (causa.contains('Stop') || causa.contains('STOP')) return 'S';
        if (causa.contains('Tirador')) return 'T';
        if (causa.contains('Estacionament') ||
            causa.contains('estacionament')) {
          return 'E';
        }
      }
      return null;
    }

    final mnemonica = widget.claveCausas == 'no_desfrena'
        ? 'BAHASTE'
        : widget.claveCausas == 'no_tracciona'
        ? 'PEDET'
        : null;
    final filtroCoche =
        paso != null &&
        {
          'pregunta_b19_es_ma',
          'pregunta_b17_es_ma',
          'procedimiento_b12_esquema',
        }.contains(paso.id);

    return PopScope(
      canPop: widget.sesion.historial.isEmpty,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _retrocederPaso();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'RESOLUCIÓ D’AVARIES',
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: const Color(0xFF1E1E1E),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (!_retrocederPaso()) Navigator.pop(context);
            },
          ),
          actions: [BotonHomeDiagnostico(onPressed: widget.volverInicio)],
        ),
        body: paso == null
            ? Center(
                child: Text(
                  'Error: pas no trobat: ${widget.sesion.pasoActualId}',
                ),
              )
            : SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        children: [
                          if (causas.isNotEmpty) ...[
                            const Text(
                              'POSSIBLES CAUSES',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            if (mnemonica != null) ...[
                              const Center(
                                child: Text(
                                  'el millor manual és el que tens al cap',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Center(
                                child: Text(
                                  'Recorda: $mnemonica',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.amber,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                            for (final causa in causas)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(
                                      double.infinity,
                                      52,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 12,
                                    ),
                                    backgroundColor: const Color(0xFF252525),
                                    side: BorderSide(
                                      color:
                                          widget.sesion.causasDescartadas
                                              .contains(causa)
                                          ? Colors.white24
                                          : Colors.blueGrey.shade300,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    final destino =
                                        causa == 'Estacionaments aplicats' &&
                                            widget.claveCausas == 'no_tracciona'
                                        ? (widget.pasos.containsKey(
                                                'pregunta_estacionamiento_trac_s9000',
                                              )
                                              ? 'pregunta_estacionamiento_trac_s9000'
                                              : 'pregunta_estacionamiento')
                                        : widget.enlacesCausasAIr?[causa];
                                    if (destino != null &&
                                        destino != widget.sesion.pasoActualId) {
                                      _procesarRespuesta(destino);
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      if (lletraMnemonic(causa) != null) ...[
                                        SizedBox(
                                          width: 30,
                                          child: Text(
                                            lletraMnemonic(causa)!,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.amber,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                      Icon(
                                        widget.sesion.causasDescartadas
                                                .contains(causa)
                                            ? Icons.check_circle
                                            : Icons.radio_button_unchecked,
                                        color:
                                            widget.sesion.causasDescartadas
                                                .contains(causa)
                                            ? Colors.greenAccent
                                            : Colors.white70,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          causa,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                widget.sesion.causasDescartadas
                                                    .contains(causa)
                                                ? Colors.white60
                                                : Colors.white,
                                            decoration:
                                                widget.sesion.causasDescartadas
                                                    .contains(causa)
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.chevron_right,
                                        color: Colors.white70,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            const SizedBox(height: 8),
                          ],
                          Card(
                            color: const Color(0xFF1E1E1E),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (paso.imagenPath != null &&
                                      paso.imagenPath!.trim().isNotEmpty)
                                    VisorImagenDiagnostico(
                                      imagenPath: paso.imagenPath!,
                                      volverInicio: widget.volverInicio,
                                    ),
                                  _construirTextoFormateado(
                                    identical(widget.pasos, ramaNoDesfrenaS2100)
                                        ? textOperatiu2100(
                                            paso.preguntaOInstruccion,
                                          )
                                        : paso.preguntaOInstruccion,
                                  ),
                                  for (final imatge in paso.imatgesManual) ...[
                                    const SizedBox(height: 16),
                                    Text(
                                      identical(
                                            widget.pasos,
                                            ramaNoDesfrenaS2100,
                                          )
                                          ? textOperatiu2100(imatge.titol)
                                          : imatge.titol,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (identical(
                                          widget.pasos,
                                          ramaNoDesfrenaS2100,
                                        ) &&
                                        (imatge.variant.contains('remodelat') ||
                                            imatge.variant.contains(
                                              'original',
                                            )))
                                      Text(
                                        imatge.variant,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    if (!identical(
                                      widget.pasos,
                                      ramaNoDesfrenaS2100,
                                    ))
                                      Text(
                                        imatge.pagina == null
                                            ? imatge.variant
                                            : '${imatge.variant} · Manual, pàg. ${imatge.pagina}',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    const SizedBox(height: 8),
                                    VisorImagenDiagnostico(
                                      imagenPath: imatge.path,
                                      volverInicio: widget.volverInicio,
                                    ),
                                  ],
                                  for (final opcio in paso.opcions)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          minimumSize: const Size(0, 52),
                                        ),
                                        onPressed: () => _procesarRespuesta(
                                          opcio.desti,
                                          causaADescartar:
                                              opcio.causaADescartar,
                                        ),
                                        child: Text(
                                          opcio.text,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  if (paso.advertencia != null) ...[
                                    const SizedBox(height: 12),
                                    Text(
                                      identical(
                                            widget.pasos,
                                            ramaNoDesfrenaS2100,
                                          )
                                          ? textOperatiu2100(paso.advertencia!)
                                          : paso.advertencia!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: paso.opcions.isNotEmpty
                          ? const SizedBox.shrink()
                          : paso.esPregunta
                          ? Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 60,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green[700],
                                      ),
                                      onPressed: () => _procesarRespuesta(
                                        paso.botonSiDestino!,
                                        causaADescartar:
                                            paso.causaDescartadaAlSi,
                                      ),
                                      child: Text(
                                        filtroCoche ? 'COTXE MA' : 'SÍ',
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: SizedBox(
                                    height: 60,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red[700],
                                      ),
                                      onPressed: () => _procesarRespuesta(
                                        paso.botonNoDestino!,
                                        causaADescartar:
                                            paso.causaDescartadaAlNo,
                                      ),
                                      child: Text(
                                        filtroCoche ? 'COTXE MB / R' : 'NO',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (paso.botonSiDestino != null) {
                                    _procesarRespuesta(paso.botonSiDestino!);
                                  } else {
                                    widget.volverInicio();
                                  }
                                },
                                child: Text(
                                  paso.botonSiDestino != null
                                      ? 'CONTINUAR'
                                      : 'TORNAR A L’INICI',
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

// =====================================================
// VISOR DE IMÁGENES DE ASSETS
// =====================================================

class PictogramasScreen extends StatelessWidget {
  final String serie;
  final VoidCallback volverInicio;

  const PictogramasScreen({
    super.key,
    required this.serie,
    required this.volverInicio,
  });

  @override
  Widget build(BuildContext context) {
    final imagenes = serie == '2100'
        ? const [
            (
              'Localització al tren',
              'manual/s2100/compartits/pictogrames-existents.png',
            ),
          ]
        : const [
            (
              'Localització al tren',
              'assets/resolucion/pictogramas_s9000_localitzacio.png',
            ),
            (
              'Detall de la pantalla DDU',
              'assets/resolucion/pictogramas_s9000_ddu.png',
            ),
          ];
    return Scaffold(
      appBar: AppBar(
        title: Text('PICTOGRAMES · $serie'),
        actions: [BotonHomeDiagnostico(onPressed: volverInicio)],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Prem una imatge per ampliar-la. Pots fer zoom amb dos dits.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            for (final imagen in imagenes) ...[
              Text(
                imagen.$1,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              VisorImagenDiagnostico(
                imagenPath: imagen.$2,
                volverInicio: volverInicio,
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}

class VisorImagenDiagnostico extends StatelessWidget {
  final String imagenPath;
  final double factorAltura;
  final VoidCallback? volverInicio;
  const VisorImagenDiagnostico({
    super.key,
    required this.imagenPath,
    this.volverInicio,
    this.factorAltura = 1,
  });

  @override
  Widget build(BuildContext context) {
    if (imagenPath.trim().isEmpty) return const SizedBox.shrink();
    if (imagenPath.startsWith('manual/'))
      return ImatgeManualProtegida(path: imagenPath);
    return Image.asset(
      imagenPath,
      key: ValueKey(imagenPath),
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
      errorBuilder: (_, error, stackTrace) => const SizedBox.shrink(),
      frameBuilder: (context, child, frame, synchronous) {
        if (frame == null && !synchronous) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Semantics(
            button: true,
            label: 'Ampliar imatge',
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PantallaImagenCompleta(
                    imagenPath: imagenPath,
                    volverInicio: volverInicio,
                  ),
                ),
              ),
              child: Align(
                heightFactor: factorAltura,
                child: Transform.scale(
                  scaleY: factorAltura,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 280),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class PantallaImagenCompleta extends StatefulWidget {
  final VoidCallback? volverInicio;
  final String imagenPath;

  const PantallaImagenCompleta({
    super.key,
    this.volverInicio,
    required this.imagenPath,
  });

  @override
  State<PantallaImagenCompleta> createState() => _PantallaImagenCompletaState();
}

class _PantallaImagenCompletaState extends State<PantallaImagenCompleta> {
  final TransformationController controller = TransformationController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Imatge'),
        actions: [
          if (widget.volverInicio != null)
            BotonHomeDiagnostico(onPressed: widget.volverInicio!),
          if (!widget.imagenPath.startsWith('manual/'))
            IconButton(
              icon: const Icon(Icons.center_focus_strong),
              onPressed: () {
                controller.value = Matrix4.identity();
              },
            ),
        ],
      ),
      body: widget.imagenPath.startsWith('manual/')
          ? ImatgeManualProtegida(path: widget.imagenPath, fullScreen: true)
          : InteractiveViewer(
              transformationController: controller,
              minScale: 1,
              maxScale: 6,
              boundaryMargin: const EdgeInsets.all(400),
              clipBehavior: Clip.none,
              child: Center(
                child: Image.asset(
                  widget.imagenPath,
                  fit: BoxFit.cover,
                  cacheHeight: widget.imagenPath.contains('termicos_')
                      ? 4096
                      : null,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
    );
  }
}
