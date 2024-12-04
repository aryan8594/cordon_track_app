// pages/vehicle_history.dart
import 'package:intl/intl.dart';
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
  String? selectedFilter;

  @override
  void initState() {
    super.initState();
    // Auto-refresh the vehicle data every 10 seconds
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    if (mounted) {
      _timer = Timer.periodic(const Duration(seconds: 10), (_) {
        final query = ref.read(vehicleSearchProvider.notifier).currentQuery;
        ref.invalidate(liveVehicleProvider);
        Future.delayed(const Duration(milliseconds: 500), () {
          ref.read(vehicleSearchProvider.notifier).filterVehicles(query);
        });
      });
    }
  }

  Future<void> _pullToRefresh() async {
    final query = ref.read(vehicleSearchProvider.notifier).currentQuery;
    ref.invalidate(liveVehicleProvider);
    await Future.delayed(const Duration(seconds: 1));
    ref.read(vehicleSearchProvider.notifier).filterVehicles(query);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredVehicles = ref.watch(vehicleSearchProvider);
    final vehicleData = ref.watch(liveVehicleProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: double.maxFinite,
        leading: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    onChanged: (query) => ref
                        .read(vehicleSearchProvider.notifier)
                        .filterVehicles(query),
                    decoration: InputDecoration(
                      hintText: 'Search by RTO',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              DropdownButton<String>(
                value: selectedFilter,
                hint: const Text("Filter"),
                items: const [
                  DropdownMenuItem(value: 'all', child: Text("All Vehicles")),
                  DropdownMenuItem(value: 'speed>0', child: Text("Speed > 0 km/h")),
                  DropdownMenuItem(value: 'speed>80', child: Text("Speed > 80 km/h")),
                  DropdownMenuItem(
                      value: 'idleSince>10800', child: Text("Idle > 3 hrs")),
                  DropdownMenuItem(
                      value: 'stoppageTime>10800',
                      child: Text("Stoppage > 3 hrs")),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedFilter = value;
                  });
                  ref
                      .read(vehicleSearchProvider.notifier)
                      .applyDropdownFilter(value);
                },
              ),
            ],
          ),
        ),
      ),
      body: vehicleData.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text("Error: $e\n\nNO INTERNET CONNECTION")),
        data: (vehicles) {
          if (vehicles == null || vehicles.isEmpty) {
            return const Center(child: Text("No vehicles found"));
          }

          if (filteredVehicles.isEmpty) {
            return const Center(child: Text("No vehicles match your search"));
          }

          return RefreshIndicator(
            onRefresh: _pullToRefresh,
            child: ListView.builder(
              itemCount: filteredVehicles.length,
              itemBuilder: (context, index) {
                filteredVehicles
                    .sort((a, b) => (a.rto ?? '').compareTo(b.rto ?? ''));

                var vehicle = filteredVehicles[index];
                double? gsmSingnalStrength = vehicle.gsmSingnalStrength != null
                    ? double.tryParse(vehicle.gsmSingnalStrength!)
                    : null;
                double? externalBatteryVoltage = vehicle.externalBatteryVoltage != null
                    ? double.tryParse(vehicle.externalBatteryVoltage!)
                    : null;
                double? speed = vehicle.speed != null
                    ? double.tryParse(vehicle.speed!)
                    : null;
                double? stoppageTime = vehicle.stoppageSince != null
                    ? double.tryParse(vehicle.stoppageSince!)
                    : null;
                double? ideleSince = vehicle.idleSince != null
                    ? double.tryParse(vehicle.idleSince!)
                    : null; 
                return Card(
                  color: vehicle.panicStatus == "0"
                      ? Colors.white
                      : const Color.fromARGB(255, 255, 188, 188),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        vehicle.vType == "car"
                            ? const Icon(Icons.directions_car,
                                color: Colors.blue)
                            : vehicle.vType == "truck"
                                ? const Icon(Icons.fire_truck,
                                    color: Colors.blue)
                                : const Icon(Icons.directions_car,
                                    color: Colors.blue),
                        vehicle.panicStatus == "0"
                            ? SizedBox()
                            : Icon(
                                Icons.report_problem_rounded,
                                color: Colors.redAccent,
                                size: 25,
                              )
                      ],
                    ),
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: FittedBox(
                            alignment: Alignment.centerLeft,
                            fit: BoxFit.scaleDown,
                            child: Text(
                              vehicle.rto ?? "Unknown Vehicle",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        vehicle.gsmSingnalStrength == null
                            ? const SizedBox()
                            : Row(
                                children: [
                                  // Text(
                                  //   "${vehicle.gsmSingnalStrength} ",
                                  //   style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                  // ),
                                  Icon(
                                    gsmSingnalStrength! > 18
                                        ? Icons.signal_cellular_alt_rounded
                                        : gsmSingnalStrength! > 8
                                            ? Icons
                                                .signal_cellular_alt_2_bar_rounded
                                            : Icons
                                                .signal_cellular_alt_1_bar_rounded,
                                    size: 25,
                                    color: gsmSingnalStrength! > 18
                                        ? Colors.green
                                        : gsmSingnalStrength! > 8
                                            ? Colors.yellow
                                            : Colors.red,
                                  ),
                                ],
                              ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("ID: ${vehicle.id ?? "Unknown"}"),
                            vehicle.externalBatteryVoltage == null
                                ? const SizedBox()
                                : Row(
                                    children: [
                                      const Icon(
                                        Icons.battery_charging_full_rounded,
                                        size: 18,
                                      ),
                                      Text(
                                        "${vehicle.externalBatteryVoltage} v",
                                        style: const TextStyle(fontSize: 15),
                                      )
                                    ],
                                  )
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              fit: FlexFit.tight,
                              child: Text(
                                overflow: TextOverflow.clip,
                                maxLines: 5,
                                "Data Received : ${timePassedSince(vehicle.datetime ?? '0')} ago",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            vehicle.idleSince != "0" ||
                                    vehicle.idleSince == null
                                ? Text(
                                    "Idle Since: ${convertSecondsToHoursMinutes(vehicle.idleSince.toString())}",
                                    style:
                                        const TextStyle(color: Colors.yellow),
                                  )
                                : vehicle.stoppageSince != "0" ||
                                        vehicle.stoppageSince == null
                                    ? Text(
                                        "Stoppage Since: ${convertSecondsToHoursMinutes(vehicle.stoppageSince.toString())}",
                                        style:
                                            const TextStyle(color: Colors.red),
                                      )
                                    : Text(
                                        "Moving: ${vehicle.speed} Kmph",
                                        style: const TextStyle(
                                            color: Colors.green),
                                      ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 2,
                          width: 300,
                          color: Colors.grey,
                        ),
                        const SizedBox(
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
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Ignition",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                vehicle.ignitionStatus == "0"
                                    ? const Text("OFF",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.red))
                                    : const Text("ON",
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
                                  "${convertSecondsToHoursMinutes(vehicle.stoppageSince.toString())} ",
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
                              specificVehicleID: vehicle.id.toString(),
                              vehicleRTO: vehicle.rto.toString(),
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

  String timePassedSince(String dateString) {
    try {
      // Define the custom date format
      DateFormat format = DateFormat("dd-MM-yyyy HH:mm:ss");
      // Parse the input string to DateTime
      DateTime date = format.parse(dateString);

      // Get the current time
      DateTime now = DateTime.now();

      // Calculate the difference
      Duration difference = now.difference(date);

      // Extract hours and minutes from the difference
      int hours = difference.inHours;
      int minutes = difference.inMinutes % 60;

      // Build the result string
      String result = '';
      if (hours > 0) result += '$hours Hour${hours > 1 ? 's' : ''} ';
      if (minutes > 0) result += '$minutes Minute${minutes > 1 ? 's' : ''}';

      return result.isEmpty ? 'Just Now' : result.trim();
    } catch (e) {
      return 'Invalid date format';
    }
  }
}


// Card(
//                   color: vehicle.panicStatus == "0"
//                       ? Colors.white
//                       : const Color.fromARGB(255, 255, 188, 188),
//                   margin:
//                       const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//                   child: ListTile(
//                     leading: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         vehicle.vType == "car"
//                             ? const Icon(Icons.directions_car,
//                                 color: Colors.blue)
//                             : vehicle.vType == "truck"
//                                 ? const Icon(Icons.fire_truck,
//                                     color: Colors.blue)
//                                 : const Icon(Icons.directions_car,
//                                     color: Colors.blue),
//                         vehicle.panicStatus == "0"
//                             ? SizedBox()
//                             : Icon(
//                                 Icons.report_problem_rounded,
//                                 color: Colors.redAccent,
//                                 size: 25,
//                               )
//                       ],
//                     ),
//                     title: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Flexible(
//                           child: FittedBox(
//                             alignment: Alignment.centerLeft,
//                             fit: BoxFit.scaleDown,
//                             child: Text(
//                               vehicle.rto ?? "Unknown Vehicle",
//                               style:
//                                   const TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ),
//                         vehicle.gsmSingnalStrength == null
//                             ? const SizedBox()
//                             : Row(
//                                 children: [
//                                   // Text(
//                                   //   "${vehicle.gsmSingnalStrength} ",
//                                   //   style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
//                                   // ),
//                                   Icon(
//                                     gsmSingnalStrength! > 18
//                                         ? Icons.signal_cellular_alt_rounded
//                                         : gsmSingnalStrength! > 8
//                                             ? Icons
//                                                 .signal_cellular_alt_2_bar_rounded
//                                             : Icons
//                                                 .signal_cellular_alt_1_bar_rounded,
//                                     size: 25,
//                                     color: gsmSingnalStrength! > 18
//                                         ? Colors.green
//                                         : gsmSingnalStrength! > 8
//                                             ? Colors.yellow
//                                             : Colors.red,
//                                   ),
//                                 ],
//                               ),
//                       ],
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("ID: ${vehicle.id ?? "Unknown"}"),
//                             vehicle.externalBatteryVoltage == null
//                                 ? const SizedBox()
//                                 : Row(
//                                     children: [
//                                       const Icon(
//                                         Icons.battery_charging_full_rounded,
//                                         size: 18,
//                                       ),
//                                       Text(
//                                         "${vehicle.externalBatteryVoltage} v",
//                                         style: const TextStyle(fontSize: 15),
//                                       )
//                                     ],
//                                   )
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Flexible(
//                               fit: FlexFit.tight,
//                               child: Text(
//                                 overflow: TextOverflow.clip,
//                                 maxLines: 5,
//                                 "Data Received : ${timePassedSince(vehicle.datetime ?? '0')} ago",
//                                 style: const TextStyle(
//                                     fontSize: 12, color: Colors.grey),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             vehicle.idleSince != "0" ||
//                                     vehicle.idleSince == null
//                                 ? Text(
//                                     "Idle Since: ${convertSecondsToHoursMinutes(vehicle.idleSince.toString())}",
//                                     style:
//                                         const TextStyle(color: Colors.yellow),
//                                   )
//                                 : vehicle.stoppageSince != "0" ||
//                                         vehicle.stoppageSince == null
//                                     ? Text(
//                                         "Stoppage Since: ${convertSecondsToHoursMinutes(vehicle.stoppageSince.toString())}",
//                                         style:
//                                             const TextStyle(color: Colors.red),
//                                       )
//                                     : Text(
//                                         "Moving: ${vehicle.speed} Kmph",
//                                         style: const TextStyle(
//                                             color: Colors.green),
//                                       ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Container(
//                           height: 2,
//                           width: 300,
//                           color: Colors.grey,
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 const Text(
//                                   "Today Distance",
//                                   style: TextStyle(
//                                       fontSize: 12, color: Colors.grey),
//                                 ),
//                                 Text(
//                                   "${vehicle.distanceToday} Kms",
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 15),
//                                 )
//                               ],
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 const Text(
//                                   "Ignition",
//                                   style: TextStyle(
//                                       fontSize: 12, color: Colors.grey),
//                                 ),
//                                 vehicle.ignitionStatus == "0"
//                                     ? const Text("OFF",
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 15,
//                                             color: Colors.red))
//                                     : const Text("ON",
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 15,
//                                             color: Colors.green)),
//                               ],
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 const Text(
//                                   "Stoppage Since",
//                                   style: TextStyle(
//                                       fontSize: 12, color: Colors.grey),
//                                 ),
//                                 Text(
//                                   "${convertSecondsToHoursMinutes(vehicle.stoppageSince.toString())} ",
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 15),
//                                 )
//                               ],
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                     onTap: () {
//                       // Action when a vehicle is tapped

//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => TabBarWidget(
//                               specificVehicleID: vehicle.id.toString(),
//                               vehicleRTO: vehicle.rto.toString(),
//                             ),
//                           ));
//                     },
//                   ),
//                 );
              