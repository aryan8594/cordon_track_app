import 'dart:async';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'poly_line_provider.dart';

/// State class to manage playback state
class PlaybackTimerState {
  final bool isPlaying; // Indicates if playback is active
  final int speedMultiplier; // Playback speed multiplier (e.g., 1x, 2x, etc.)

  PlaybackTimerState({
    this.isPlaying = false,
    this.speedMultiplier = 1,
  });

  /// Creates a copy with updated fields
  PlaybackTimerState copyWith({
    bool? isPlaying,
    int? speedMultiplier,
  }) {
    return PlaybackTimerState(
      isPlaying: isPlaying ?? this.isPlaying,
      speedMultiplier: speedMultiplier ?? this.speedMultiplier,
    );
  }
}

/// StateNotifier to handle playback logic
class PlaybackTimerNotifier extends StateNotifier<PlaybackTimerState> {
  final Ref ref;
  Timer? _timer; // Timer for playback
  String? _vehicleId; // Current vehicle ID

  PlaybackTimerNotifier(this.ref) : super(PlaybackTimerState());

  /// Starts playback for a specific vehicle
  void startPlayback(String vehicleId) {
    _vehicleId = vehicleId;
    log("Starting playback for vehicleId: $vehicleId with speedMultiplier: ${state.speedMultiplier}x");

    // Clear any existing timer
    stopPlayback();

    _timer = Timer.periodic(
      Duration(
          milliseconds:
              (500 ~/ state.speedMultiplier)), // Adjust playback speed
      (timer) {
        final polylineNotifier = ref.read(polyLineProvider(vehicleId).notifier);
        final polylineState = ref.read(polyLineProvider(vehicleId));

        if (!polylineState.isPlaying) {
          log("Playback paused. Stopping timer.");
          stopPlayback();
          return;
        }

        int nextIndex = polylineState.currentIndex + 1;

        if (nextIndex >= polylineState.polylineCoordinates.length) {
          log("Reached the end of polyline coordinates. Resetting playback.");
          stopPlayback();
          polylineNotifier.setCurrentIndex(0); // Reset to the start
          polylineNotifier.pausePlayback();
          return;
        }

        log("Advancing to nextIndex: $nextIndex");
        polylineNotifier.setCurrentIndex(nextIndex);
      },
    );

    state = state.copyWith(isPlaying: true);
  }

  /// Stops playback
  void stopPlayback() {
    log("Stopping playback for vehicleId: $_vehicleId");
    _timer?.cancel();
    _timer = null;

    if (_vehicleId != null) {
      final polylineNotifier = ref.read(polyLineProvider(_vehicleId!).notifier);
      // polylineNotifier.setCurrentIndex(0); // Reset to the start
    }

    if (mounted) {
  state = state.copyWith(isPlaying: false);
}
  }

  /// Updates the playback speed multiplier
  void setSpeedMultiplier(int multiplier) {
    log("Setting speed multiplier to $multiplier");
    state = state.copyWith(speedMultiplier: multiplier);

    if (state.isPlaying) {
      // Restart the timer with the new speed
      startPlayback(_vehicleId!);
    }
  }

  /// Gets the current speed multiplier
  int get speedMultiplier => state.speedMultiplier;
}

final playbackTimerProvider =
    StateNotifierProvider.autoDispose<PlaybackTimerNotifier, PlaybackTimerState>(
  (ref) => PlaybackTimerNotifier(ref),
);
