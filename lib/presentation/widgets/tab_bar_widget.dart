
import 'package:cordon_track_app/presentation/pages/single_live_map_page.dart';
import 'package:cordon_track_app/presentation/pages/single_vehicle_reports_page.dart';
import 'package:cordon_track_app/presentation/pages/vehicle_history_page.dart';
import 'package:flutter/material.dart';

class TabBarWidget extends StatefulWidget {
  const TabBarWidget({super.key,required this.specificVehicleID, required this.vehicleRTO});
  final String specificVehicleID;
  final String vehicleRTO;

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(widget.vehicleRTO.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          maxLines:3,),
          bottom: const PreferredSize(preferredSize: Size.fromHeight(60), 
          child: TabBar(
            indicatorColor: Colors.lightBlueAccent,
            tabs: [
                Tab(icon: Icon(Icons.my_location, color: Colors.lightBlueAccent,),text: "Live"),
                Tab(icon: Icon(Icons.route_rounded,color: Colors.lightBlueAccent,),text: "History"),
                // Tab(icon: Icon(Icons.query_stats_rounded),text: "Reports"),

            ]
            )
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            SingleVehicleMapPage(vehicleId: widget.specificVehicleID),
            VehicleHistoryPage(vehicleId: widget.specificVehicleID,),
            // SingleVehicleReportsPage(vehicleId: widget.specificVehicleID, ),

          ]
          ),
      ),
    );
  }
}