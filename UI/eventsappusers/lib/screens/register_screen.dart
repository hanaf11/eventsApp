import 'package:country_picker/country_picker.dart';
import 'package:eventsappusers/main.dart';
import 'package:eventsappusers/models/korisnik.dart';
import 'package:eventsappusers/providers/korisnik_provider.dart';
import 'package:eventsappusers/utils/style_util.dart';
import 'package:eventsappusers/widgets/field_with_validate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late Color myColor;
  late Size mediaSize;
  late KorisnikProvider _korisnikProvider;
  @override
  void initState() {
    super.initState();
    _korisnikProvider = context.read<KorisnikProvider>();
  }

  Future<void> _register() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      Korisnik request = Korisnik.fromJson(_formKey.currentState!.value);

      try {
        await _korisnikProvider
            .insert(request, isRegistration: true)
            .then((value) => handleSuccess("Uspješno ste se registrovali"));
      } on Exception catch (ex) {
        handleException(ex);
      }
    }
  }

  void handleSuccess(String msg) {
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

  void handleException(Exception e) {
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
  myColor = const Color.fromRGBO(54, 112, 232, 1);
  mediaSize = MediaQuery.of(context).size;

  return Container(
    decoration: BoxDecoration(
      color: myColor,
      image: DecorationImage(
        image: const AssetImage("assets/images/banner.jpg"),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(
          myColor.withOpacity(0.5),
          BlendMode.dstATop,
        ),
      ),
    ),
    constraints: BoxConstraints(maxHeight: mediaSize.height),
    child: Column(
      children: [
        Expanded(
          child: Container(), // this fills all top space, pushing the Card down
        ),
        SingleChildScrollView(
          child: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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
                          color: const Color.fromARGB(204, 123, 146, 191),
                          fontWeight: FontWeight.bold,
                          fontSize: 37,
                        ),
                      ),
                    ],
                  ),
                  _buildForm(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const SizedBox(width: 5),
                      const Text(
                        'Već ste registrovani?',
                        style: TextStyle(
                          color: Color.fromARGB(255, 94, 94, 95),
                        ),
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        ),
                        child: const Text(
                          'Prijava',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(54, 112, 232, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}



  FormBuilder _buildForm() {
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

  InkWell _buildCountryInput() {
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
}

