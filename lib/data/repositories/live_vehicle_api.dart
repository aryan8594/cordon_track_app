import 'dart:convert';
import 'dart:developer';
import 'package:cordon_track_app/data/data_providers/login_provider.dart';
import 'package:cordon_track_app/data/models/live_vehicle_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;


class LiveVehicleRepository  {
  final String apiUrl = 'https://cordontrack.com/api/v1/vehicle/live_vehicles_new?filter=&ids=';
      final Ref ref;


  LiveVehicleRepository(this.ref);
  

  Future<List<Data>?> fetchLiveVehicleData() async {

    String token = ref.watch(tokenProvider.notifier).state;
    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Token': token,
    });

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      log("Live Vehile API Data fetched");
      LiveVehicleModel liveVehicle = LiveVehicleModel.fromJson(json);
      return liveVehicle.data;
      
    } else {
      log('Failed to load vehicles');
      return null;
    }
  }
}
