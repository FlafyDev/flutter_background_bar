import 'package:flutter/material.dart';
import 'package:flutter_background_bar/widgets/bar/bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Sound extends HookConsumerWidget {
  const Sound({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BarContainer(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Center(
              child: Icon(Icons.volume_up, color: Colors.white),
            ),
            SizedOverflowBox(
              alignment: Alignment.centerLeft,
              size: const Size(150, 0),
              child: Container(
                padding: const EdgeInsets.only(left: 20),
                width: 150,
                child: Slider(
                  value: 0.5,
                  onChanged: (value) {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
