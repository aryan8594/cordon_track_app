// polyline_state.dart
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolylineStateModel {
  final Set<Polyline> polylines;
  final Set<Marker> markers;
  final Marker? playbackMarker;
  final List<LatLng> polylineCoordinates;
  final int currentIndex;
  final bool isPlaying;

  const PolylineStateModel({
    this.polylines = const {},
    this.markers = const {},
    this.playbackMarker,
    this.polylineCoordinates = const [],
    this.currentIndex = 0,
    this.isPlaying = false,
  });

  // Method to copy the current state with new values
  PolylineStateModel copyWith({
    Set<Polyline>? polylines,
    Set<Marker>? markers,
    Marker? playbackMarker,
    List<LatLng>? polylineCoordinates,
    int? currentIndex,
    bool? isPlaying,
  }) {
    return PolylineStateModel(
      polylines: polylines ?? this.polylines,
      markers: markers ?? this.markers,
      playbackMarker: playbackMarker ?? this.playbackMarker,
      polylineCoordinates: polylineCoordinates ?? this.polylineCoordinates,
      currentIndex: currentIndex ?? this.currentIndex,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}
