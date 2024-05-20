import 'package:flutter/material.dart';

class MasterScreen extends StatefulWidget {
  final int selectedIndex;
  final bool showBackButton;
  final bool? showFollowButton;
  Widget? child;
  MasterScreen(
      {required this.selectedIndex,
      required this.showBackButton,
      this.showFollowButton,
      this.child,
      super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState(
      selectedIndex: selectedIndex,
      showBackButton: showBackButton,
      showFollowButton: showFollowButton ?? false);
}

class _MasterScreenState extends State<MasterScreen> {
  int selectedIndex = 0;
  int _selectedSideMenuIndex = 0;
  bool showBackButton;
  bool? showFollowButton;

  _MasterScreenState(
      {required this.selectedIndex,
      required this.showBackButton,
      this.showFollowButton});

  /*final List<BottomNavigationBarItem> _items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_max_outlined),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.navigation_outlined),
      label: 'Location',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.save),
      label: 'Saved',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_2_outlined),
      label: 'profile',
    ),
  ];*/

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void _onSideMenuItemTapped(int index) {
    setState(() {
      _selectedSideMenuIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 245, 246, 1),
      appBar: AppBar(
          scrolledUnderElevation: 0.0,
          leading: showBackButton
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
          actions: showFollowButton != null && showFollowButton == true
              ? [
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "myRoute");
                      },
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          "+ Prati",
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
              child: Text('Navigation'),
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Messages'),
              selected: _selectedSideMenuIndex == 0,
              onTap: () {
                _onSideMenuItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
              selected: _selectedSideMenuIndex == 1,
              onTap: () {
                _onSideMenuItemTapped(1);
                Navigator.pop(context);
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
      bottomNavigationBar: NavigationBar(
        height: 60,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            selectedIcon: Icon(
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
        selectedIndex: selectedIndex,

        //selectedItemColor: const Color.fromRGBO(44, 152, 240, 1),

        onDestinationSelected: _onItemTapped,
      ),
    );
  }
}
