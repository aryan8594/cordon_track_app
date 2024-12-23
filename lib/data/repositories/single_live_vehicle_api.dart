// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:developer';
import 'package:cordon_track_app/data/data_providers/login_provider.dart';
import 'package:cordon_track_app/data/models/single_live_vehicle_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class SingleLiveVehicleRepository  {
  // final String apiUrl = 'https://cordontrack.com/api/v1/vehicle/live_vehicles_new?filter=&ids=${slectedVehicleID}';
  // final String token = '8fce96fe1288a2c2b5affeba94201267';
      final Ref ref;
      SingleLiveVehicleRepository(this.ref);
  Future<SingleLiveVehicleModel?> fetchLiveVehicleData(String selectedVehicleID) async {
    String token = ref.watch(tokenProvider.notifier).state;
    final response = await http.get(
      Uri.parse('https://cordontrack.com/api/v1/vehicle/live_vehicles_new?filter=&ids=$selectedVehicleID'),
      headers: {
        'Token': token,
      },
    );

    if (response.statusCode == 200) {
      log("Live Single Vehicle Data fetched ${selectedVehicleID}");
      final jsonData = jsonDecode(response.body);
      return SingleLiveVehicleModel.fromJson(jsonData);
    } else {
      log('Failed to load vehicle data');
      return null;
    }
  }
}
