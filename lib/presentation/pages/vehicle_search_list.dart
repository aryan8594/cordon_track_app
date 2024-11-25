// pages/vehicle_history.dart

import 'dart:async';

import 'package:cordon_track_app/business_logic/vehicle_search_provider.dart';
import 'package:cordon_track_app/data/data_providers/live_vehicle_provider.dart';
import 'package:cordon_track_app/presentation/widgets/tab_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VehicleSearchList extends ConsumerStatefulWidget {
  const VehicleSearchList({super.key});

  @override
  ConsumerState<VehicleSearchList> createState() => _VehicleSearchListState();
}

class _VehicleSearchListState extends ConsumerState<VehicleSearchList> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Auto-refresh the vehicle data every 10 seconds
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    if (mounted) {
  _timer = Timer.periodic(const Duration(seconds: 10), (_) {
    ref.invalidate(liveVehicleProvider);
  });
}
  }

  Future<void> _pullToRefresh() async {
    ref.invalidate(liveVehicleProvider);
    // Wait for data to refresh
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the filtered list of vehicles
    final filteredVehicles = ref.watch(vehicleSearchProvider);
    // Watch the live vehicle data
    final vehicleData = ref.watch(liveVehicleProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading:Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(width: 10,),
            Image.asset("lib/presentation/assets/cordon_logo_2.png", height: 25,scale: 10,),
          ],
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.notifications, size: 25,)),
          SizedBox(width: 10,)
        ],
        leadingWidth: 120,
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
        data: (vehicles) {
          if (vehicles == null || vehicles.isEmpty) {
            return const Center(child: Text("No vehicles found"));
          }

          if (filteredVehicles.isEmpty) {
            return const Center(child: Text("No vehicles match your search"));
          }

          // Use RefreshIndicator for pull-to-refresh
          return RefreshIndicator(
            onRefresh: _pullToRefresh,
            child: ListView.builder(
              itemCount: filteredVehicles.length,
              itemBuilder: (context, index) {
                // Sort the list alphabetically by RTO before building the list
                filteredVehicles
                    .sort((a, b) => (a.id ?? '').compareTo(b.id ?? ''));

                var vehicle = filteredVehicles[index];
                return Card(
                  color: Colors.white,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: ListTile(
                    leading: vehicle.vType == "car"
                        ? const Icon(Icons.directions_car, color: Colors.blue)
                        : vehicle.vType == "truck"
                            ? const Icon(Icons.fire_truck, color: Colors.blue)
                            : const Icon(Icons.directions_car,
                                color: Colors.blue),
                    title: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            vehicle.rto ?? "Unknown Vehicle",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("ID: ${vehicle.id ?? "Unknown"}"),
                            vehicle.externalBatteryVoltage == null
                                ? SizedBox()
                                : Row(
                                    children: [
                                      Icon(
                                        Icons.battery_charging_full_rounded,
                                        size: 18,
                                      ),
                                      Text(
                                        "${vehicle.externalBatteryVoltage} v",
                                        style: TextStyle(fontSize: 15),
                                      )
                                    ],
                                  )
                          ],
                        ),
                        vehicle.idleSince != "0" || vehicle.idleSince == null
                            ? Text(
                                "Idle Since: ${convertSecondsToHoursMinutes(vehicle.idleSince!)}",
                                style: TextStyle(color: Colors.yellow),
                              )
                            : vehicle.stoppageSince != "0" || vehicle.stoppageSince == null
                                ? Text(
                                    "Stoppage Since: ${convertSecondsToHoursMinutes(vehicle.stoppageSince!)}",
                                    style: TextStyle(color: Colors.red),
                                  )
                                : Text(
                                    "Moving: ${vehicle.speed} Kmph",
                                    style: TextStyle(color: Colors.green),
                                  ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 2,
                          width: 300,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Today Distance",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  "${vehicle.distanceToday} Kms",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Ignition",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                vehicle.ignitionStatus == "0"
                                    ? Text("OFF",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.red))
                                    : Text("ON",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.green)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Stoppage Since",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  "${convertSecondsToHoursMinutes(vehicle.stoppageSince!)} ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                )
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
                            builder: (context) => TabBarWidget(
                              specificVehicleID: vehicle.id,
                            ),
                          ));
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

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
}
