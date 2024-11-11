import 'package:cordon_track_app/data/repositories/vehicle_history_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final historyVehicleRepositoryProvider = Provider<HistoryVehicleRepository>((ref) {
  return HistoryVehicleRepository();
});