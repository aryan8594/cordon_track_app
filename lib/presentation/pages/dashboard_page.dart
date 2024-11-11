import 'dart:ffi';

import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            
                Text("Overview", style: TextStyle(fontSize: 18),),
                Icon(Icons.arrow_forward_ios, size: 18,),
            
              ],
            ),
          )
        ],
      ),
    );
  }
}