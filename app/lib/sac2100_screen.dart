import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'data/s2100_data.dart';

/// The fixed SAC panel fits at 1x; only this viewport handles pan and zoom.
class Sac2100Screen extends StatelessWidget {
  final ValueChanged<String> onSelect;
  const Sac2100Screen({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF100C0C),
    appBar: AppBar(title: const Text('SAC / DISPLAY')),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = math.max(constraints.maxWidth, 660.0);
            final scale = MediaQuery.textScalerOf(context).scale(1);
            final panelHeight = 5 * 190 * math.max(1.0, scale) + 16;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Selecciona el número encès al SAC',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Amplia amb dos dits i arrossega per moure el panell.',
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: InteractiveViewer(
                    key: const ValueKey('sac-zoom'),
                    minScale: 1,
                    maxScale: 4,
                    panEnabled: true,
                    scaleEnabled: true,
                    child: SizedBox.expand(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: SizedBox(
                          width: width,
                          height: panelHeight.toDouble(),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: casellesSac2100.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 6,
                                  mainAxisExtent: 190 * math.max(1.0, scale),
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 4,
                                ),
                            itemBuilder: (context, index) {
                              final cell = casellesSac2100[index];
                              final enabled = cell.desti != null;
                              return OutlinedButton(
                                key: ValueKey('sac-${cell.numero}'),
                                onPressed: enabled
                                    ? () => onSelect(cell.desti!)
                                    : null,
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.all(6),
                                  backgroundColor: enabled
                                      ? const Color(0xFF391410)
                                      : const Color(0xFF181010),
                                  foregroundColor: const Color(0xFFFFAD72),
                                  side: BorderSide(
                                    color: enabled
                                        ? const Color(0xFF9C3A27)
                                        : const Color(0xFF322222),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                child: enabled
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            cell.text,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            cell.numero.toString().padLeft(
                                              2,
                                              '0',
                                            ),
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ),
  );
}

