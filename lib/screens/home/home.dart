import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thrive/formats/colors.dart' as ThriveColors;
import 'package:thrive/screens/createGoal/createGoal.dart';
import 'package:thrive/screens/friendSearch/friend_search.dart';
import 'package:thrive/screens/friendSearch/friend_requests.dart';
import 'package:thrive/screens/profile/profile.dart';
import 'package:thrive/screens/social_wall/social_wall.dart';
import 'package:thrive/screens/Password/password.dart';
import 'package:thrive/screens/Password/changepass.dart';
import 'package:thrive/screens/settings/settings.dart';
import 'package:thrive/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:thrive/services/database.dart';
import 'package:thrive/shared/loading.dart';

// "User home page", screen user sees after successful login
class Home extends StatefulWidget {
  final Function toggleHome;
  final Function toggleState;
  final FirebaseUser currUser;
  Home({this.toggleHome, this.toggleState, this.currUser});
  @override
  _HomeState createState() => _HomeState();
}

/* Temporary test screen */
class FirstPage extends StatelessWidget {
  const FirstPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wall Placeholder"),
      ),
      body: ListView.builder(itemBuilder: (context, index) {
        return ListTile(
          title: Text('Goal'),
          subtitle: Text('$index'),
        );
      }),
    );
  }
}

/* Maintains the navigation of all the screens */
class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  // Indicated which screen is selected
  // Starts app on the social wall
  int _selectedIndex = 0;
  bool loading = false;
  // Array of different pages for NavBar
  /*
  final List<Widget> pages = [
    SocialWall(),
    //FirstPage(),
    Profile (),
    CreateGoal(),
    Search(),
    FirstPage(),
  ];

   */

  final PageStorageBucket bucket = PageStorageBucket();

  void togglePage(int index) {
    setState(() {
      if (index == 5) {
        index = 3;
        loading = true;
        _selectedIndex = index;
      } else {
        _selectedIndex = index;
        loading = false;
      }
    });
  }

  void _onItemTapped(int index) {
    // If "add goal" is selected, we push the create goal screen
    if (index == 2) {
      /*
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) { return CreateGoal(); }),
      );

       */

      setState(() {
        _selectedIndex = index;
      });
    } else {
      // Otherwise reset state
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      SocialWall(currUser: widget.currUser),
      //FirstPage(),
      Profile(currUser: widget.currUser),
      CreateGoal(togglePage: this.togglePage),
      Search(togglePage: this.togglePage),
      Settings(toggleHome: widget.toggleHome, togglePage: this.togglePage),
    ];

    return Scaffold(
      body: loading
          ? Loading()
          : PageStorage(
              child: pages[_selectedIndex],
              bucket: bucket,
            ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30.0),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30.0),
            title: Text('Profile'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline, size: 30.0),
            title: Text('Add Goal'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 30.0),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 30.0),
            title: Text('Settings'),
          ),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        selectedItemColor: ThriveColors.DARK_ORANGE,
        backgroundColor: ThriveColors.TRANSPARENT_BLACK,
        unselectedItemColor: ThriveColors.LIGHT_ORANGE,
        onTap: _onItemTapped,
        //onTap: (int index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
