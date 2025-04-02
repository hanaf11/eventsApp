import 'package:eventsappusers/models/dogadjaj.dart';
import 'package:eventsappusers/models/narudzba.dart';
import 'package:eventsappusers/screens/narudzba_preview_screen.dart';
import 'package:eventsappusers/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../widgets/master_screen.dart';
import '../widgets/narudzba_master_screen.dart';
import 'package:country_picker/country_picker.dart';

class PaymentInfoScreen extends StatefulWidget {
  Narudzba narudzba;
  Dogadjaj dogadjaj;
  PaymentInfoScreen(
      {super.key, required this.narudzba, required this.dogadjaj});

  @override
  State<PaymentInfoScreen> createState() => _PaymentInfoScreenState();
}

class _PaymentInfoScreenState extends State<PaymentInfoScreen> {
  double _contentHeight = 0;

  TextEditingController brojKarticeController = TextEditingController();
  TextEditingController vlasnikController = TextEditingController();
  TextEditingController datumController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  final _paymentFormKey = new GlobalKey<FormBuilderState>();
  int _selectedPayment = 0;

  _PaymentInfoScreenState();

  clickNextStep() {
    /*bool formValid = _paymentFormKey.currentState?.saveAndValidate() ?? false;
    if (formValid) {*/
    Narudzba n = widget.narudzba;
    /* n.brojKartice = _paymentFormKey.currentState?.value["BrojKartice"];
      n.datumKartice = _paymentFormKey.currentState?.value["DatumKartice"];
      n.imePrezimeKartica =
          _paymentFormKey.currentState?.value["ImePrezimeKartica"];
      n.cvv = _paymentFormKey.currentState?.value["Cvv"];*/

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            NarudzbaPreviewScreen(narudzba: n, dogadjaj: widget.dogadjaj)));
    //}
  }

  @override
  Widget build(BuildContext context) {
    var isLoading = false;
    return MasterScreen(
        selectedIndex: -1,
        showBackButton: true,
        showAppBar: true,
        child: Expanded(
            child: isLoading
                ? const CircularProgressIndicator()
                : NarudzbaMasterScreen(
                    naslov: "Narudžba",
                    childHeight: _contentHeight,
                    tabActive: 2,
                    onClickNext: clickNextStep,
                    child: LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            _contentHeight = context.size!.height;
                          });
                        }
                      });
                      return Padding(
                          padding: EdgeInsets.all(15),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 191, 190, 190),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(4, 5),
                                  ),
                                ]),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildHeading("Podaci o plaćanju"),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  _buildInputs(_selectedPayment),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Text(
                                    "Izaberite drugačiji način plaćanja",
                                    style: TextStyle(
                                        color: Color.fromRGBO(60, 71, 92, 1),
                                        fontFamily: 'Montserrat',
                                        letterSpacing: 0.3,
                                        fontSize: 16),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      _buildPayment(
                                          'assets/images/visa.png', 1),
                                      SizedBox(width: 10),
                                      _buildPayment(
                                          'assets/images/stripe.png', 2),
                                    ],
                                  )
                                ]),
                          ));
                    }))));
  }

  _buildHeading(String naslov) {
    return Text(
        style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            color: Color.fromRGBO(54, 112, 232, 1),
            letterSpacing: 0.4,
            fontSize: 24),
        naslov);
  }

  Widget _buildInputs(selectedPayment) {
    return selectedPayment == 0 || selectedPayment == 1
        ? Column(
            children: [
              InputWidget(
                  controller: brojKarticeController,
                  placeholder: "Broj kartice"),
              InputWidget(
                  controller: vlasnikController,
                  placeholder: "Vlasnik kartice"),
              InputWidget(
                  controller: datumController, placeholder: "Datum isteka"),
              InputWidget(controller: cvvController, placeholder: "CVV"),
            ],
          )
        : Container();
  }

  _buildPayment(String img, int index) {
    return GestureDetector(
      child: Container(
        decoration: _selectedPayment == index
            ? BoxDecoration(
                border: Border.all(
                  color: Color.fromRGBO(54, 112, 232, 1),
                  width: 2,
                ),
              )
            : null,
        child: Image.asset(
          img,
          height: 50,
          width: 70,
          fit: BoxFit.contain,
        ),
      ),
      onTap: () {
        setState(() {
          _selectedPayment = index;
        });
      },
    );
  }
}
