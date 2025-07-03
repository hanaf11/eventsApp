import 'package:eventsappusers/models/dogadjaj.dart';
import 'package:eventsappusers/models/korisnik_global.dart';
import 'package:eventsappusers/providers/saving_provider.dart';
import 'package:eventsappusers/screens/event_details_screen.dart';
import 'package:eventsappusers/utils/category_color_util.dart';
import 'package:eventsappusers/utils/formatting_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DogadjajHorizontalWidget extends StatefulWidget {
  Dogadjaj dogadjaj;
  Function? reloadPage;

  DogadjajHorizontalWidget(
      {super.key, required this.dogadjaj, this.reloadPage});

  @override
  State<DogadjajHorizontalWidget> createState() =>
      _DogadjajHorizontalWidgetState();
}

class _DogadjajHorizontalWidgetState extends State<DogadjajHorizontalWidget> {
  //_DogadjajHorizontalWidgetState();
  bool saved = false;
  bool isLoading = true;
  late SavingProvider _savingProvider;

  _DogadjajHorizontalWidgetState();

  Future<void> navigateToEventDetails() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              EventDetailsScreen(dogadjajId: widget.dogadjaj.dogadjajId!)),
    );
    print("resukt je $result");
    if (result == true) {
      loadData();
    }
  }

  @override
  void initState() {
    super.initState();
    _savingProvider = context.read<SavingProvider>();
    loadData();
  }

  void loadData() {
    _savingProvider.isSaved({
      'DogadjajId': widget.dogadjaj.dogadjajId,
      'KorisnikId': KorisnikGlobal.korisnikId
    }).then((value) {
      setState(() {
        saved = value;
        isLoading = false;
      });
    });
    if (widget.reloadPage != null) {
      widget.reloadPage!();
    }
  }

  Future<void> _savedClicked() async {
    bool? value;
    var request = {
      "DogadjajId": widget.dogadjaj.dogadjajId,
      "KorisnikId": KorisnikGlobal.korisnikId
    };
    try {
      if (!saved) {
        value = await _savingProvider.save(request);
      } else {
        value = await _savingProvider.delete(request);
      }
    } on Exception catch (e) {
      handleException(e);
    }
    setState(() {
      saved = value ?? saved;
    });
    if (widget.reloadPage != null) {
      widget.reloadPage!();
    }
  }

  void handleException(Exception e) {
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
        child: isLoading
            ? Container(child: Center(child: const CircularProgressIndicator()))
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                    SizedBox(
                        width: 140,
                        height: 130,
                        child: InkWell(
                            onTap: () async {
                              navigateToEventDetails();
                            },
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: imageFromBase64String(
                                    widget.dogadjaj.naslovna)))),
                    Expanded(
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.58,
                                      child: InkWell(
                                          onTap: () async {
                                            navigateToEventDetails();
                                          },
                                          child: Text(
                                            widget.dogadjaj.naziv ?? '',
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            maxLines: 3,
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    31, 48, 83, 1),
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: 1.0,
                                                fontSize: 16),
                                          ))),
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
                                                      "${dayAndMonth(widget
                                                                  .dogadjaj
                                                                  .datumOd ??
                                                              DateTime.now())} - ${dayAndMonth(widget
                                                                  .dogadjaj
                                                                  .datumDo ??
                                                              DateTime.now())}",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              113, 126, 148, 1),
                                                          fontFamily:
                                                              'Montserrat',
                                                          letterSpacing: 1,
                                                          fontSize: 12),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .location_on_outlined,
                                                          size: 10,
                                                          color: Color.fromRGBO(
                                                              156, 156, 168, 1),
                                                        ),
                                                        Expanded(
                                                            child: Text(
                                                          widget.dogadjaj
                                                                  .lokacija ??
                                                              '',
                                                          textAlign:
                                                              TextAlign.start,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          softWrap: false,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      156,
                                                                      156,
                                                                      168,
                                                                      1),
                                                              fontFamily:
                                                                  'Montserrat',
                                                              letterSpacing: 1,
                                                              fontSize: 12),
                                                        )),
                                                      ],
                                                    ),
                                                    _buildKategorija()
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
                                                      _savedClicked();
                                                    },
                                                    isSelected: saved,
                                                    selectedIcon: const Icon(
                                                        Icons.bookmark_sharp),
                                                    icon: const Icon(
                                                        Icons.bookmark_border),
                                                    color: Color.fromRGBO(
                                                        31, 48, 83, 1),
                                                    iconSize: 22,
                                                  ),
                                                  IconButton(
                                                    onPressed: () async {
                                                      navigateToEventDetails();
                                                    },
                                                    icon: const Icon(
                                                        Icons.arrow_forward),
                                                    color: Color.fromRGBO(
                                                        31, 48, 83, 1),
                                                    iconSize: 22,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ))),
                                ]))),
                  ]));
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
}
