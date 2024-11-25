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
  _vehicleId = vehicleId; // Ensure the vehicle ID is stored
  log("Attempting to start playback timer.");

  _timer = Timer.periodic(const Duration(milliseconds: 250), (timer) {
    log("Timer is running for vehicleId: $vehicleId");

    final polylineNotifier = ref.read(polyLineProvider(vehicleId).notifier);
    final polylineState = ref.read(polyLineProvider(vehicleId));

    if (!polylineState.isPlaying) {
      log("Playback paused. Stopping timer.");
      stopPlayback();
      return;
    }

    int nextIndex = polylineState.currentIndex + 1;

    if (nextIndex >= polylineState.polylineCoordinates.length) {
      log("Reached the end of polyline coordinates. Stopping playback.");
      stopPlayback();
      // final polylineNotifier = ref.read(polyLineProvider(_vehicleId!).notifier);
      // Reset to the start
      polylineNotifier.setCurrentIndex(0);
      polylineNotifier.togglePlayPause(); 
      return;
    }

    log("Advancing to nextIndex: $nextIndex");
    polylineNotifier.setCurrentIndex(nextIndex);
  });

  if (_timer != null) {
    log("Playback timer successfully started.");
  }
}


  void stopPlayback() {
    log("PlaybackTimerNotifier is being cancelled.");
    _timer?.cancel();
    _timer = null;

    // Avoid accessing ref after disposal
    if (_vehicleId != null) {
      log("Resetting playback for vehicleId: $_vehicleId");
      final polylineNotifier = ref.read(polyLineProvider(_vehicleId!).notifier);
      // Reset to the start
      // polylineNotifier.setCurrentIndex(0); 
    }
  }

  // @override
  // void dispose() {
  //   log("PlaybackTimerNotifier is being disposed.");
  //   // Use the internal state directly to avoid ref
  //   _timer?.cancel();
  //   _timer = null;
  //   super.dispose();
  // }
}

final playbackTimerProvider = StateNotifierProvider.autoDispose<PlaybackTimerNotifier, void>((ref) {
  ref.keepAlive(); // Prevent disposal while the provider is still needed
  return PlaybackTimerNotifier(ref);
});

