import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Manages GoogleMapController and lifecycle handling
class MapControllerNotifier extends StateNotifier<GoogleMapController?> {
  Completer<GoogleMapController> _completer = Completer<GoogleMapController>();

  MapControllerNotifier() : super(null);

  /// Completes the controller when created
  void setController(GoogleMapController controller) {
    if (!_completer.isCompleted) {
      _completer.complete(controller);
      state = controller;
    }
  }

  /// Retrieve the controller asynchronously
  Future<GoogleMapController> getController() async {
    return _completer.future;
  }

  /// Dispose of the controller and reset state
  void disposeController() {
    if (state != null) {
      state!.dispose();
      _completer = Completer<GoogleMapController>();
      state = null;
    }
  }
}

final mapControllerProvider = StateNotifierProvider<MapControllerNotifier, GoogleMapController?>(
  (ref) => MapControllerNotifier(),
);
