import 'dart:async';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'poly_line_provider.dart';

class PlaybackTimerNotifier extends StateNotifier<void> {
  final Ref ref;
  Timer? _timer;
  String? _vehicleId;

  PlaybackTimerNotifier(this.ref) : super(null);

  void startPlayback(String vehicleId) {
    _vehicleId = vehicleId; // Save vehicleId internally
    final polylineNotifier = ref.read(polyLineProvider(vehicleId).notifier);

    if (ref.watch(polyLineProvider(vehicleId)).polylineCoordinates.isEmpty) {
      log("No coordinates to play. Playback stopped.");
      stopPlayback();
      return;
    }

    log("Starting playback with ${ref.watch(polyLineProvider(vehicleId)).polylineCoordinates.length} coordinates.");

    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      final polylineState = ref.watch(polyLineProvider(vehicleId));

      log("Timer tick: currentIndex = ${polylineState.currentIndex}");

      if (!polylineState.isPlaying) {
        log("Playback is paused. Stopping timer.");
        stopPlayback();
        return;
      }

      int nextIndex = polylineState.currentIndex + 1;

      log("Calculated nextIndex: $nextIndex");

      if (nextIndex >= polylineState.polylineCoordinates.length) {
        log("Reached the end of polyline coordinates. Stopping playback.");
        stopPlayback();
        return;
      }

      log("Calling setCurrentIndex with nextIndex: $nextIndex");
      polylineNotifier.setCurrentIndex(nextIndex);
    });
  }

  void stopPlayback() {
    _timer?.cancel();
    _timer = null;

    // Avoid accessing ref after disposal
    if (_vehicleId != null) {
      log("Resetting playback for vehicleId: $_vehicleId");
      final polylineNotifier = ref.read(polyLineProvider(_vehicleId!).notifier);
      polylineNotifier.setCurrentIndex(0); // Reset to the start
    }
  }

  @override
  void dispose() {
    // Use the internal state directly to avoid ref
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}



final playbackTimerProvider =
    StateNotifierProvider.autoDispose<PlaybackTimerNotifier, void>((ref) {
  return PlaybackTimerNotifier(ref);
});
