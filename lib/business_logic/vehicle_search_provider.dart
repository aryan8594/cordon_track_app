// providers/vehicle_providers.dart

// Notifier for managing and filtering vehicle data based on search query
import 'package:cordon_track_app/data/models/live_vehicle_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/data_providers/live_vehicle_provider.dart';

class VehicleSearchNotifier extends StateNotifier<List<Data>> {
  final Ref ref;
  List<Data> _allVehicles = [];
  String _currentQuery = ''; // To store the current search query
  String? _currentDropdownFilter; // To store the current dropdown filter

  VehicleSearchNotifier(this.ref) : super([]) {
    _init();

    // Listen for changes in liveVehicleProvider and update the state
    ref.listen<AsyncValue<List<Data>?>>(liveVehicleProvider, (previous, next) {
      if (next.hasValue && next.value != null) {
        _allVehicles = next.value!;
        _reapplyFilters(); // Reapply query and filter after refresh
      }
    });
  }

  // Getters to expose current query and filter
  String get currentQuery => _currentQuery;
  String? get currentDropdownFilter => _currentDropdownFilter;

  Future<void> _init() async {
    final liveVehicle = await ref.read(liveVehicleProvider.future);
    if (liveVehicle != null) {
      _allVehicles = liveVehicle;
      _reapplyFilters();
    }
  }

  void filterVehicles(String query) {
    _currentQuery = query;
    _reapplyFilters();
  }

  void applyDropdownFilter(String? filter) {
    _currentDropdownFilter = filter;
    _reapplyFilters();
  }

  void _reapplyFilters() {
    List<Data> filteredList = _allVehicles;

    if (_currentQuery.isNotEmpty) {
      filteredList = filteredList.where((vehicle) {
        return (vehicle.rto?.toLowerCase().contains(_currentQuery.toLowerCase()) ?? false);
        // ||(vehicle.id?.toString().contains(_currentQuery) ?? false);
      }).toList();
    }

    if (_currentDropdownFilter != null) {
      filteredList = filteredList.where((vehicle) {
        double? speed = vehicle.speed != null ? double.tryParse(vehicle.speed!) : null;
        double? stoppageTime = vehicle.stoppageSince != null
            ? double.tryParse(vehicle.stoppageSince!)
            : null;
        double? idleSince = vehicle.idleSince != null
            ? double.tryParse(vehicle.idleSince!)
            : null;

        switch (_currentDropdownFilter) {
          case 'all':
            return true;
          case 'speed>0':
            return speed != null && speed > 0;
          case 'speed>80':
            return speed != null && speed > 80;
          case 'idleSince>10800':
            return idleSince != null && idleSince > 10800;
          case 'stoppageTime>10800':
            return stoppageTime != null && stoppageTime > 10800;
          case 'panic':
            return vehicle.panicStatus != null && vehicle.panicStatus == '1';
          case 'noGPS':
            return vehicle.gpsStatus != null && vehicle.gpsStatus == '0';
          default:
            return true;
        }
      }).toList();
    }

    state = filteredList;
  }
}

// Provider for the VehicleSearchNotifier
final vehicleSearchProvider =
    StateNotifierProvider<VehicleSearchNotifier, List<Data>>((ref) {
  return VehicleSearchNotifier(ref);
});
