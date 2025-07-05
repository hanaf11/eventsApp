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

  Future<void> getNarudzbaDetails() async {
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

  void handleLoading() {
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
                                Text("Broj narudžbe:", style: boldStyle),
                                Text(narudzba?.brojNarudzbe ?? "",
                                    style: myTextStyle),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Datum:", style: boldStyle),
                                Text(
                                  "${narudzba!.datum?.day}.${narudzba!.datum?.month}.${narudzba!.datum?.year}.",
                                  style: myTextStyle,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Tip:", style: boldStyle),
                                Text(narudzba?.tip ?? "", style: myTextStyle),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Cijena:", style: boldStyle),
                                Text(formatCijena(narudzba?.cijena ?? 0),
                                    style: myTextStyle),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Korisnik koji je napravio narudžbu:",
                                    style: boldStyle),
                                Text(narudzba!.korisnickoIme ?? "",
                                    style: myTextStyle),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Text("Dostava", style: h2),
                            _buildLicniPodaci(),
                            const SizedBox(height: 20),
                            Text("Stavke narudžbe", style: h2),
                            Text(_stavke[0].dogadjaj ?? '',
                                style: myTextStyle),
                            Divider(
                              color: const Color.fromARGB(255, 145, 145, 145),
                              thickness: 0.7,
                            ),
                            _stavke.isEmpty
                                ? Text(
                                    "Nema stavki u narudžbi.",
                                    style: myTextStyle,
                                  )
                                : Column(
                                    children:
                                        _stavke.map((StavkeNarudzbe stavka) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(stavka.tipKarte ?? "",
                                              style: myTextStyle),
                                          Text(
                                              "${stavka.kolicina} x ${formatCijena(stavka.cijena)}",
                                              style: myTextStyle),
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
          style: myTextStyle,
        ),
        Text(
          "${narudzba?.postanskiBroj} ${narudzba?.grad}",
          style: myTextStyle,
        ),
        Text(
          "${narudzba?.drzava}",
          style: myTextStyle,
        ),
        Text(
          "${narudzba?.telefon}",
          style: myTextStyle,
        ),
        Text(
          "${narudzba?.email}",
          style: myTextStyle,
        ),
      ],
    );
  }

}
