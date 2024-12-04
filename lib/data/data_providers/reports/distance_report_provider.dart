import 'dart:developer';

import 'package:cordon_track_app/data/repositories/reports/distance_report_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cordon_track_app/data/models/reports/distance_report_model.dart';

/// Repository Provider
final distanceReportRepositoryProvider = Provider<DistanceReportRepository>((ref) {
  return DistanceReportRepository(ref);
});

/// State Notifier for managing API logic
class DistanceReportNotifier extends StateNotifier<AsyncValue<DistanceReportModel>> {
  final DistanceReportRepository repository;

  DistanceReportNotifier(this.repository) : super(const AsyncValue.loading());

  Future<void> fetchDistanceReport({
    required String id,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    try {
      state = const AsyncValue.loading(); // Set loading state
      final result = await repository.fetchDistanceReport(
        id: id,
        fromDate: fromDate,
        toDate: toDate,
      );
      state = AsyncValue.data(result); // Update state with data
      log("Distance Report fetched successfully.");
    } catch (error, stackTrace) {
      log("Error fetching Distance Report: $error", stackTrace: stackTrace);
      state = AsyncValue.error(error, stackTrace); // Update state with error
    }
  }
}

/// Provider for the StateNotifier
final distanceReportProvider =
    StateNotifierProvider<DistanceReportNotifier, AsyncValue<DistanceReportModel>>(
  (ref) {
    final repository = ref.read(distanceReportRepositoryProvider);
    return DistanceReportNotifier(repository);
  },
);


