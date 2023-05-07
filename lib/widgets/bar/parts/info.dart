import 'package:flutter/material.dart';
import 'package:flutter_background_bar/widgets/bar/bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Info extends HookConsumerWidget {
  const Info({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BarContainer(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            const Icon(Icons.battery_3_bar, color: Colors.white),
            const SizedBox(width: 16),
            const Icon(Icons.audiotrack, color: Colors.white),
            const SizedBox(width: 16),
            const Icon(Icons.wifi, color: Colors.white),
            const SizedBox(width: 16),
            const Text('ENG'),
            const SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('13:00', style: TextStyle(fontSize: 13)),
                Text('07.05', style: TextStyle(fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
