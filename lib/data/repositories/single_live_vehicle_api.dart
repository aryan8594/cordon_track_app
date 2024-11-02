import 'dart:convert';
import 'dart:developer';
import 'package:cordon_track_app/data/models/single_live_vehicle_model.dart';
import 'package:http/http.dart' as http;

class SingleLiveVehicleRepository  {
  // final String apiUrl = 'https://cordontrack.com/api/v1/vehicle/live_vehicles_new?filter=&ids=${slectedVehicleID}';
  final String token = '8fce96fe1288a2c2b5affeba94201267';

  Future<SingleLiveVehicleModel?> fetchLiveVehicleData(String selectedVehicleID) async {
    final response = await http.get(
      Uri.parse('https://cordontrack.com/api/v1/vehicle/live_vehicles_new?filter=&ids=$selectedVehicleID'),
      headers: {
        'Token': token,
      },
    );

    if (response.statusCode == 200) {
      log("Live Single Vehicle Data fetched");
      final jsonData = jsonDecode(response.body);
      return SingleLiveVehicleModel.fromJson(jsonData);
    } else {
      log('Failed to load vehicle data');
      return null;
    }
  }
}
