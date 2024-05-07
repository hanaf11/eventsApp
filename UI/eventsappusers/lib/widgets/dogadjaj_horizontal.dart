import 'package:flutter/material.dart';

class DogadjajHorizontalWidget extends StatefulWidget {
  final String naslov;
  final DateTime datumOd;
  final DateTime datumDo;
  final String lokacija;
  final String kategorija;
  final bool? saved;

  DogadjajHorizontalWidget(
      {super.key,
      required this.naslov,
      required this.datumOd,
      required this.datumDo,
      required this.lokacija,
      this.saved,
      required this.kategorija});

  @override
  State<DogadjajHorizontalWidget> createState() =>
      _DogadjajHorizontalWidgetState(saved: saved);
}

class _DogadjajHorizontalWidgetState extends State<DogadjajHorizontalWidget> {
  //_DogadjajHorizontalWidgetState();
  bool? saved;

  _DogadjajHorizontalWidgetState({this.saved});

  List months = [
    'jan',
    'feb',
    'mar',
    'apr',
    'may',
    'jun',
    'jul',
    'aug',
    'sep',
    'oct',
    'nov',
    'dec'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        padding: const EdgeInsets.all(6.0),
        height: 130,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(4, 5),
              ),
            ],
            borderRadius: BorderRadius.circular(20)),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(
                    "assets/images/banner.jpg",
                    height: 120,
                    width: 100,
                    fit: BoxFit.fill,
                  )),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.58,
                                child: Text(
                                  widget.naslov,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  maxLines: 3,
                                  style: TextStyle(
                                      color: Color.fromRGBO(31, 48, 83, 1),
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.0,
                                      fontSize: 16),
                                )),
                            Expanded(
                                child: Container(
                                    alignment: Alignment.bottomLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                formatDate(widget.datumOd) +
                                                    " - " +
                                                    formatDate(widget.datumDo),
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        113, 126, 148, 1),
                                                    fontFamily: 'Montserrat',
                                                    letterSpacing: 1,
                                                    fontSize: 12),
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.location_on_outlined,
                                                    size: 10,
                                                    color: Color.fromRGBO(
                                                        156, 156, 168, 1),
                                                  ),
                                                  Text(
                                                    widget.lokacija,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            156, 156, 168, 1),
                                                        fontFamily:
                                                            'Montserrat',
                                                        letterSpacing: 1,
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                widget.kategorija,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        127, 48, 227, 1),
                                                    fontFamily: 'Montserrat',
                                                    letterSpacing: 1,
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              )
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  saved = !saved!;
                                                });
                                              },
                                              isSelected: saved,
                                              selectedIcon: const Icon(
                                                  Icons.bookmark_sharp),
                                              icon: const Icon(
                                                  Icons.bookmark_border),
                                              color:
                                                  Color.fromRGBO(31, 48, 83, 1),
                                              iconSize: 22,
                                            ),
                                            IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                  Icons.arrow_forward),
                                              color:
                                                  Color.fromRGBO(31, 48, 83, 1),
                                              iconSize: 22,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ))),
                          ]))),
            ]));
  }

  String formatDate(DateTime date) {
    return date.day.toString() + "." + months[date.month - 1];
  }
}
