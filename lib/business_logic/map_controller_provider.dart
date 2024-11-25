import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapControllerNotifier extends StateNotifier<GoogleMapController?> {
  MapControllerNotifier() : super(null);

  Future<void> initializeController(GoogleMapController controller) async {
    state = controller;
    log("Map controller initialized");
  }

  Future<void> animateCamera(LatLng position, double zoom) async {
    if (state != null) {
      await state!.animateCamera(CameraUpdate.newLatLngZoom(position, zoom));
    }
  }

  Future<ScreenCoordinate?> getScreenCoordinate(LatLng position) async {
    if (state != null) {
      return state!.getScreenCoordinate(position);
    }
    log("Map controller is not initialized");
    return null;
  }

  Future<void> showMarkerInfoWindow(MarkerId markerId) async {
    if (state != null) {
      await state!.showMarkerInfoWindow(markerId);
    }
  }

  void disposeController() {
    state = null; // Reset the controller on disposal
    log("Map controller disposed");
  }
}


final mapControllerProvider = StateNotifierProvider<MapControllerNotifier, GoogleMapController?>(
  (ref) => MapControllerNotifier(),
);
