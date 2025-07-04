import 'package:flutter/material.dart';

class DostupneKarteWidget extends StatefulWidget {
  String nazivKarte;
  int raspolozivo;
  double cijena;
  int stanje;
  Function(int) onKolicinaChange;

  DostupneKarteWidget(
      {super.key,
      required this.nazivKarte,
      required this.raspolozivo,
      required this.cijena,
      required this.stanje,
      required this.onKolicinaChange});

  @override
  State<DostupneKarteWidget> createState() => _DostupneKarteWidgetState();
}

class _DostupneKarteWidgetState extends State<DostupneKarteWidget> {
  int kolicina = 0;

  _DostupneKarteWidgetState();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 1),
        child: Container(
            margin: EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(4, 5),
                  ),
                ]),
            child: Center(
                child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.nazivKarte,
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                  fontSize: 16,
                                  color: Color.fromRGBO(31, 48, 83, 1)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Trenutno raspoloživo: ",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      letterSpacing: 0.5,
                                      fontSize: 13,
                                      color: Color.fromRGBO(60, 71, 91, 1)),
                                ),
                                Text(
                                  widget.raspolozivo.toString(),
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.5,
                                      fontSize: 13,
                                      color: Color.fromRGBO(31, 48, 83, 1)),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Cijena: ",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      letterSpacing: 0.5,
                                      fontSize: 13,
                                      color: Color.fromRGBO(60, 71, 91, 1)),
                                ),
                                Text(
                                  "${widget.cijena}KM",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.5,
                                      fontSize: 13,
                                      color: Color.fromRGBO(31, 48, 83, 1)),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                        _buildKolicina()
                      ],
                    )))));
  }

  Row _buildKolicina() {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.all(2),
          child: SizedBox(
              height: 30,
              width: 30,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Color.fromRGBO(44, 152, 240, 1),
                    ),
                    padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                onPressed: () {
                  if (kolicina - 1 >= 0) {
                    setState(() {
                      kolicina -= 1;
                      widget.onKolicinaChange(kolicina);
                    });
                  }
                },
                child: Icon(
                  Icons.remove,
                  color: Colors.white,
                  size: 20,
                ),
              )),
        ),
        Padding(
          padding: EdgeInsets.all(2),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color.fromRGBO(74, 71, 71, 1))),
            padding: EdgeInsets.all(8),
            child: Text(
              kolicina.toString(),
              style: TextStyle(
                  color: Color.fromRGBO(31, 48, 83, 1),
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w800),
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.all(2),
            child: SizedBox(
                height: 30,
                width: 30,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Color.fromRGBO(44, 152, 240, 1),
                      ),
                      padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                  onPressed: () {
                    if (kolicina + 1 <= widget.stanje) {
                      setState(() {
                        kolicina += 1;
                        widget.onKolicinaChange(kolicina);
                      });
                    }
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                )))
      ],
    );
  }
}
