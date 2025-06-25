import 'package:country_picker/country_picker.dart';
import 'package:eventsappusers/main.dart';
import 'package:eventsappusers/models/korisnik.dart';
import 'package:eventsappusers/providers/korisnik_provider.dart';
import 'package:eventsappusers/utils/style_util.dart';
import 'package:eventsappusers/widgets/field_with_validate.dart';
import 'package:eventsappusers/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  //static const routeName = '/register';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

/*bool isUserNameValid(String value) {
  RegExp regex = RegExp(r'^.{4,}$');
  return regex.hasMatch(value);
}

bool isPasswordValid(String value) {
  RegExp regex = RegExp(r'^.{8,}$');
  return regex.hasMatch(value);
}

bool isEmailValid(String value) {
  RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
      caseSensitive: false);
  return regex.hasMatch(value);
}*/

class _RegisterScreenState extends State<RegisterScreen> {
  //AuthProvider? _authProvider;
  final _formKey = new GlobalKey<FormBuilderState>();
  String? userName;
  String? email;
  String? password;
  List<String> errors = [];
  late Color myColor;
  late Size mediaSize;
  late KorisnikProvider _korisnikProvider;
  @override
  void initState() {
    super.initState();
    // _authProvider = context.read<AuthProvider>();
    _korisnikProvider = context.read<KorisnikProvider>();
  }

  _register() async {
    print("uslo u objavljivanje");

    if (_formKey.currentState?.saveAndValidate() ?? false) {
      print("validno");
      print(_formKey.currentState?.value);

      Korisnik request = Korisnik.fromJson(_formKey.currentState!.value);
      print("request je");
      print(request.ime);
      try {
        await _korisnikProvider
            .insert(request, isRegistration: true)
            .then((value) => handleSuccess("Uspješno ste se registrovali"));
      } on Exception catch (ex) {
        handleException(ex);
      }
    }
  }

  handleSuccess(String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Success"),
              content: Text(msg),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text("OK"))
              ],
            ));
  }

  handleException(Exception e) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Exception'),
        content: Text(e.toString()),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
        constraints: BoxConstraints(maxHeight: mediaSize.height),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Events",
                              style: TextStyle(
                                color: myColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 37,
                              ),
                            ),
                            Text(
                              "App",
                              style: TextStyle(
                                color: Color.fromARGB(204, 123, 146, 191),
                                fontWeight: FontWeight.bold,
                                fontSize: 37,
                              ),
                            )
                          ],
                        ),
                        _buildForm(),
                        SizedBox(
                          height: 8,
                        ),
                        Row(children: [
                          const SizedBox(width: 5),
                          const Text(
                            'Već ste registrovani?',
                            style: TextStyle(
                                color: Color.fromARGB(255, 94, 94, 95)),
                          ),
                          const SizedBox(width: 20),
                          InkWell(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => LoginPage())),
                            child: const Text(
                              'Prijava',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(54, 112, 232, 1)),
                            ),
                          )
                        ]),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _register();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            elevation: 20,
                            shadowColor: Colors.grey,
                            backgroundColor: myColor,
                            minimumSize: const Size.fromHeight(60),
                          ),
                          child: const Text(
                            "REGISTRUJ SE",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        )
                      ],
                    )),
              )
            ],
          ),
        ));
  }

  _buildForm() {
    return FormBuilder(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          FieldWithValidate(
              label: 'Ime:',
              field: FormBuilderTextField(
                style: TextStyle(fontSize: 14),
                name: "ime",
                decoration: newInput,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'Polje je obavezno'),
                ]),
              )),
          FieldWithValidate(
              label: 'Prezime:',
              field: FormBuilderTextField(
                style: TextStyle(fontSize: 14),
                name: "prezime",
                decoration: newInput,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'Polje je obavezno'),
                ]),
              )),
          FieldWithValidate(
              label: 'Email:',
              field: FormBuilderTextField(
                style: TextStyle(fontSize: 14),
                name: "email",
                decoration: newInput,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'Polje je obavezno'),
                  FormBuilderValidators.email(errorText: "Email nije validan")
                ]),
              )),
          FieldWithValidate(
              label: 'Korisničko ime:',
              field: FormBuilderTextField(
                style: TextStyle(fontSize: 14),
                name: "korisnickoIme",
                decoration: newInput.copyWith(errorMaxLines: 3),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'Polje je obavezno'),
                  FormBuilderValidators.match(RegExp(r'^[a-zA-Z0-9]{3,32}$'),
                      errorText:
                          "Korisničko ime treba sadržavati između 3-32 karaktera\nSamo slova i brojevi")
                ]),
              )),
          FieldWithValidate(
              label: 'Lozinka:',
              field: FormBuilderTextField(
                style: TextStyle(fontSize: 14),
                name: "password",
                obscureText: true,
                decoration: newInput.copyWith(
                  errorMaxLines: 5,
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'Polje je obavezno')
                ]),
              )),
          FieldWithValidate(
              label: 'Potvrda lozinke:',
              field: FormBuilderTextField(
                style: TextStyle(fontSize: 14),
                name: "passwordPotvrda",
                obscureText: true,
                decoration: newInput.copyWith(
                  errorMaxLines: 5,
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'Polje je obavezno')
                ]),
              )),
          FieldWithValidate(
              label: 'Telefon:',
              field: FormBuilderTextField(
                style: TextStyle(fontSize: 14),
                name: "telefon",
                decoration: newInput,
                   validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'Polje je obavezno'),
                  FormBuilderValidators.phoneNumber(
                      errorText: "Očekivani format: +38761000000",
                      regex: RegExp(r'^\+\d{11,12}$'))
                ]),
              )),
          FieldWithValidate(
              label: 'Adresa:',
              field: FormBuilderTextField(
                  style: TextStyle(fontSize: 14),
                  name: "adresa",
                  decoration: newInput,
                   validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'Polje je obavezno')
                ]),)),
          _buildCountryInput(),
        ]));
  }

  _buildCountryInput() {
    return InkWell(
        child: IgnorePointer(
          child: FieldWithValidate(
              label: 'Država:',
              field: FormBuilderTextField(
                style: TextStyle(fontSize: 14),
                name: "drzava",
                decoration: newInput,
              )),
        ),
        onTap: () {
          showCountryPicker(
              context: context,
              onSelect: (Country country) {
                setState(() {
                  _formKey.currentState?.fields['drzava']
                      ?.didChange(country.name);
                });
              });
        });
  }

//adla build
  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 28, 28, 29),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Center(
                  child: Icon(
                    Icons.theater_comedy,
                    color: Color.fromARGB(255, 250, 250, 250),
                    size: 100,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        onSaved: (newValue) => userName = newValue,
                        validator: (newValue) {
                          if (newValue!.isEmpty) {
                            return "This field is required!";
                          }
                          if (!isUserNameValid(newValue!)) {
                            return "Username must contain at least 4 characters!";
                          }
                          if (errors.isNotEmpty &&
                              errors.any((e) =>
                                  e ==
                                  "Username '$userName' is already taken.")) {
                            return 'Username is already taken!';
                          }
                        },
                        style: const TextStyle(
                            color: Color.fromARGB(255, 250, 250, 250)),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'Username',
                          hintText: 'emma123',
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 250, 250, 250)),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        onSaved: (newValue) => email = newValue,
                        validator: (newValue) {
                          if (newValue!.isEmpty) {
                            return "This field is required!";
                          }
                          if (!isEmailValid(newValue!)) {
                            return "Please enter a valid email!";
                          }
                          if (errors.isNotEmpty &&
                              errors.any((element) =>
                                  element == "Email is already taken!")) {
                            return "Email is already taken!";
                          }
                        },
                        style: const TextStyle(
                            color: Color.fromARGB(255, 250, 250, 250)),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'Email',
                          hintText: 'email@example.com',
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 250, 250, 250)),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        onSaved: (newValue) => password = newValue,
                        validator: (newValue) {
                          if (newValue!.isEmpty) {
                            return "This field is required!";
                          }
                          if (!isPasswordValid(newValue!)) {
                            return "Password must be atleast 8 charcters!";
                          }
                        },
                        obscureText: true,
                        autocorrect: false,
                        enableSuggestions: false,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 250, 250, 250)),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'Password',
                          hintText: '*********',
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 250, 250, 250)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () async {
                          errors = [];
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                          }
                          Map registerData = {
                            'email': email,
                            'password': password,
                            'userName': userName,
                          };
                          /* try {
                            var data =
                                await _authProvider!.register(registerData);
                            TokenProvider.jwtToken = data!.token;
                            if (context.mounted) {
                              Navigator.popAndPushNamed(
                                  context, Navigation.routeName);
                            }
                          } on Exception catch (err) {
                            if (err.toString().contains("Bad request")) {
                              print(err.toString());
                              if (err.toString().contains(
                                  "Email '$email' is already taken")) {
                                errors.add("Email is already taken!");
                              }
                              if (err.toString().contains(
                                  "Username '$userName' is already taken.")) {
                                errors.add(
                                    "Username '$userName' is already taken.");
                              }
                              formKey.currentState!.validate();
                            }
                          }*/
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 204, 36, 68),
                          ),
                          height: 50,
                          child: const Center(
                            child: Text(
                              'Register',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 250, 250, 250),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const SizedBox(width: 5),
                    const Text(
                      'Already have an account?',
                      style:
                          TextStyle(color: Color.fromARGB(255, 250, 250, 250)),
                    ),
                    const SizedBox(width: 20),
                    InkWell(
                      onTap: () => {},
                      //  Navigator.pushNamed(context, Login.routeName),
                      child: const Text(
                        'Login here',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 204, 36, 68),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }*/

  Widget _buildTextFormField({
    required String label,
    required String hint,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
    bool isPassword = false,
  }) {
    return TextFormField(
      onSaved: onSaved,
      validator: validator,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: const Color(0xFF3670E8)),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF2D2D2E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class BlueArtPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      //..color = const Color(0xFF3670E8).withOpacity(0.3)
      ..color = Color.fromARGB(255, 18, 29, 51).withOpacity(0.3)
      ..style = PaintingStyle.fill;

    Path path = Path()
      ..moveTo(0, size.height * 0.4)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.2,
        size.width,
        size.height * 0.4,
      )
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
