import 'dart:developer';
import 'package:cordon_track_app/data/models/reports/ignition_report_model.dart';
import 'package:cordon_track_app/data/repositories/reports/ignition_report_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Repository Provider
final ignitionReportRepositoryProvider = Provider<IgnitonReportRepository>((ref) {
  return IgnitonReportRepository(ref);
});

/// StateNotifier for managing API logic
class IgnitionReportNotifier extends StateNotifier<AsyncValue<IgnitionReportModel>> {
  final IgnitonReportRepository repository;

  IgnitionReportNotifier(this.repository) : super(const AsyncValue.loading());

  Future<void> fetchIgnitionReport({
    required String id,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    try {
      state = const AsyncValue.loading();
      final result = await repository.fetchIgnitionReport(
        id: id,
        fromDate: fromDate,
        toDate: toDate,
      );
      state = AsyncValue.data(result);
      log("Ignition report fetched successfully.");
    } catch (error, stackTrace) {
      log("Error fetching ignition report: $error", stackTrace: stackTrace);
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// StateNotifierProvider
final ignitionReportProvider =
    StateNotifierProvider<IgnitionReportNotifier, AsyncValue<IgnitionReportModel>>(
  (ref) {
    final repository = ref.read(ignitionReportRepositoryProvider);
    return IgnitionReportNotifier(repository);
  },
);
