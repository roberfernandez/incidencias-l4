import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const manualBucket = 'manual-incidencies-private';

/// Download bytes with the current user's JWT: no public/signed URL, no disk
/// cache and no service key. Storage RLS checks approval on each request.
class ImatgeManualProtegida extends StatefulWidget {
  final String path;
  final bool fullScreen;
  final Future<Uint8List> Function(String)? loader;
  const ImatgeManualProtegida({super.key, required this.path,
    this.fullScreen = false, this.loader});
  @override
  State<ImatgeManualProtegida> createState() => _ImatgeManualProtegidaState();
}

class _ImatgeManualProtegidaState extends State<ImatgeManualProtegida>
    with WidgetsBindingObserver {
  Uint8List? bytes;
  bool failed = false;
  int generation = 0;
  StreamSubscription<AuthState>? subscription;
  Timer? recheck;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.loader == null) {
      subscription = Supabase.instance.client.auth.onAuthStateChange.listen((_) => load());
      recheck = Timer.periodic(const Duration(minutes: 1), (_) => load());
    }
    load();
  }
  void discard() {
    final old = bytes;
    bytes = null;
    if(old != null) MemoryImage(old).evict();
  }
  Future<void> load() async {
    final ticket = ++generation;
    setState(() { discard(); failed = false; });
    try {
      if (!widget.path.startsWith('manual/s2100/') || widget.path.contains('..')) {
        throw StateError('Invalid manual path');
      }
      Uint8List result;
      if (widget.loader != null) {
        result = await widget.loader!(widget.path);
      } else {
        final client = Supabase.instance.client;
        if (client.auth.currentSession == null) throw StateError('No session');
        result = await client.storage.from(manualBucket).download(widget.path);
      }
      if (mounted && generation == ticket) setState(() => bytes = result);
    } catch (_) {
      if (mounted && generation == ticket) setState(() { discard(); failed = true; });
    }
  }
  @override
  void didUpdateWidget(ImatgeManualProtegida old) {
    super.didUpdateWidget(old);
    if (old.path != widget.path) load();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) load();
    if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden) {
      generation++;
      setState(discard);
    }
  }
  @override
  void dispose() {
    generation++; subscription?.cancel(); recheck?.cancel();
    WidgetsBinding.instance.removeObserver(this); discard(); super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if(failed) return Column(mainAxisSize: MainAxisSize.min, children: [
      const Text('Imatge protegida no disponible. Comprova la sessió autoritzada i la connexió.', textAlign: TextAlign.center),
      TextButton(onPressed: load, child: const Text('Torna-ho a provar')),
    ]);
    if(bytes == null) return const Center(child: Padding(
      padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
    // The original MB legend is sideways: orient it for reading in both views.
    final image = RotatedBox(
      quarterTurns: widget.path == 'manual/s2100/compartits/termics-mb-llegenda.jpg' ? 3 : 0,
      child: Image.memory(bytes!, fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Text('No es pot mostrar la imatge.')),
    );
    if(widget.fullScreen) return InteractiveViewer(minScale: 1,maxScale: 6,
      child: Center(child: image));
    return Column(mainAxisSize: MainAxisSize.min, children: [
      InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: const Text('Imatge del manual')),
        body: ImatgeManualProtegida(path: widget.path,fullScreen:true,loader:widget.loader),
      ))), child: ConstrainedBox(constraints: const BoxConstraints(minHeight:80,minWidth:80,maxHeight:280),child:image)),
      const Text('Toca per ampliar · Imatge del manual S2100',textAlign:TextAlign.center),
    ]);
  }
}

