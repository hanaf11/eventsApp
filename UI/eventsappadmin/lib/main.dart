import 'package:eventsappadmin/models/korisnik.dart';
import 'package:eventsappadmin/models/korisnik_global.dart';
import 'package:eventsappadmin/providers/dobavljac_provider.dart';
import 'package:eventsappadmin/providers/dogadjaj_provider.dart';
import 'package:eventsappadmin/providers/galerija_provider.dart';
import 'package:eventsappadmin/providers/kategorija_provider.dart';
import 'package:eventsappadmin/providers/korisnik_provider.dart';
import 'package:eventsappadmin/providers/narudzba_provider.dart';
import 'package:eventsappadmin/providers/podkategorija_provider.dart';
import 'package:eventsappadmin/providers/stavke_narudzbe_provider.dart';
import 'package:eventsappadmin/providers/tipkarte_provider.dart';
import 'package:eventsappadmin/providers/uloga_provider.dart';
import 'package:eventsappadmin/utils/util.dart';
import 'package:provider/provider.dart';

import './screens/dogadjaji_list_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => DogadjajProvider()),
      ChangeNotifierProvider(create: (_) => KategorijaProvider()),
      ChangeNotifierProvider(create: (_) => PodkategorijaProvider()),
      ChangeNotifierProvider(create: (_) => GalerijaProvider()),
      ChangeNotifierProvider(create: (_) => KorisnikProvider()),
      ChangeNotifierProvider(create: (_) => DobavljacProvider()),
      ChangeNotifierProvider(create: (_) => TipkarteProvider()),
      ChangeNotifierProvider(create: (_) => NarudzbaProvider()),
      ChangeNotifierProvider(create: (_) => StavkeNarudzbeProvider()),
      ChangeNotifierProvider(create: (_) => UlogaProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EventsApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    var myColor = Color.fromRGBO(54, 112, 232, 1);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "EventsApp ",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(width: 5),
            Text(
              "Admin panel",
              style: TextStyle(
                color: const Color.fromARGB(26, 251, 209, 209).withOpacity(0.6),
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/banner.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.7),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            16),
                        child: Image.asset(
                          'assets/images/eventsAppLogo.png',
                          height: 150,
                          width: 150,
                          fit: BoxFit
                              .cover,
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Username",
                          prefixIcon: const Icon(Icons.person),
                        ),
                        controller: _usernameController,
                      ),
                      SizedBox(height: 8),
                      TextField(
                          decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: Icon(Icons.password)),
                          controller: _passwordController,
                          obscureText: true),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          KorisnikProvider _korisnikprovider =
                              new KorisnikProvider();

                          var username = _usernameController.text;
                          var password = _passwordController.text;

                          Authorization.username = username;
                          Authorization.password = password;

                          try {
                            var credentials = {
                              'username': Authorization.username,
                              'password': Authorization.password
                            };
                            Korisnik data =
                                await _korisnikprovider.login(credentials);
                            bool canAccess = (data.uloge != null &&
                                    data.uloge!.contains("Admin") ||
                                data.uloge!.contains("Manager"));
                            if (!canAccess) {
                              throw Exception(
                                  "Access denied: You must have a role Admin or Manager to log in.");
                            }

                            KorisnikGlobal(data);

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DogadjajiListScreen(),
                              ),
                            );
                          } on Exception catch (e) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text("Error"),
                                content: Text(e.toString()),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("OK"),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: Text("Login"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
