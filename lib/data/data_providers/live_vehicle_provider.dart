import 'package:cordon_track_app/data/repositories/live_vehicle_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cordon_track_app/data/models/live_vehicle_model.dart';

// Fetch vehicle data from API using the repository
final liveVehicleProvider = FutureProvider<List<Data>?>((ref) async {
  return await LiveVehicleRepository().fetchLiveVehicleData();
});
