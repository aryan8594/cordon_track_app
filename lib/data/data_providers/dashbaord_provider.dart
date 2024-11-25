import 'dart:developer';

import 'package:cordon_track_app/data/models/dashboard_model.dart';
import 'package:cordon_track_app/data/repositories/dashboard_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Repository Provider
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository();
});

/// State Notifier for managing dashboard data
class DashboardNotifier extends StateNotifier<AsyncValue<DashboardModel>> {
  final DashboardRepository repository;

  DashboardNotifier(this.repository) : super(const AsyncValue.loading());

  Future<void> fetchDashboardData() async {
    try {
      state = const AsyncValue.loading();
      final result = await repository.fetchDashboardData();
      if (result != null) {
        state = AsyncValue.data(result);
        log("Dashboard data fetched successfully.");
      } else {
        state = AsyncValue.error("Failed to fetch dashboard data.", StackTrace.current);

      }
    } catch (error, stackTrace) {
      log("Error fetching dashboard data: $error", stackTrace: stackTrace);
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Provider for the StateNotifier
final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, AsyncValue<DashboardModel>>((ref) {
  final repository = ref.read(dashboardRepositoryProvider);
  final notifier = DashboardNotifier(repository);
  notifier.fetchDashboardData(); // Fetch data when initialized
  return notifier;
});
