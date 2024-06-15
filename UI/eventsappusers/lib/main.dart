import 'dart:convert';

import 'package:eventsappusers/providers/auth_provider.dart';
import 'package:eventsappusers/providers/kategorije_provider.dart';
import 'package:eventsappusers/screens/buy_ticket_screen.dart';
import 'package:eventsappusers/screens/edit_profile_screen.dart';
import 'package:eventsappusers/screens/event_details_screen.dart';
import 'package:eventsappusers/screens/home_screen.dart';
import 'package:eventsappusers/screens/kategorije_details_screen.dart';
import 'package:eventsappusers/screens/kategorije_screen.dart';
import 'package:eventsappusers/screens/kreiraj_dogadjaj_screen.dart';
import 'package:eventsappusers/screens/map_screen.dart';
import 'package:eventsappusers/screens/narudzba_preview_screen.dart';
import 'package:eventsappusers/screens/payment_information_screen.dart';
import 'package:eventsappusers/screens/personal_information_screen.dart';
import 'package:eventsappusers/screens/profile_screen.dart';
import 'package:eventsappusers/screens/spremljeno_screen.dart';
import 'package:eventsappusers/utils/util.dart';
import 'package:eventsappusers/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<KategorijeProvider>(
        create: (_) => KategorijeProvider())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'EventsApp',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: LoginPage());
  }
}

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  late Color myColor;
  late Size mediaSize;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  login(BuildContext context) async {
    KategorijeProvider provider = new KategorijeProvider();

    var username = usernameController.text;
    var password = passwordController.text;

    AuthProvider.username = usernameController.text;
    AuthProvider.password = passwordController.text;

    try {
      // await provider.get();
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => EditProfileScreen()),
      );
    } on Exception catch (e) {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text("Error"),
                content: Text(e.toString()),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("OK"))
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    myColor = Color.fromRGBO(54, 112, 232, 1);
    mediaSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: myColor,
        image: DecorationImage(
          image: const AssetImage("assets/images/banner.jpg"),
          fit: BoxFit.cover,
          colorFilter:
              ColorFilter.mode(myColor.withOpacity(0.5), BlendMode.dstATop),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Positioned(top: 50, child: _buildTop()),
          Positioned(bottom: 0, child: _buildBottom(context)),
        ]),
      ),
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Events",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 50,
            ),
          ),
          Text(
            "App",
            style: TextStyle(
              color: Color.fromRGBO(255, 255, 255, 0.698),
              fontWeight: FontWeight.bold,
              fontSize: 50,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottom(BuildContext context) {
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        )),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _buildForm(context),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Prijava",
          style: TextStyle(
              color: myColor, fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        _buildGreyText("Korisničko ime"),
        _buildInputField(usernameController),
        const SizedBox(height: 40),
        _buildGreyText("Lozinka"),
        _buildInputField(passwordController, isPassword: true),
        const SizedBox(height: 5),
        _buildRememberForgot(),
        const SizedBox(height: 20),
        _buildLoginButton(context),
        const SizedBox(height: 20),
        _buildRegisterButton(),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }

  Widget _buildInputField(TextEditingController controller,
      {isPassword = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon:
            isPassword ? const Icon(Icons.password) : const Icon(Icons.person),
      ),
      obscureText: isPassword,
    );
  }

  Widget _buildRememberForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
            onPressed: () {},
            child: _buildGreyText(
              "Zaboravio/la sam lozinku",
            ))
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        login(context);
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 20,
        shadowColor: myColor,
        minimumSize: const Size.fromHeight(60),
      ),
      child: const Text("PRIJAVI SE"),
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: () => {print("oressed")},
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 20,
        shadowColor: Colors.grey,
        backgroundColor: myColor,
        minimumSize: const Size.fromHeight(60),
      ),
      child: const Text(
        "REGISTRACIJA",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
