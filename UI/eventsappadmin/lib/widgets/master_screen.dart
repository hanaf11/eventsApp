import 'package:eventsappadmin/main.dart';
import 'package:flutter/material.dart';

import '../screens/dogadjaji_list_screen.dart';

class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  MasterScreenWidget({this.child, super.key});

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [Text("Events "), Text("Admin panel")],
          ),
          //title: Text(widget.title ?? " ")
        ),
        body: Row(
          children: [
            Container(
              width: 250,
              child: ListView(
                children: [
                  ListTile(
                      title: Text("Događaji"),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const DogadjajiListScreen(),
                          ),
                        );
                      }),
                  ListTile(
                      title: Text("Zahtjevi"),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const DogadjajiListScreen(),
                          ),
                        );
                      }),
                  ListTile(
                      title: Text("Korisnici"),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const DogadjajiListScreen(),
                          ),
                        );
                      }),
                  ListTile(
                      title: Text("Narudžbe"),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const DogadjajiListScreen(),
                          ),
                        );
                      }),
                  ListTile(
                      title: Text("Login"),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      })
                ],
              ),
            ),
            Container(
              child: widget.child,
            )
          ],
        ));
  }
}
