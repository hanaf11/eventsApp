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
import 'package:eventsappadmin/utils/style_util.dart';
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
        //  useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      home: LoginPage(),
    );
  }
}

class MyAppBar extends StatelessWidget {
  String? title;
  MyAppBar({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title!);
  }
}

class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _count = 0;

  void _incrementCounter() {
    setState(() {
      _count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("You have pushed button $_count times"),
        ElevatedButton(onPressed: _incrementCounter, child: Text("Increment"))
      ],
    );
  }
}

class LayoutExamples extends StatelessWidget {
  const LayoutExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150,
          color: Colors.red,
          child: Center(
              child: Container(
            height: 100,
            color: Colors.blue,
            child: Text("Example"),
            alignment: Alignment.center,
          )),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [Text("Item1"), Text("Itwm2"), Text("Item3")],
        ),
        Container(
          height: 150,
          color: Colors.red,
          alignment: Alignment.center,
          child: const Text("Container 2"),
        )
      ],
    );
  }
}

/*class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "RS2 Material App",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
    );
  }
}*/

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  late DogadjajProvider _dogadjajProvider;

  @override
  Widget build(BuildContext context) {
    var myColor = Color.fromRGBO(54, 112, 232, 1);
    _dogadjajProvider = context.read<DogadjajProvider>();

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
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/banner.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Centered container
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
                      /*Image.asset(
                        'assets/images/eventsAppLogo.png',
                        height: 150,
                        width: 150,
                      ),*/
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            16), // Adjust the value for roundness
                        child: Image.asset(
                          'assets/images/eventsAppLogo.png',
                          height: 150,
                          width: 150,
                          fit: BoxFit
                              .cover, // Ensures the image fits well inside the rounded corners
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
                          prefixIcon: Icon(Icons.password)
                        ),
                        controller: _passwordController,
                        obscureText:true
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        //style: buttonPrimary,
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
