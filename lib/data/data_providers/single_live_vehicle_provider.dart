
import 'dart:async';

import 'package:cordon_track_app/data/models/single_live_vehicle_model.dart';
import 'package:cordon_track_app/data/repositories/single_live_vehicle_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// Fetch vehicle data from API using the repository every 10 seconds
final singleLiveVehicleProvider = StreamProvider.family<SingleLiveVehicleModel?, String>((ref, selectedVehicleID) {
  final repository = SingleLiveVehicleRepository();
  final controller = StreamController<SingleLiveVehicleModel?>();

  // Make an immediate call
  repository.fetchLiveVehicleData(selectedVehicleID).then(controller.add);

  // Periodic updates every 5 seconds
  Stream.periodic(const Duration(seconds: 5), (_) async {
    return await repository.fetchLiveVehicleData(selectedVehicleID);
  }).asyncMap((event) => event).listen(controller.add);

  // Close the stream when no longer in use
  ref.onDispose(() => controller.close());

  return controller.stream;
});
