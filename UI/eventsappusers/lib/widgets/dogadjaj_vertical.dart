import 'package:flutter/material.dart';

class DogadjajVerticalWidget extends StatefulWidget {
  final String naslov;
  final DateTime datumOd;
  final DateTime datumDo;
  final String lokacija;
  final String kategorija;

  DogadjajVerticalWidget(
      {super.key,
      required this.naslov,
      required this.datumOd,
      required this.datumDo,
      required this.lokacija,
      required this.kategorija});

  @override
  State<DogadjajVerticalWidget> createState() => _DogadjajVerticalWidgetState();
}

class _DogadjajVerticalWidgetState extends State<DogadjajVerticalWidget> {
  _DogadjajVerticalWidgetState();

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
        margin: EdgeInsets.symmetric(horizontal: 8),
        height: 150,
        width: 160,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(4, 5),
              ),
            ],
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20), bottom: Radius.zero),
                child: Image.asset(
                  "assets/images/banner.jpg",
                  height: 150,
                  width: 160,
                  fit: BoxFit.fill,
                )),
            Text(
              widget.kategorija,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                  color: Colors.red),
            ),
            Text(
              widget.naslov,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              maxLines: 1,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 0.3,
                  color: Color.fromRGBO(31, 48, 83, 1)),
            ),
            Text(
              formatDate(widget.datumOd) + " - " + formatDate(widget.datumDo),
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  letterSpacing: 0.3,
                  fontSize: 12,
                  color: Color.fromRGBO(113, 126, 148, 1)),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                Icons.location_on_outlined,
                size: 10,
                color: Color.fromRGBO(156, 156, 168, 1),
              ),
              Text(
                widget.lokacija,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    letterSpacing: 0.3,
                    color: Color.fromRGBO(156, 156, 168, 1)),
              )
            ])
          ],
        ));
  }

  String formatDate(DateTime date) {
    return date.day.toString() + "." + months[date.month - 1];
  }
}
