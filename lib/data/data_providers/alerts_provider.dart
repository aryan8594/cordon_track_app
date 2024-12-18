
import 'package:cordon_track_app/data/models/alerts_model.dart';
import 'package:cordon_track_app/data/repositories/alerts_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final alertsProvider = FutureProvider<AlertsModel>((ref) async {
  final repository = AlertsRepository(ref);
  return repository.fetchAlerts();
});

class NewAlertsNotifier extends StateNotifier<AlertsModel?> {
  final Ref ref;
  NewAlertsNotifier(this.ref) : super(null);

  Future<void> checkForNewAlerts() async {
    try {
      // Fetch alerts
      final alerts = await AlertsRepository(ref).fetchAlerts();

      // Update the state with the latest alerts
      state = alerts;
    } catch (error) {
      state = null; // Handle errors gracefully
    }
  }

  bool hasNewAlerts() {
    // Check if there are any alerts
    return state?.data?.isNotEmpty ?? false;
  }

  void resetAlerts() {
    state = null; // Reset state
  }
}



// Riverpod provider for NewAlertsNotifier
final newAlertsProvider = StateNotifierProvider<NewAlertsNotifier, AlertsModel?>((ref) {
  ref.keepAlive(); // Prevent disposal until explicitly cleared
  return NewAlertsNotifier(ref);
});


