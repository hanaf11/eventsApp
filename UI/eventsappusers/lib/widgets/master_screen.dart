import 'package:eventsappusers/screens/home_screen.dart';
import 'package:eventsappusers/screens/kategorije_screen.dart';
import 'package:eventsappusers/screens/kreiraj_dogadjaj_screen.dart';
import 'package:eventsappusers/screens/map_screen.dart';
import 'package:eventsappusers/screens/profile_screen.dart';
import 'package:eventsappusers/screens/spremljeno_screen.dart';
import 'package:flutter/material.dart';

class MasterScreen extends StatefulWidget {
  final int selectedIndex;
  final bool showBackButton;
  final bool? showFollowButton;
  bool? following;
  final bool? showAppBar;
  Widget? child;
  Function? followFunc;
  MasterScreen(
      {required this.selectedIndex,
      required this.showBackButton,
      this.showFollowButton,
      this.following,
      this.showAppBar,
      this.child,
      this.followFunc,
      super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  int? _selectedIndex;
  int _selectedSideMenuIndex = -1;

  _MasterScreenState();

  @override
  void initState() {
    super.initState();
    if (widget.selectedIndex > -2 && widget.selectedIndex < 4) {
      setState(() {
        _selectedIndex = widget.selectedIndex;
      });
    }
  }

  _getPage(index) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        return MapScreen();
      case 2:
        return SpremljenoScreen();
      case 3:
        return ProfileScreen();
    }
  }

  getScreen(index) {
    switch (index) {
      case 0:
        return KategorijeScreen();
      case 1:
        return KreirajDogadjajScreen();
    }
  }

  void onSideMenuItemTapped(int index) {
    setState(() {
      _selectedSideMenuIndex = index;
    });
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => getScreen(index)),
    );
  }

  String getFollowingText() {
    if (widget.following != null && widget.following == true)
      return "- Odprati";
    else if (widget.following != null && widget.following == false) {
      return "+ Prati";
    } else
      return '';
  }

  @override
  Widget build(BuildContext context) {
    String followingText = getFollowingText();
    return Scaffold(
        backgroundColor: const Color.fromRGBO(244, 245, 246, 1),
        appBar: widget.showAppBar != null && widget.showAppBar == false
            ? null
            : AppBar(
                scrolledUnderElevation: 0.0,
                leading: widget.showBackButton
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    : Builder(builder: (context) {
                        return IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            });
                      }),
                backgroundColor: const Color.fromRGBO(244, 245, 246, 1),
                actions: widget.showFollowButton != null &&
                        widget.showFollowButton == true
                    ? [
                        GestureDetector(
                            onTap: () {
                              if (widget.followFunc != null) {
                                widget.followFunc!();
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                followingText,
                                style: TextStyle(
                                    color: Color.fromRGBO(54, 112, 232, 1),
                                    fontFamily: 'Montserrat',
                                    letterSpacing: 0.8,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            ))
                      ]
                    : []),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Navigacija'),
              ),
              ListTile(
                leading: Icon(Icons.auto_awesome_motion_rounded),
                title: Text('Kategorije'),
                selected: _selectedSideMenuIndex == 0,
                onTap: () {
                  onSideMenuItemTapped(0);
                },
              ),
              ListTile(
                leading: Icon(Icons.add_circle_outline),
                title: Text('Objavi događaj'),
                selected: _selectedSideMenuIndex == 1,
                onTap: () {
                  onSideMenuItemTapped(1);
                },
              ),
            ],
          ),
        ),
        body: Row(
          children: [
            Container(
              child: widget.child,
            )
          ],
        ),
        bottomNavigationBar: NavigationBarTheme(
          data:
              const NavigationBarThemeData(indicatorColor: Colors.transparent),
          child: NavigationBar(
              height: 60,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              destinations: <Widget>[
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                  selectedIcon: _selectedIndex == -1
                      ? Icon(
                          Icons.home_outlined,
                        )
                      : Icon(
                          Icons.home_outlined,
                          color: Color.fromRGBO(44, 152, 240, 1),
                        ),
                ),
                NavigationDestination(
                  icon: Icon(Icons.location_on_outlined),
                  label: 'Explore',
                  selectedIcon: Icon(
                    Icons.location_on_outlined,
                    color: Color.fromRGBO(44, 152, 240, 1),
                  ),
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.bookmark_border,
                    size: 20,
                  ),
                  label: 'Saved',
                  selectedIcon: Icon(
                    Icons.bookmark_border,
                    color: Color.fromRGBO(44, 152, 240, 1),
                  ),
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_2_outlined),
                  label: 'Profile',
                  selectedIcon: Icon(
                    Icons.person_2_outlined,
                    color: Color.fromRGBO(44, 152, 240, 1),
                  ),
                ),
              ],
              backgroundColor: Color.fromRGBO(255, 255, 255, 1),
              selectedIndex: _selectedIndex == -1 ? 0 : _selectedIndex ?? 0,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => _getPage(index))).then((_) {
                  setState(() {
                    _selectedIndex = _getIndexForCurrentScreen();
                  });
                });
              }),
        ));
  }

  int _getIndexForCurrentScreen() {
    return widget.selectedIndex;
  }
}
