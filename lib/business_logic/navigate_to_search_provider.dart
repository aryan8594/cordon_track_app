// navigation_providers.dart

// ignore_for_file: implementation_imports

import 'dart:developer';

import 'package:cordon_track_app/business_logic/map_controller_provider.dart';
import 'package:cordon_track_app/business_logic/marker_provider.dart';
import 'package:cordon_track_app/business_logic/search_query_provider.dart';
import 'package:cordon_track_app/data/models/live_vehicle_model.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


void navigateToVehicle(WidgetRef ref, Data vehicle, BuildContext context) async {
  // Completer<GoogleMapController> _controller = Completer();

  if (vehicle.latitude != null && vehicle.longitude != null ) {
    final position = LatLng(double.parse(vehicle.latitude!), double.parse(vehicle.longitude!));


        final controller = ref.read(mapControllerProvider);
        if (controller != null ) {
        await controller.animateCamera(CameraUpdate.newLatLngZoom(position, 16));
      }



    // ref.watch(selectedVehicleIdProvider.notifier).state = vehicle.id;
    log("${vehicle.id} selected for search query");
    ref.read(markerProvider.notifier).onMarkerTap(ref as BuildContext, vehicle.id! );
    // ref.read(selectedVehicleIdProvider.notifier).state = vehicle.id;
    ref.read(searchQueryProvider.notifier).state = '';
    

  }
}
