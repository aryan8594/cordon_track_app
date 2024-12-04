import 'dart:developer';

import 'package:cordon_track_app/data/models/reports/geofence_report_model.dart';
import 'package:cordon_track_app/data/repositories/reports/geofence_report_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


/// Repository Provider
final geofenceReportRepositoryProvider = Provider<GeofenceReportRepository>((ref) {
  return GeofenceReportRepository(ref);
});

/// StateNotifier for managing API logic
class GeofenceReportNotifier extends StateNotifier<AsyncValue<GeofenceReportModel>> {
  final GeofenceReportRepository repository;

  GeofenceReportNotifier(this.repository) : super(const AsyncValue.loading());

  Future<void> fetchGeofenceReport({
    required String id,
    required String reportType,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    try {
      state = const AsyncValue.loading();
      final result = await repository.fetchGeofenceReport(
        id: id,
        reportType: reportType,
        fromDate: fromDate,
        toDate: toDate,
      );
      state = AsyncValue.data(result);
      log("Geofence report fetched successfully.");
    } catch (error, stackTrace) {
      log("Error fetching geofence report: $error", stackTrace: stackTrace);
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// StateNotifierProvider
final geofenceReportProvider =
    StateNotifierProvider<GeofenceReportNotifier, AsyncValue<GeofenceReportModel>>(
  (ref) {
    final repository = ref.read(geofenceReportRepositoryProvider);
    return GeofenceReportNotifier(repository);
  },
);

