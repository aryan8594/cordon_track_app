// lib/presentation/widgets/vehicle_info_sheet.dart
// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:cordon_track_app/data/data_providers/single_live_vehicle_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomVehicleInfoSheet extends ConsumerWidget {
  final String vehicleId;

  const BottomVehicleInfoSheet({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    final vehicleData = ref.watch(singleLiveVehicleProvider(vehicleId));

    return vehicleData.when(
      data: (vehicle) {
        if (vehicle == null || vehicle.data == null || vehicle.data!.isEmpty) {
          return const Center(
              child: Text("No data available for this vehicle."));
        }

        var vehicleInfo =
            vehicle.data![0]; // Access the first item in the data list
        // double? speed = vehicleInfo.speed != null
        //     ? double.tryParse(vehicleInfo.speed!)
        //     : null;

        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.share,
                                color: Colors.lightBlueAccent,
                                size: 30,
                              ),
                              onPressed: () {
                                if (vehicleInfo.latitude != null &&
                                    vehicleInfo.longitude != null) {
                                  final locationUrl =
                                      "https://www.google.com/maps/search/?api=1&query=${vehicleInfo.latitude},${vehicleInfo.longitude}";
                                  Share.share(
                                      "Check out this location: $locationUrl for the vehicle with number, ${vehicleInfo.rto}.\nSent through the Cordon Track App!");
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Location unavailable")),
                                  );
                                }
                              },
                            ),
                            const Text(
                              "Share\nLocation",
                              style: TextStyle(),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.directions,
                                color: Colors.lightBlueAccent,
                                size: 30,
                              ),
                              onPressed: () {
                                if (vehicleInfo.latitude != null &&
                                    vehicleInfo.longitude != null) {
                                  final googleMapsUrl =
                                      "google.navigation:q=${vehicleInfo.latitude},${vehicleInfo.longitude}&mode=d";
                                  launchUrl(Uri.parse(googleMapsUrl),
                                      mode: LaunchMode.externalApplication);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Unable to navigate. Location unavailable")),
                                  );
                                }
                              },
                            ),
                            const Text("Navigate"),
                          ],
                        ),
                        // Column(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     IconButton(
                        //       icon: const Icon(
                        //         Icons.info,
                        //         color: Colors.lightBlueAccent,
                        //         size: 30,
                        //       ),
                        //       onPressed: () async {
                        //         // Navigator.of(context).pop();
                        //         // await Future.delayed(const Duration(milliseconds: 500));
                        //         // ref
                        //         //     .read(navigationIndexProvider.notifier)
                        //         // //     .state = 1;
                        //         // await Future.delayed(const Duration(milliseconds: 500));
                        //         Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => TabBarWidget(
                        //                     specificVehicleID:
                        //                         vehicleInfo.id ?? "",
                        //                     vehicleRTO: vehicleInfo.rto ?? '',
                        //                   )),
                        //         );
                        //       },
                        //     ),
                        //     const Text(
                        //       "Detailed\nView",
                        //       textAlign: TextAlign.center,
                        //     ),
                        //   ],
                        // )
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
                    // Text(
                    //   "Vehicle ID: ${vehicleInfo.id}",
                    //   style:
                    //       const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            "Location",
                            style: TextStyle(fontSize: 12),
                          ),
                          const Text(
                            ":",
                            style: TextStyle(fontSize: 12),
                          ),
                          Flexible(
                            child: Text("${vehicleInfo.location}",
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.clip,
                                softWrap: true,
                                maxLines: 5),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const Align(
                        //   alignment: Alignment.center,
                        //   child: Text("Today Overview", style: TextStyle(fontSize: 15),)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                  "${vehicleInfo.distanceToday} Kms",
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
                                  "Idle Time",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  "${convertSecondsToHoursMinutes(vehicleInfo.idleSince!)} ",
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
                                  "Stoppage Time",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  "${convertSecondsToHoursMinutes(vehicleInfo.stoppageSince!)} ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                )
                              ],
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: -50,
              right: 1,
              child: Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.transparent),
                child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: WidgetStateColor.transparent),
                    onPressed: () => Navigator.of(context)
                      ..pop()
                      ..pop(),
                    child: const Icon(
                      Icons.close,
                      size: 30,
                      color: Colors.black,
                    )),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Text("Error: $err"),
    );
  }
}

class TopVehicleInfoSheet extends ConsumerWidget {
  final String vehicleId;

  const TopVehicleInfoSheet({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    final vehicleData = ref.watch(singleLiveVehicleProvider(vehicleId));

    return vehicleData.when(
      data: (vehicle) {
        if (vehicle == null || vehicle.data == null || vehicle.data!.isEmpty) {
          return const Center(
              child: Text("No data available for this vehicle."));
        }

        var vehicleInfo =
            vehicle.data![0]; // Access the first item in the data list
        double? speed = vehicleInfo.speed != null
            ? double.tryParse(vehicleInfo.speed!)
            : null;
        double? idleSince = vehicleInfo.idleSince != null
            ? double.tryParse(vehicleInfo.idleSince!)
            : null;
        double? stoppageSince = vehicleInfo.stoppageSince != null
            ? double.tryParse(vehicleInfo.stoppageSince!)
            : null;
        double? externalBatteryVoltage =
            vehicleInfo.externalBatteryVoltage != null
                ? double.tryParse(vehicleInfo.externalBatteryVoltage!)
                : null;
        double? gsmSingnalStrength = vehicleInfo.gsmSingnalStrength != null
            ? double.tryParse(vehicleInfo.gsmSingnalStrength!)
            : null;

        return Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        speed == 0
                            ? const Icon(
                                Icons.adjust_rounded,
                                color: Colors.yellow,
                              )
                            : const Icon(
                                Icons.adjust_rounded,
                                color: Colors.green,
                              ),
                        vehicleInfo.panicStatus == "0"
                            ? const SizedBox()
                            : const Icon(
                                Icons.report_problem_rounded,
                                color: Colors.redAccent,
                                size: 25,
                              ),
                        vehicleInfo.gpsStatus == '1'
                            ? const SizedBox()
                            : const Icon(
                                Icons.gps_off_rounded,
                                size: 25,
                                color: Colors.redAccent,
                              ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        vehicleInfo.speed == "0"
                            ? const Text(
                                "IDLE",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow),
                              )
                            : const Text(
                                "MOVING",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                        stoppageSince! <= 60 && idleSince! <= 60
                            ? Text(
                                "Distance today is ${vehicleInfo.distanceToday} Km",
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.grey),
                              )
                            : Text(
                                "Vehicle Idle Time: ${convertSecondsToHoursMinutes(vehicleInfo.idleSince!)}\nVehicle Stoppage Time: ${convertSecondsToHoursMinutes(vehicleInfo.stoppageSince!)}",
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.grey),
                              ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            overflow: TextOverflow.fade,
                            maxLines: 5,
                            "Data Received : ${timePassedSince(vehicleInfo.datetime!)} ago",
                            style: const TextStyle(
                                fontSize: 10, color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text("${vehicleInfo.speed} Km/h"),
                            speed! == 0
                                ? const Icon(
                                    Icons.speed_rounded,
                                    color: Colors.yellow,
                                  )
                                : speed >= 60
                                    ? const Icon(
                                        Icons.speed_rounded,
                                        color: Colors.red,
                                      )
                                    : speed <= 60
                                        ? const Icon(
                                            Icons.speed_rounded,
                                            color: Colors.green,
                                          )
                                        : const Icon(
                                            Icons.speed_rounded,
                                            color: Colors.black,
                                          ),
                          ],
                        ),
                        Row(
                          children: [
                            vehicleInfo.ignitionStatus == "0"
                                ? const Text("OFF")
                                : const Text("ON"),
                            vehicleInfo.ignitionStatus == "0"
                                ? const Icon(
                                    Icons.key_off,
                                    color: Colors.red,
                                  )
                                : const Icon(
                                    Icons.key,
                                    color: Colors.green,
                                  ),
                          ],
                        ),
                        vehicleInfo.externalBatteryVoltage == null
                            ? const SizedBox()
                            : Row(
                                children: [
                                  Text(
                                    "${vehicleInfo.externalBatteryVoltage} v",
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  externalBatteryVoltage! < 9
                                      ? const Icon(
                                          Icons.battery_charging_full_rounded,
                                          size: 18,
                                          color: Colors.redAccent,
                                        )
                                      : const Icon(
                                          Icons.battery_charging_full_rounded,
                                          size: 18,
                                          color: Colors.green,
                                        ),
                                ],
                              ),
                        vehicleInfo.acStatus == null
                            ? const SizedBox()
                            : Row(
                                children: [
                                  vehicleInfo.acStatus == "0"
                                      ? const Text("AC OFF")
                                      : vehicleInfo.acStatus == null
                                          ? const Text("")
                                          : vehicleInfo.acStatus == "1"
                                              ? const Text("AC ON")
                                              : const Text(""),
                                  vehicleInfo.acStatus == "0"
                                      ? const Icon(
                                          Icons.ac_unit,
                                          color: Colors.red,
                                        )
                                      : vehicleInfo.acStatus == "1"
                                          ? const Icon(
                                              Icons.ac_unit,
                                              color: Colors.green,
                                            )
                                          : vehicleInfo.acStatus == null
                                              ? const SizedBox()
                                              : const SizedBox()
                                ],
                              ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 11,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: Text(
                      "${vehicleInfo.rto}",
                      overflow: TextOverflow.clip,
                      softWrap: true,
                      maxLines: 5,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    )),
                    gsmSingnalStrength == null
                        ? const SizedBox()
                        : Row(
                            children: [
                              // Text(
                              //   "${vehicle.gsmSingnalStrength} ",
                              //   style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                              // ),
                              Icon(
                                gsmSingnalStrength > 18
                                    ? Icons.signal_cellular_alt_rounded
                                    : gsmSingnalStrength > 8
                                        ? Icons
                                            .signal_cellular_alt_2_bar_rounded
                                        : Icons
                                            .signal_cellular_alt_1_bar_rounded,
                                size: 25,
                                color: gsmSingnalStrength > 18
                                    ? Colors.green
                                    : gsmSingnalStrength > 8
                                        ? Colors.yellow
                                        : Colors.red,
                              )
                            ],
                          ),
                    // const IconButton(
                    //   icon: Icon(Icons.settings_backup_restore_rounded),
                    //   onPressed: null,
                    // ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Text("Error: $err"),
    );
  }
}

// Method to show Bottom Modal
void showVehicleInfoModal(BuildContext context, String? vehicleId, Ref ref) {
  showModalBottomSheet(
    context: context,
    builder: (context) => BottomVehicleInfoSheet(vehicleId: vehicleId!),
    backgroundColor: Colors.transparent,
    barrierColor: Colors.transparent,
    isScrollControlled: true,
  ).whenComplete(() {
    // Reset vehicle ID logic, if necessary
    Navigator.of(context).pop();
    resetVehicleId(vehicleId, ref);
  });
}

// Method to show Top Modal
void showVehicleTopModalSheet(BuildContext context, String vehicleId, Ref ref) {
  showTopModalSheet(
    context,
    TopVehicleInfoSheet(vehicleId: vehicleId),
    backgroundColor: Colors.transparent,
    borderRadius: BorderRadius.circular(15),
    startOffset: const Offset(0, 100),
    curve: Curves.linear,
    barrierColor: Colors.transparent,
  ).whenComplete(() {
    // Additional logic on complete, if necessary
  });
}

void resetVehicleId(String? vehicleId, Ref ref) async {
  if (vehicleId != null) {
    Future.microtask(() {
      // ref.read(selectedVehicleIdProvider.notifier).state = null;
    });

    // Future.microtask(() => ref.read(selectedVehicleIdProvider.notifier).state = null);
    log("Vehicle ID reset to null: $vehicleId");
  }
}
