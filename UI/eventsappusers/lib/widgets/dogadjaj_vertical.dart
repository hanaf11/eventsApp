import 'package:eventsappusers/models/dogadjaj.dart';
import 'package:eventsappusers/screens/event_details_screen.dart';
import 'package:eventsappusers/utils/category_color_util.dart';
import 'package:eventsappusers/utils/formatting_util.dart';
import 'package:flutter/material.dart';

class DogadjajVerticalWidget extends StatefulWidget {
  Dogadjaj dogadjaj;

  DogadjajVerticalWidget({super.key, required this.dogadjaj});

  @override
  State<DogadjajVerticalWidget> createState() => _DogadjajVerticalWidgetState();
}

class _DogadjajVerticalWidgetState extends State<DogadjajVerticalWidget> {
  _DogadjajVerticalWidgetState();

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
            SizedBox(
                height: 150,
                width: 160,
                child: InkWell(
                    onTap: () async {
                      navigateToEventDetails();
                    },
                    child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20), bottom: Radius.zero),
                        child: SizedBox(
                          height: 150,
                          width: 160,
                          child:
                              imageFromBase64String(widget.dogadjaj.naslovna),
                        )))),
            _buildKategorija(),
            InkWell(
                onTap: () async {
                  navigateToEventDetails();
                },
                child: Text(
                  widget.dogadjaj.naziv ?? '',
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  maxLines: 1,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 0.3,
                      color: Color.fromRGBO(31, 48, 83, 1)),
                )),
            Text(
              dayAndMonth(widget.dogadjaj.datumOd ?? DateTime.now()) +
                  " - " +
                  dayAndMonth(widget.dogadjaj.datumDo ?? DateTime.now()),
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
              Flexible(
                  child: Text(
                widget.dogadjaj.lokacija ?? '',
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                maxLines: 1,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    letterSpacing: 0.3,
                    color: Color.fromRGBO(156, 156, 168, 1)),
              ))
            ])
          ],
        ));
  }

  Text _buildKategorija() {
    Color categoryColor = CategoryColorManager()
        .getColorForCategory(widget.dogadjaj.kategorija!.kategorijaId!);
    return Text(
      widget.dogadjaj.kategorija?.naziv ?? '',
      textAlign: TextAlign.start,
      style: TextStyle(
          color: categoryColor,
          fontFamily: 'Montserrat',
          letterSpacing: 1,
          fontSize: 10,
          fontWeight: FontWeight.w800),
    );
  }

  navigateToEventDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              EventDetailsScreen(dogadjajId: widget.dogadjaj.dogadjajId!)),
    );
  }
}
