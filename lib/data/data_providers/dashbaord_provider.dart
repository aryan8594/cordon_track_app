import 'dart:developer';

import 'package:cordon_track_app/data/models/dashboard_model.dart';
import 'package:cordon_track_app/data/repositories/dashboard_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Repository Provider
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(ref);
});

/// State Notifier for managing dashboard data
/// State Notifier for managing dashboard data with caching
class DashboardNotifier extends StateNotifier<AsyncValue<DashboardModel>> {
  final DashboardRepository repository;

  // Cache the dashboard data
  DashboardModel? _cachedData;

  DashboardNotifier(this.repository) : super(const AsyncValue.loading());

  Future<void> fetchDashboardData() async {
    try {
      // If cached data exists, show it immediately
      if (_cachedData != null) {
        state = AsyncValue.data(_cachedData!);
      } else {
        state = const AsyncValue.loading();
      }

      // Fetch fresh data from the API
      final result = await repository.fetchDashboardData();
      if (result != null) {
        _cachedData = result; // Update the cache
        state = AsyncValue.data(result); // Update state
        log("Dashboard data fetched successfully.");
      } else {
        state = AsyncValue.error(
          "Failed to fetch dashboard data.",
          StackTrace.current,
        );
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
  ref.keepAlive(); // Prevent disposal until explicitly cleared
  return notifier;
});
