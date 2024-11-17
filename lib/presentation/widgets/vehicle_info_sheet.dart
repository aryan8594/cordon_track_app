// lib/presentation/widgets/vehicle_info_sheet.dart
import 'dart:developer';

import 'package:cordon_track_app/business_logic/marker_provider.dart';
import 'package:cordon_track_app/data/data_providers/single_live_vehicle_provider.dart';
import 'package:cordon_track_app/data/models/single_live_vehicle_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';

class BottomVehicleInfoSheet extends ConsumerWidget {
  final String vehicleId;

  const BottomVehicleInfoSheet({Key? key, required this.vehicleId}) : super(key: key);

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
          return const Center(child: Text("No data available for this vehicle."));
        }

        var vehicleInfo = vehicle.data![0]; // Access the first item in the data list
        double? speed = vehicleInfo.speed != null ? double.tryParse(vehicleInfo.speed!) : null;

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
                      const SizedBox(height: 10,),
                       Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.share),
                              Text("Share\nLocation", style: TextStyle(),textAlign: TextAlign.center,)
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.directions),
                              Text("Navigate"),
                              ],
                          )
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Container(
                        height: 2,
                        width: 300,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 10,),
                      Text("Vehicle ID: ${vehicleInfo.id}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                      const SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Location", style: TextStyle(fontSize: 12),),
                            Text(":",style: TextStyle(fontSize: 12),),
                            Flexible(
                              child: Text("${vehicleInfo.location}",
                              style: TextStyle(fontSize: 12),
                              overflow: TextOverflow.clip,
                              softWrap: true,
                              maxLines: 5
                              
                              ),
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
                                    const Text("Today Distance", style: TextStyle(fontSize: 12, color: Colors.grey),),
                                    Text("${vehicleInfo.distanceToday} Kms", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)
                                  ],
                                ), 
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Idle Since", style: TextStyle(fontSize: 12, color: Colors.grey),),
                                    Text("${convertSecondsToHoursMinutes(vehicleInfo.idleSince!)} ", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text("Stoppage Since", style: TextStyle(fontSize: 12, color: Colors.grey),),
                                    Text("${convertSecondsToHoursMinutes(vehicleInfo.stoppageSince!)} ", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)
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
              decoration: const BoxDecoration(shape : BoxShape.circle, color: Colors.transparent),
              child: 
              ElevatedButton(
                style: ButtonStyle(backgroundColor: WidgetStateColor.transparent),
                onPressed: () => Navigator.of(context)..pop()..pop(),
                child: Icon(Icons.close, size: 30,color: Colors. black,)),
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

  const TopVehicleInfoSheet({Key? key, required this.vehicleId}) : super(key: key);

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
          return const Center(child: Text("No data available for this vehicle."));
        }

        var vehicleInfo = vehicle.data![0]; // Access the first item in the data list
        double? speed = vehicleInfo.speed != null ? double.tryParse(vehicleInfo.speed!) : null;
        return   Card(  
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            
            const SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                vehicleInfo.speed == "0"
                ? const Icon(Icons.adjust_rounded, color: Colors.yellow,)
                : const Icon(Icons.adjust_rounded, color: Colors.green,),
    
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    vehicleInfo.speed == "0"
                    ?const Text("IDLE", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.yellow),)
                    :const Text("MOVING", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green),),
    
                    vehicleInfo.idleSince == "0" || vehicleInfo.stoppageSince == "0"
                    ?Text("Distance today is ${vehicleInfo.distanceToday} Km", style: const TextStyle(fontSize: 10,color: Colors.grey),)
                    :Text("Vehicle Idle Since: ${vehicleInfo.idleSince}\nVehicle Stoppage since: ${vehicleInfo.stoppageSince}", style: const TextStyle(fontSize: 10,color: Colors.grey),),
    
    
                    const Text("Data Received : 10 seconds ago", style: TextStyle(fontSize: 10, color: Colors.grey),)
                  ],
                ),
                SizedBox(width: 50,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
    
                      children: [
                        Text("${vehicleInfo.speed} Kmph"),
                        speed! == 0
                        ?const Icon(Icons.speed_rounded, color: Colors.yellow,)
                        :speed >= 60
                        ?const Icon(Icons.speed_rounded, color: Colors.red,)
                        :speed <= 60
                        ?const Icon(Icons.speed_rounded, color: Colors.green,)
                        :const Icon(Icons.speed_rounded, color: Colors.black,),
                      ],
                    ),
                    Row(
    
                      children: [
                        vehicleInfo.ignitionStatus == "0"
                        ?const Text("OFF")
                        :const Text("ON"),
                        vehicleInfo.ignitionStatus == "0"
                        ?const Icon(Icons.key_off, color: Colors.red,)
                        :const Icon(Icons.key, color: Colors.green,),
                      ],
                    ),
                    Row(
                      children: [
                        vehicleInfo.acStatus == "0"
                        ?const Text("AC OFF")
                        :vehicleInfo.acStatus == null
                        ?const Text("")
                        :vehicleInfo.acStatus == "1"
                        ?const Text("AC ON")
                        :const Text(""),
                        vehicleInfo.acStatus == "0"
                        ?const Icon(Icons.ac_unit, color: Colors.red, )
                        :vehicleInfo.acStatus == "1"
                        ?const Icon(Icons.ac_unit, color: Colors.green, )
                        :vehicleInfo.acStatus == null
                        ?const Text("")
                        :const Text(""),
                      ],
                    )
    
                  ],
                )
              ],
            ),
           const SizedBox(height: 11,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text(
                  "${vehicleInfo.rto}", 
                  overflow: TextOverflow.clip,
                          softWrap: true,
                          maxLines: 5,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)),
                const Icon(Icons.settings_backup_restore_rounded),
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
    barrierColor:Colors.transparent,
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

void resetVehicleId(String? vehicleId, Ref ref) async {


  if (vehicleId != null) {

    Future.microtask(() {
    ref.read(selectedVehicleIdProvider.notifier).state = '';
                });
    
    // Future.microtask(() => ref.read(selectedVehicleIdProvider.notifier).state = null);
    log("Vehicle ID reset to null: ${vehicleId}");

  }

  
}


