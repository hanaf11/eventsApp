import 'package:eventsappadmin/main.dart';
import 'package:eventsappadmin/screens/dogadjaj_details_screen.dart';
import 'package:eventsappadmin/screens/narudzbe_list_screen.dart';
import 'package:flutter/material.dart';

import '../screens/dogadjaji_list_screen.dart';
import '../screens/korisnici_list_screen.dart';
import '../screens/zahtjevi_list_screen.dart';

class MasterScreenWidget extends StatefulWidget {
  int? selectedIndex = 0;

  Widget? child;
  //int? selectedIndex = 0;
  MasterScreenWidget({this.selectedIndex, this.child, super.key});

  @override
  State<MasterScreenWidget> createState() =>
      _MasterScreenWidgetState(selectedIndex: selectedIndex);
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  int? selectedIndex = 0;

  _MasterScreenWidgetState({this.selectedIndex});

  final List<String> _items = [
    "Događaji",
    "Zahtjevi",
    "Korisnici",
    "Narudžbe",
    "Log out"
  ];

  @override
  void initState() {
    super.initState();

    /* _items = [
      Item(name: "Događaji"),
      Item(name: "Zahtjevi"),
      Item(name: "Korisnici"),
      // Add more items here
    ];*/
  }

  /* final List<Item> _items = [
    Item(
        name: "Događaji",
        route: DogadjajiListScreen(
          selected: selectedIndex,
        )),
    Item(
        name: "Zahtjevi",
        route: ZahtjeviListScreen(
          selected: null,
        )),
    Item(name: "Korisnici", route: KorisniciListScreen()),
    // Add more items here
  ];*/

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text("Events "),
              SizedBox(width: 5),
              Text("Admin panel",
                  style: TextStyle(color: Colors.white10.withOpacity(0.6))),
              Text("selected master ${selectedIndex}")
            ],
          ),
          //title: Text(widget.title ?? " ")
        ),
        body: Row(
          children: [
            Container(
              width: 250,
              decoration:
                  BoxDecoration(color: Color.fromRGBO(171, 213, 249, 100)),
              /* child: ListView(
                children: [
                  ListTile(
                      title: Text(
                        "Događaji",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      shape: Border(
                        bottom: BorderSide(color: Colors.grey, width: 1),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const DogadjajiListScreen(),
                          ),
                        );
                        
                      }),
                  ListTile(
                      title: Text("Zahtjevi",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const DogadjajiListScreen(),
                          ),
                        );
                      }),
                  ListTile(
                      title: Text(
                        "Korisnici",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const DogadjajiListScreen(),
                          ),
                        );
                      }),
                  ListTile(
                      title: Text(
                        "Narudžbe",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const DogadjajiListScreen(),
                          ),
                        );
                      }),
                  ListTile(
                      title: Text(
                        "Log out",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      })
                ],
              ),*/
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
                                /*shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 2),
                                  borderRadius: BorderRadius.circular(30),
                                ),*/
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
      return DogadjajiListScreen(selected: index);
    case 1:
      return ZahtjeviListScreen(selected: index);
    case 2:
      return KorisniciListScreen(selected: index);
    case 3:
      return NarudzbeListScreen(selected: index);
    case 4:
      return LoginPage();
    default:
      return DogadjajiListScreen(selected: 0);
  }
}

/*class Item {
  final String name;
  String route;

  Item({required this.name, required this.route});
}
*/