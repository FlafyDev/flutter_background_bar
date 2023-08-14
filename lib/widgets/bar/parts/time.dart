import 'package:flutter/material.dart';
import 'package:flutter_background_bar/providers/time.dart';
import 'package:flutter_background_bar/widgets/bar/bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class Time extends HookConsumerWidget {
  const Time({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final time = ref.watch(timeProvider);

    return BarContainer(
      child: Container(
        width: 150,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            time.whenData(
                  (time) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('HH:mm').format(time),
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontFamily: 'Arial',
                                    fontSize: 11,
                                  ),
                        ),
                        Text(
                          DateFormat('MMMM dd, yyyy').format(time),
                          style:
                              Theme.of(context).textTheme.labelSmall!.copyWith(
                                    fontFamily: "Arial",
                                    fontSize: 8, 
                                  ),
                        ),
                      ],
                    );
                  },
                ).valueOrNull ??
                Container(),
            const Icon(Icons.notifications_outlined, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
