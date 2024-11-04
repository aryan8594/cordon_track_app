// pages/vehicle_history.dart

import 'package:cordon_track_app/business_logic/vehicle_search_provider.dart';
import 'package:cordon_track_app/data/data_providers/live_vehicle_provider.dart';
import 'package:cordon_track_app/presentation/widgets/tab_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class VehicleSearchList extends ConsumerWidget {
  const VehicleSearchList({Key? key}) : super(key: key);

  String convertSecondsToHoursMinutes(String secondsString) {
      // Convert the string to an integer
      int totalSeconds = int.tryParse(secondsString) ?? 0;

      // Create a Duration object
      Duration duration = Duration(seconds: totalSeconds);

      // Extract hours and minutes
      int hours = duration.inHours;
      int minutes = duration.inMinutes.remainder(60);

      // Return formatted string
      return '${hours}h ${minutes}m';
    }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the filtered list of vehicles
    final filteredVehicles = ref.watch(vehicleSearchProvider);
    // Watch the initial fetch of live vehicle data
    final vehicleData = ref.watch(liveVehicleProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Vehicle List",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) => ref
                  .read(vehicleSearchProvider.notifier)
                  .filterVehicles(query),
              decoration: InputDecoration(
                hintText: 'Search by RTO or ID',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
        ),
      ),
      body: vehicleData.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (_) {
          if (filteredVehicles.isEmpty) {
            return const Center(child: Text("No vehicles found"));
          }

          return ListView.builder(
            itemCount: filteredVehicles.length,
            itemBuilder: (context, index) {
              var vehicle = filteredVehicles[index];
              return  Card(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: ListTile(
                                    leading: 
                                    vehicle.vType == "car"
                                    ?const Icon(Icons.directions_car, color: Colors.blue)
                                    :vehicle.vType == "truck"
                                    ?const Icon(Icons.fire_truck, color: Colors.blue)
                                    :const Icon(Icons.directions_car, color: Colors.blue),
                                    title: Text(
                                      vehicle.rto ?? "Unknown Vehicle",
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("ID: ${vehicle.id ?? "Unknown"}"),
                                        vehicle.idleSince != "0"
                                        ?Text("Idle Since: ${convertSecondsToHoursMinutes(vehicle.idleSince!)}", style: TextStyle(color: Colors.yellow),)
                                        :vehicle.stoppageSince != "0"
                                        ?Text("Stoppage Since: ${convertSecondsToHoursMinutes(vehicle.stoppageSince!)}", style: TextStyle(color: Colors.red),)

                                        :Text("Moving: ${vehicle.speed} Kmph", style: TextStyle(color: Colors.green),),
                                        const SizedBox(height: 10,),
                      Container(
                        height: 2,
                        width: 300,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10,),
                                        Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text("Today Distance", style: TextStyle(fontSize: 12, color: Colors.grey),),
                                    Text("${vehicle.distanceToday} Kms", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)
                                  ],
                                ), 
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Ignition", style: TextStyle(fontSize: 12, color: Colors.grey),),
                                    vehicle.ignitionStatus == "0"
                                    ?Text("OFF", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red))
                                    :Text("ON",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.green)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text("Stoppage Since", style: TextStyle(fontSize: 12, color: Colors.grey),),
                                    Text("${convertSecondsToHoursMinutes(vehicle.stoppageSince!)} ", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)
                                  ],
                                  
                                ),
                                
                              ],
                            )
                                      ],
                                    ),
                                    onTap: () {
                                      // Action when a vehicle is tapped

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TabBarWidget(specificVehicleID: vehicle.id,),
                                        ));
                                    },
                                  ),
                                );
            },
          );
        },
      ),
    );
  }
}
