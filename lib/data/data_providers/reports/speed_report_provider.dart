import 'dart:developer';
import 'package:cordon_track_app/data/models/reports/speed_report_model.dart';
import 'package:cordon_track_app/data/repositories/reports/speed_report_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Repository Provider
final speedReportRepositoryProvider = Provider<SpeedReportRepository>((ref) {
  return SpeedReportRepository();
});

/// State Notifier for managing API logic
class SpeedReportNotifier extends StateNotifier<AsyncValue<SpeedReportModel>> {
  final SpeedReportRepository repository;

  SpeedReportNotifier(this.repository) : super(const AsyncValue.loading());

  Future<void> fetchSpeedReport({
    required String id,
    required DateTime fromDate,
    required DateTime toDate,
    required String speed,
  }) async {
    try {
      state = const AsyncValue.loading();
      final result = await repository.fetchSpeedReport(
        id: id,
        fromDate: fromDate,
        toDate: toDate,
        speed: speed,
      );
      state = AsyncValue.data(result);
      log("Speed Report fetched successfully.");
    } catch (error, stackTrace) {
      log("Error fetching Speed Report: $error", stackTrace: stackTrace);
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Provider for the StateNotifier
final speedReportProvider =
    StateNotifierProvider<SpeedReportNotifier, AsyncValue<SpeedReportModel>>(
  (ref) {
    final repository = ref.read(speedReportRepositoryProvider);
    return SpeedReportNotifier(repository);
  },
);
