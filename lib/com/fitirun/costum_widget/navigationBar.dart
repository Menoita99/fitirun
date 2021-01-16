import 'package:fitirun/com/fitirun/resource/constants.dart';
import 'package:fitirun/com/fitirun/resource/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:logger/logger.dart';





@immutable
class NavigationBottomBar extends StatefulWidget {

  Color actualColor;

  NavigationBottomBar();

  NavigationBottomBar.withColor(this.actualColor);

  @override
  _NavigationBottomBarState createState() => _NavigationBottomBarState();
}


class _NavigationBottomBarState extends State<NavigationBottomBar> {

  NavigationBottomBarState state = NavigationBottomBarState();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
      ]),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              duration: Duration(milliseconds: 500),
              tabBackgroundColor: widget.actualColor == null ? navColors.elementAt(state._selectedIndex) :  widget.actualColor,
              tabs: [
                GButton(
                  iconColor: blackText,
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  iconColor: blackText,
                  icon: Icons.directions_run,
                  text: 'Run',
                ),
                GButton(
                  iconColor: blackText,
                  icon: Icons.fitness_center,
                  text: 'Fitness',
                ),
                GButton(
                  iconColor: blackText,
                  icon: Icons.person,
                  text: 'Profile',
                ),
              ],
              selectedIndex: state._selectedIndex,
              onTabChange: (index) {
                if (state._selectedIndex != index) {
                  //            setState(() {
                  if (this.mounted) {
                    state._selectedIndex = index;
                  }
                  Navigator.popAndPushNamed(context, getNavRoute().elementAt(index));
                  //            });
                }
              }),
        ),
      ),
    );
  }
}

/*
* Singleton
 */
class NavigationBottomBarState{
  static final NavigationBottomBarState _instance = NavigationBottomBarState._internal();

  int _selectedIndex = 0;

  factory NavigationBottomBarState() => _instance;

  NavigationBottomBarState._internal() {
     _selectedIndex = 0;
  }
}

