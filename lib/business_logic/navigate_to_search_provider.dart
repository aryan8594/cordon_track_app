// navigation_providers.dart

import 'dart:async';
import 'dart:developer';

import 'package:cordon_track_app/business_logic/map_controller_provider.dart';
import 'package:cordon_track_app/business_logic/marker_provider.dart';
import 'package:cordon_track_app/business_logic/search_query_provider.dart';
import 'package:cordon_track_app/data/models/live_vehicle_model.dart';
import 'package:cordon_track_app/presentation/pages/live_map_page.dart';
import 'package:cordon_track_app/presentation/widgets/vehicle_info_sheet.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


void navigateToVehicle(WidgetRef ref, Data vehicle) async {
  // Completer<GoogleMapController> _controller = Completer();

  if (vehicle.latitude != null && vehicle.longitude != null) {
    final position = LatLng(double.parse(vehicle.latitude!), double.parse(vehicle.longitude!));


  final controller = await ref.read(mapControllerProvider.notifier).getController();
  await controller.animateCamera(CameraUpdate.newLatLngZoom(position, 16));



    // ref.watch(selectedVehicleIdProvider.notifier).state = vehicle.id;
    log("${vehicle.id} selected for search query");
    ref.read(markerProvider.notifier).onMarkerTap(ref as BuildContext, vehicle.id! );
    // ref.read(selectedVehicleIdProvider.notifier).state = vehicle.id;
    ref.read(searchQueryProvider.notifier).state = '';
    

  }
}
