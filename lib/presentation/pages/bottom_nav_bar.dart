import 'package:cordon_track_app/presentation/pages/live_map_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';

class BottomNavBarPage extends StatelessWidget {
  BottomNavBarPage({super.key});






  final List<Widget> _screens = [
    LiveMapPage(),
    Placeholder(),
  ];

  PageController _myPage = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 25,
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 75,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(6),
                child: IconButton(
                  iconSize: 30.0,
                
                  icon: Icon(Icons.home),
                  onPressed: () {
                
                      _myPage.jumpToPage(0);
                
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(6),
                child: IconButton(
                  iconSize: 30.0,
                
                  icon: Icon(Icons.search),
                  onPressed: () {
                      
                      _myPage.jumpToPage(1);
                      
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(6),
                child: IconButton(
                  iconSize: 30.0,
                
                  icon: Icon(Icons.notifications),
                  onPressed: () {
                      
                      _myPage.jumpToPage(2);
                      
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(6),
                child: IconButton(
                  iconSize: 30.0,
                
                  icon: Icon(Icons.list),
                  onPressed: () {
                      
                      _myPage.jumpToPage(3);
                      
                  },
                ),
              )
            ],
          ),
        ),
      ),
      body: PageView(
        controller: _myPage,
        onPageChanged: (int) {
          print('Page Changes to index $int');
        },
        children: <Widget>[
          Center(
            child: Container(
              child: Text('Empty Body 0'),
            ),
          ),
          Center(
            child: Container(
              child: Text('Empty Body 1'),
            ),
          ),
          Center(
            child: Container(
              child: Text('Empty Body 2'),
            ),
          ),
          Center(
            child: Container(
              child: Text('Empty Body 3'),
            ),
          )
        ],
        physics: NeverScrollableScrollPhysics(), // Comment this if you need to use Swipe.
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.all(4),
        height: 65.0,
        width: 65.0,
        child: FittedBox(
          child: FloatingActionButton(
            shape:CircleBorder(),
            onPressed: () {},
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            // elevation: 5.0,
          ),
        ),
      ),
    );
  }
}