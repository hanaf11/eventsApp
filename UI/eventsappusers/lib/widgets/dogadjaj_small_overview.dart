import 'package:eventsappusers/utils/formatting_util.dart';
import 'package:flutter/material.dart';

class DogadjajSmallOverview extends StatelessWidget {
  final String naziv;
  final DateTime datumOd;
  final List? tickets;
  final double? ukupno;

  DogadjajSmallOverview(
      {required this.naziv,
      required this.datumOd,
      this.tickets,
      this.ukupno,
      super.key});

  final List months = [
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox.fromSize(
              size: Size.fromRadius(60),
              child: Image.asset('assets/images/banner.jpg', fit: BoxFit.cover),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                naziv,
                style: TextStyle(
                    color: Color.fromRGBO(60, 71, 92, 1),
                    letterSpacing: 0.3,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w800,
                    fontSize: 14),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.access_alarm_outlined,
                    color: Color.fromRGBO(60, 71, 92, 1),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    datumOd.day.toString() +
                        "." +
                        months[datumOd.month - 1] +
                        " " +
                        datumOd.year.toString(),
                    style: TextStyle(
                        color: Color.fromRGBO(60, 71, 92, 1),
                        fontSize: 14,
                        letterSpacing: 0.7,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              tickets == null || tickets!.isEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Color.fromRGBO(60, 71, 92, 1),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Pozoriste Mladih Sarajevo",
                          style: TextStyle(
                              color: Color.fromRGBO(60, 71, 92, 1),
                              fontSize: 13,
                              letterSpacing: 0.7,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    )
                  : _buildTicketsContainer()
            ],
          ))
        ],
      ),
    );
  }

  _buildTicketsContainer() {
    return Column(
      children: [
        _buildTickets(),
        const Divider(
          height: 20,
          thickness: 1,
          indent: 0,
          endIndent: 0,
          color: Color.fromARGB(255, 144, 143, 143),
        ),
        Align(
            alignment: Alignment.centerRight,
            child: Text(
              formatNumber(ukupno),
              style: TextStyle(
                  color: Color.fromRGBO(60, 71, 92, 1),
                  fontSize: 13,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w800),
            ))
      ],
    );
  }

  _buildTickets() {
    return Column(
      children:
          tickets?.map((e) => _buildTicketGroup(e)).toList().cast<Widget>() ??
              [],
    );
  }

  _buildTicketGroup(ticketGroup) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          ticketGroup['naziv'],
          style: TextStyle(
              color: Color.fromRGBO(60, 71, 92, 1),
              fontSize: 13,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w800),
        ),
        Text(
          "x${ticketGroup['kolicina']}",
          style: TextStyle(
              color: Color.fromRGBO(60, 71, 92, 1),
              fontSize: 13,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w800),
        )
      ],
    );
  }
}
