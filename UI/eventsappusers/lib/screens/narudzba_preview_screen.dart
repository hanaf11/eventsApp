import 'package:eventsappusers/models/dogadjaj.dart';
import 'package:eventsappusers/models/narudzba.dart';
import 'package:eventsappusers/providers/narudzba_provider.dart';
import 'package:eventsappusers/screens/home_screen.dart';
import 'package:eventsappusers/utils/formatting_util.dart';
import 'package:eventsappusers/widgets/dogadjaj_small_overview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/master_screen.dart';
import '../widgets/narudzba_master_screen.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class NarudzbaPreviewScreen extends StatefulWidget {
  Narudzba narudzba;
  Dogadjaj dogadjaj;
  NarudzbaPreviewScreen(
      {super.key, required this.narudzba, required this.dogadjaj});

  @override
  State<NarudzbaPreviewScreen> createState() => _NarudzbaPreviewScreenState();
}

class _NarudzbaPreviewScreenState extends State<NarudzbaPreviewScreen> {
  double _contentHeight = 0;
  late NarudzbaProvider _narudzbaProvider;
  late double _ukupno = 0;
  bool isLoading = false;

  _NarudzbaPreviewScreenState();

  @override
  void initState() {
    super.initState();
    _ukupno = _calcUkupno();
    _narudzbaProvider = context.read<NarudzbaProvider>();
  }

  double _calcUkupno() {
    double ukupno = 0;
    widget.narudzba.listaKarata?.forEach((e) {
      ukupno += (e.cijena as double);
    });
    return ukupno;
  }

  Future<void> clickNextStep() async {
    Narudzba n = widget.narudzba;
    n.cijena = _ukupno;
    var amount = (_ukupno * 100).toInt();
    Map<String, dynamic> paymentIntentReq = {
      "amount": amount,
      "currency": "bam"
    };

    setState(() {
      isLoading = true;
    });

    try {
      String? clientSecret =
          await _narudzbaProvider.createPaymentIntent(paymentIntentReq);

      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: clientSecret,
              merchantDisplayName: "eventsApp"));
      var paymentSuccess = await processPayment();

      if (paymentSuccess) {
        var value = await _narudzbaProvider.createNarudzba(n);
        handleNarudzbaSuccess();
      }
    } on Exception catch (ex) {
      setState(() {
        isLoading = false;
      });
      if (ex is StripeException) {
        handleException(ex.error.localizedMessage ?? ex.toString());
      } else {
        handleException(ex.toString());
      }
    }
  }

  Future<bool> processPayment() async {
    try {
      print("Presenting payment sheet...");
      await Stripe.instance.presentPaymentSheet();
      print("Payment sheet completed.");
      return true;
    } on Exception catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e is StripeException) {
        handleException(e.error.localizedMessage ?? e.toString());
      } else {
        handleException(e.toString());
      }
      return false;
    }
  }

  void handleNarudzbaSuccess() {
    setState(() {
      isLoading = false;
    });
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Success'),
        content: const Text(
            "Uspješno ste kreirali narudžbu. Potvrda će vam doći na email."),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomeScreen())),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void handleException(String e) {
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
    return MasterScreen(
        selectedIndex: -1,
        showBackButton: true,
        showAppBar: true,
        child: Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
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
                                  DogadjajSmallOverview(
                                    naziv: widget.dogadjaj.naziv ?? '',
                                    datumOd: widget.dogadjaj.datumOd ??
                                        DateTime.now(),
                                    tickets: widget.narudzba.listaKarata,
                                    ukupno: _ukupno,
                                    naslovna: widget.dogadjaj.naslovna,
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  _buildLicniPodaci(),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  _buildPlacanjePodaci(),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Center(
                                      child: _buildHeading(
                                          "Ukupno za platiti: ${formatNumber(_ukupno)}"))
                                ]),
                          ));
                    }))));
  }

  Column _buildLicniPodaci() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeading("Lični podaci"),
        Text(
          "${widget.narudzba.ime} ${widget.narudzba.prezime}",
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Color.fromRGBO(60, 71, 92, 1),
              fontSize: 15,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3),
        ),
        Text(
          widget.narudzba.adresa ?? '',
          style: _myTextStyle,
        ),
        Text(
          "${widget.narudzba.postanskiBroj} ${widget.narudzba.grad}",
          style: _myTextStyle,
        ),
        Text(
          "${widget.narudzba.drzava}",
          style: _myTextStyle,
        ),
        Text(
          "${widget.narudzba.telefon}",
          style: _myTextStyle,
        ),
        Text(
          "${widget.narudzba.email}",
          style: _myTextStyle,
        ),
        Row(
          children: [
            Text(
              "Način preuzimanja: ",
              style: _myTextStyle,
            ),
            Text(
              "${widget.narudzba.tip}",
              style: _myTextStyle,
            ),
          ],
        )
      ],
    );
  }

  final TextStyle _myTextStyle = TextStyle(
      color: Color.fromRGBO(60, 71, 92, 1),
      fontSize: 15,
      fontFamily: 'Montserrat',
      letterSpacing: 0.3);

  Text _buildHeading(String naslov) {
    return Text(
        style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            color: Color.fromRGBO(54, 112, 232, 1),
            letterSpacing: 0.4,
            fontSize: 24),
        naslov);
  }

  Column _buildPlacanjePodaci() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildHeading("Plaćanje"),
      Text(
        "Stripe",
        style: _myTextStyle,
      )
    ]);
  }
}
