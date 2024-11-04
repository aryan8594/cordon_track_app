import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapControllerNotifier extends StateNotifier<GoogleMapController?> {
  MapControllerNotifier() : super(null);

  Future<void> initializeController(GoogleMapController controller) async {
    state = controller;
  }

  Future<void> animateCamera(LatLng position, double zoom) async {
    if (state != null) {
      await state!.animateCamera(CameraUpdate.newLatLngZoom(position, zoom));
    }
  }

  void disposeController() {
    state = null; // Reset the controller on disposal
  }
}

final mapControllerProvider = StateNotifierProvider<MapControllerNotifier, GoogleMapController?>(
  (ref) => MapControllerNotifier(),
);
