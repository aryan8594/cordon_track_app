import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'poly_line_provider.dart';

class PlaybackTimerNotifier extends StateNotifier<void> {
  final Ref ref;
  Timer? _timer;

  PlaybackTimerNotifier(this.ref) : super(null);

  void startPlayback(String vehicleId) {
    final polylineNotifier = ref.read(polyLineProvider(vehicleId).notifier);
    if (polylineNotifier.polylineCoordinates.isEmpty) return;

    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      final state = polylineNotifier.state;
      if (!state['isPlaying']) {
        stopPlayback();
        return;
      }

      int nextIndex = state['currentIndex'] + 1;
      if (nextIndex >= polylineNotifier.polylineCoordinates.length) {
        stopPlayback();
        return;
      }

      polylineNotifier.setCurrentIndex(nextIndex);
    });
  }

  void stopPlayback() {
    _timer?.cancel();
    _timer = null;
  }
}

final playbackTimerProvider = StateNotifierProvider.autoDispose<PlaybackTimerNotifier, void>((ref) {
  return PlaybackTimerNotifier(ref);
});
