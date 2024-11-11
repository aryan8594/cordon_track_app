
import 'package:cordon_track_app/presentation/pages/single_live_map_page.dart';
import 'package:cordon_track_app/presentation/pages/vehicle_history_page.dart';
import 'package:flutter/material.dart';

class TabBarWidget extends StatefulWidget {
  TabBarWidget({super.key, this.specificVehicleID});
  final specificVehicleID;

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Vehicle Tracking for ${widget.specificVehicleID}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          bottom: const PreferredSize(preferredSize: Size.fromHeight(60), 
          child: TabBar(
            tabs: [
                Tab(icon: Icon(Icons.my_location),text: "Live"),
                Tab(icon: Icon(Icons.route_rounded),text: "History"),
                Tab(icon: Icon(Icons.query_stats_rounded),text: "Reports"),
                Tab(icon: Icon(Icons.document_scanner),text: "Documents")
            ]
            )
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            SingleVehicleMapPage(vehicleId: widget.specificVehicleID),
            VehicleHistoryPage(vehicleId: widget.specificVehicleID,),
            Placeholder(),
            Placeholder()
          ]
          ),
      ),
    );
  }
}