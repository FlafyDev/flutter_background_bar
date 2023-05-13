import 'package:flutter/material.dart';
import 'package:flutter_background_bar/widgets/bar/bar.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Sound extends HookConsumerWidget {
  const Sound({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toggleAnimController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );

    const size = 32.0;
    const widthAdditionalSize = 4;
    const widgets = 4;

    return MouseRegion(
      onEnter: (_) => toggleAnimController.forward(),
      onExit: (_) => toggleAnimController.reverse(),
      child: BarContainer(
        child: AnimatedBuilder(
          animation: toggleAnimController,
          builder: (context, child) {
            final progress =
                Curves.easeInOutExpo.transform(toggleAnimController.value);
            return Container(
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Opacity(
                    opacity: 1 - progress,
                    child: Container(
                      height: size,
                      width: (size + widthAdditionalSize) * (1 - progress),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: FittedBox(
                        child: Icon(
                          Icons.wifi,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: size,
                    width: (size + widthAdditionalSize) + 5 * (progress),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: FittedBox(
                      child: Icon(
                        Icons.volume_up,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: 1 - progress,
                    child: Container(
                      height: size,
                      width: (size + widthAdditionalSize) * (1 - progress),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: FittedBox(
                        child: Icon(
                          Icons.battery_4_bar,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: 1 - progress,
                    child: Container(
                      height: size,
                      width: (size + widthAdditionalSize) * (1 - progress),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: FittedBox(
                        child: Text('ENG'),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: progress,
                    child: SizedOverflowBox(
                      size: Size(
                          0 +
                              (widgets - 1) *
                                  progress *
                                  (size + widthAdditionalSize) -
                              progress * 5,
                          0),
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: size * (widgets - 1),
                        child: Slider(
                          value: 0.5,
                          onChanged: (value) {
                            print(value);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
