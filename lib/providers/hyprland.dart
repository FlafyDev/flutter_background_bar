import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hyprland_ipc/hyprland_ipc.dart';

final hyprlandProvider =
    FutureProvider((ref) async => HyprlandIPC.fromInstance());

final hyprlandEventsProvider = StreamProvider<Event>((ref) {
  final hyprland = ref.watch(hyprlandProvider);
  return hyprland.value?.eventsStream ?? const Stream.empty();
});
