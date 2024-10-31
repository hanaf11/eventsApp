import 'dart:convert';
import 'dart:typed_data';

import 'package:eventsappusers/utils/formatting_util.dart';
import 'package:flutter/material.dart';

class DogadjajSmallOverview extends StatefulWidget {
  final String naziv;
  final DateTime datumOd;
  final List? tickets;
  final double? ukupno;
  final String? lokacija;
  final String? naslovna;
  final String? lokacijaSlika;

  DogadjajSmallOverview(
      {required this.naziv,
      required this.datumOd,
      this.tickets,
      this.ukupno,
      this.lokacija,
      this.naslovna,
      this.lokacijaSlika,
      // this.naslovnaImg,
      super.key});

  @override
  _DogadjajSmallOverviewState createState() => _DogadjajSmallOverviewState();
}

class _DogadjajSmallOverviewState extends State<DogadjajSmallOverview> {
  bool naslovnaLoaded = false;
  Image? naslovnaImage;

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  Future<void> loadImage() async {
    if (widget.naslovna != null) {
      try {
        final img = Image.memory(
          base64Decode(widget.naslovna!),
          fit: BoxFit.cover,
        );
        setState(() {
          naslovnaImage = img;
          naslovnaLoaded = true;
        });
      } catch (e) {
        print("Error decoding Base64 image: $e");
        setState(() {
          naslovnaImage =
              Image.asset('assets/images/no_picture.jpg', fit: BoxFit.cover);
          naslovnaLoaded = true;
        });
      }
    } else {
      setState(() {
        naslovnaImage =
            Image.asset('assets/images/no_picture.jpg', fit: BoxFit.cover);
        naslovnaLoaded = true;
      });
    }
  }

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
              child: naslovnaLoaded
                  ? naslovnaImage
                  : const CircularProgressIndicator(),
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
                widget.naziv,
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
                  Text(formatDate(widget.datumOd))
                ],
              ),
              SizedBox(
                height: 5,
              ),
              widget.tickets == null || widget.tickets!.isEmpty
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
                          widget.lokacija ?? '',
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
              formatNumber(widget.ukupno),
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
      children: widget.tickets
              ?.map((e) => _buildTicketGroup(e))
              .toList()
              .cast<Widget>() ??
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
