import 'package:eventsappadmin/models/narudzba.dart';
import 'package:eventsappadmin/models/stavke_narudzbe.dart';
import 'package:eventsappadmin/providers/narudzba_provider.dart';
import 'package:eventsappadmin/providers/stavke_narudzbe_provider.dart';
import 'package:eventsappadmin/utils/style_util.dart';
import 'package:eventsappadmin/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NarudzbaDetailsScreen extends StatefulWidget {
  int narudzbaId;

  NarudzbaDetailsScreen({required this.narudzbaId, super.key});

  @override
  State<NarudzbaDetailsScreen> createState() => _NarudzbaDetailsScreenState();
}

class _NarudzbaDetailsScreenState extends State<NarudzbaDetailsScreen> {
  late NarudzbaProvider _narudzbaProvider;
  late StavkeNarudzbeProvider _stavkeNarudzbeProvider;
  Narudzba? narudzba;
  bool isNarudzbaLoading = true;
  bool isStavkeLoading = true;
  bool isLoading = true;
  List<StavkeNarudzbe> _stavke = [];

  @override
  void initState() {
    super.initState();
    _narudzbaProvider = context.read<NarudzbaProvider>();
    _stavkeNarudzbeProvider = context.read<StavkeNarudzbeProvider>();
    getNarudzbaDetails();
  }

  getNarudzbaDetails() async {
    var data = await _narudzbaProvider.getById(widget.narudzbaId);
    setState(() {
      narudzba = data;
      isNarudzbaLoading = false;
      handleLoading();
    });

    var stavke = await _stavkeNarudzbeProvider
        .getStavke(filter: {'narudzbaId': widget.narudzbaId});
    setState(() {
      _stavke = stavke;
      isStavkeLoading = false;
      handleLoading();
    });
  }

  handleLoading() {
    if (isNarudzbaLoading == false && isStavkeLoading == false) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: isLoading
          ? Container(child: Center(child: const CircularProgressIndicator()))
          : narudzba != null
              ? Container(
                  width: 600,
                  child: SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Broj narudžbe:", style: _boldStyle),
                                Text(narudzba?.brojNarudzbe ?? "",
                                    style: _myTextStyle),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Datum:", style: _boldStyle),
                                Text(
                                  "${narudzba!.datum?.day}.${narudzba!.datum?.month}.${narudzba!.datum?.year}.",
                                  style: _myTextStyle,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Tip:", style: _boldStyle),
                                Text(narudzba?.tip ?? "", style: _myTextStyle),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Cijena:", style: _boldStyle),
                                Text(formatCijena(narudzba?.cijena ?? 0),
                                    style: _myTextStyle),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Korisnik koji je napravio narudžbu:",
                                    style: _boldStyle),
                                Text(narudzba!.korisnickoIme ?? "",
                                    style: _myTextStyle),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Text("Dostava", style: h2),
                            _buildLicniPodaci(),
                            const SizedBox(height: 20),
                            Text("Stavke narudžbe", style: h2),
                            Text(_stavke[0].dogadjaj ?? '',
                                style: _myTextStyle),
                            Divider(
                              color: const Color.fromARGB(255, 145, 145, 145),
                              thickness: 0.7,
                            ),
                            _stavke.isEmpty
                                ? Text(
                                    "Nema stavki u narudžbi.",
                                    style: _myTextStyle,
                                  )
                                : Column(
                                    children:
                                        _stavke.map((StavkeNarudzbe stavka) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(stavka.tipKarte ?? "",
                                              style: _myTextStyle),
                                          Text(
                                              "${stavka.kolicina} x ${formatCijena(stavka.cijena)}",
                                              style: _myTextStyle),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                          ],
                        )),
                  ))
              : Container(),
    );
  }

  TextStyle _myTextStyle = TextStyle(
      color: Color.fromRGBO(60, 71, 92, 1),
      fontSize: 15,
      fontFamily: 'Montserrat',
      letterSpacing: 0.3);

  _buildLicniPodaci() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${narudzba?.ime ?? ""} ${narudzba?.prezime ?? ""}",
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Color.fromRGBO(60, 71, 92, 1),
              fontSize: 15,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3),
        ),
        Text(
          narudzba?.adresa ?? '',
          style: _myTextStyle,
        ),
        Text(
          "${narudzba?.postanskiBroj} ${narudzba?.grad}",
          style: _myTextStyle,
        ),
        Text(
          "${narudzba?.drzava}",
          style: _myTextStyle,
        ),
        Text(
          "${narudzba?.telefon}",
          style: _myTextStyle,
        ),
        Text(
          "${narudzba?.email}",
          style: _myTextStyle,
        ),
      ],
    );
  }

  TextStyle get _boldStyle => TextStyle(
        fontWeight: FontWeight.bold,
        color: const Color.fromARGB(255, 71, 70, 70),
        fontSize: 16,
      );

  /*TextStyle get _regularStyle => TextStyle(
        fontWeight: FontWeight.w300,
        color: Colors.grey,
        fontSize: 16,
      );*/

  Widget _userDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: _boldStyle),
          Text(value, style: _myTextStyle),
        ],
      ),
    );
  }
}
