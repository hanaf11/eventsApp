import 'package:eventsappadmin/main.dart';
import 'package:eventsappadmin/screens/dogadjaj_details_screen.dart';
import 'package:eventsappadmin/screens/narudzbe_list_screen.dart';
import 'package:flutter/material.dart';

import '../screens/dogadjaji_list_screen.dart';
import '../screens/korisnici_list_screen.dart';
import '../screens/zahtjevi_list_screen.dart';

class MasterScreenWidget extends StatefulWidget {
  int? selectedIndex = 0;
  bool? showBackButton = false;
  Widget? child;
  MasterScreenWidget(
      {this.selectedIndex, this.child, this.showBackButton, super.key});

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState(
      selectedIndex: selectedIndex, showBackButton: showBackButton);
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  int? selectedIndex = 0;
  bool? showBackButton = false;
  _MasterScreenWidgetState({this.selectedIndex, this.showBackButton});

  final List<String> _items = [
    "Događaji",
    "Zahtjevi",
    "Korisnici",
    "Narudžbe",
    "Log out"
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: showBackButton ?? false,
          title: Row(
            children: [
              Text("Events "),
              SizedBox(width: 5),
              Text("Admin panel",
                  style: TextStyle(
                      color: const Color.fromARGB(26, 251, 209, 209)
                          .withOpacity(0.6))),
            ],
          ),
        ),
        body: Row(
          children: [
            Container(
              width: 250,
              decoration:
                  BoxDecoration(color: Color.fromRGBO(171, 213, 249, 100)),
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return Padding(
                        padding: EdgeInsets.all(7),
                        child: Container(
                            decoration: selectedIndex == index
                                ? BoxDecoration(
                                    color: Color.fromRGBO(78, 170, 245, 0.7),
                                    border: Border.all(
                                        color:
                                            Color.fromARGB(255, 149, 164, 166),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  )
                                : null,
                            child: ListTile(
                                title: Text(
                                  item,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                onTap: () {
                                  _onItemTapped(index);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => getScreen(index)),
                                  );
                                })));
                  },
                  separatorBuilder: ((context, index) {
                    return Divider(
                      thickness: 2,
                    );
                  }),
                  itemCount: _items.length),
            ),
            Container(
              child: widget.child,
            )
          ],
        ));
  }
}

Widget getScreen(int index) {
  switch (index) {
    case 0:
      return DogadjajiListScreen();
    case 1:
      return ZahtjeviListScreen(selected: index);
    case 2:
      return KorisniciListScreen(selected: index);
    case 3:
      return NarudzbeListScreen(selected: index);
    case 4:
      return LoginPage();
    default:
      return DogadjajiListScreen();
  }
}
