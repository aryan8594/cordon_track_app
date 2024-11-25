import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  final List<ReportCardData> reportCardData = [
    ReportCardData(
      title: "Travelled Path Report",
      description: "View the detailed travelled path of a vehicle over a specified period.",
      route: "/travelledPath",
    ),
    ReportCardData(
      title: "Distance Report",
      description: "Check the distance covered by the vehicle for a given duration.",
      route: "/distanceReport",
    ),
    ReportCardData(
      title: "Speed Report",
      description: "Analyze speed data of the vehicle and identify speed violations.",
      route: "/speedReport",
    ),
    ReportCardData(
      title: "Stoppage Report",
      description: "Find out stoppage times and locations for a specific vehicle.",
      route: "/stoppageReport",
    ),
    ReportCardData(
      title: "Idle Report",
      description: "Get detailed idle time statistics for the selected vehicle.",
      route: "/idleReport",
    ),
    ReportCardData(
      title: "Ignition Report",
      description: "View the ignition status changes during the selected timeframe.",
      route: "/ignitionReport",
    ),
    ReportCardData(
      title: "Trip Report",
      description: "Track trips taken by the vehicle with summaries and detailed views.",
      route: "/tripReport",
    ),
    ReportCardData(
      title: "Daily Report",
      description: "Check daily vehicle summaries, including trips and usage patterns.",
      route: "/dailyReport",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: ListView.builder(
        itemCount: reportCardData.length,
        itemBuilder: (context, index) {
          final report = reportCardData[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 4,
            child: ListTile(
              title: Text(report.title, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(report.description),
              trailing: Column(
                children: [
                  
                  const Icon(Icons.arrow_forward),
                  Text("Generate\nReport",textAlign: TextAlign.center),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(context, report.route);
              },
            ),
          );
        },
      ),
    );
  }
}

class ReportCardData {
  final String title;
  final String description;
  final String route;

  ReportCardData({
    required this.title,
    required this.description,
    required this.route,
  });
}
