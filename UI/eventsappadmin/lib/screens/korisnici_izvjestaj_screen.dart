import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:eventsappadmin/models/korisnici_report_response.dart';
import 'package:eventsappadmin/providers/korisnik_provider.dart';
import 'package:eventsappadmin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphic/graphic.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

class KorisniciIzvjestajScreen extends StatefulWidget {
  int? selected = 6;
  List<bool> options;
  KorisniciIzvjestajScreen({this.selected, required this.options, super.key});

  @override
  State<KorisniciIzvjestajScreen> createState() =>
      _KorisniciIzvjestajScreenState();
}

class _KorisniciIzvjestajScreenState extends State<KorisniciIzvjestajScreen> {
  late KorisnikProvider _korisnikProvider;
  KorisniciReportResponse? result;
  bool isLoading = true;

  final GlobalKey _numberOfRegisteredKey = GlobalKey();
  final GlobalKey _mostOrdersUsersKey = GlobalKey();
  final GlobalKey _mostActiveUsersKey = GlobalKey();
  final GlobalKey _mostSubscribedCategoriesKey = GlobalKey();

  _KorisniciIzvjestajScreenState();

  @override
  void initState() {
    super.initState();
    _korisnikProvider = context.read<KorisnikProvider>();
    getData();
  }

  getData() async {
    var data = await _korisnikProvider.getReportData(filter: {
      'NumberOfRegistered': widget.options[0],
      'MostOrdersUsers': widget.options[1],
      'MostActiveUsers': widget.options[2],
      'MostSubscribedCategories': widget.options[3],
    });
    setState(() {
      result = data;
      isLoading = false;
    });
  }

  Future<Uint8List> _captureWidgetAsImage(GlobalKey key) async {
    // find the RenderRepaintBoundary
    RenderRepaintBoundary boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;

    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> exportPdf() async {
    print("export kliknut");
    try {
      final pdf = pw.Document();

      var keysList = [];
      var chartImagesList = [];
      if (result?.numberOfRegistered != null)
        keysList.add(_numberOfRegisteredKey);
      if (result?.mostOrdersUsers != null) keysList.add(_mostOrdersUsersKey);
      if (result?.mostActiveUsers != null) keysList.add(_mostActiveUsersKey);
      if (result?.mostSubscribedCategories != null)
        keysList.add(_mostSubscribedCategoriesKey);

      for (var key in keysList) {
        var imageBytes = await _captureWidgetAsImage(key);
        var pwImage = pw.MemoryImage(imageBytes);
        chartImagesList.add(pwImage);
      }

      pdf.addPage(
        pw.MultiPage(
          build: (context) {
            List<pw.Widget> widgets = [];

            // Add the header
            widgets.add(
              pw.Center(
                  child: pw.Text(
                "Korisnici izvjestaj",
                style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor(0.5, 0.5, 0.5)),
              )),
            );
            widgets.add(
                pw.SizedBox(height: 20)); // Space between header and content

            // Add the charts
            for (var chart in chartImagesList) {
              widgets.add(pw.Center(child: pw.Image(chart)));
              widgets
                  .add(pw.SizedBox(height: 20)); // Add spacing between charts
            }

            return widgets;
          },
        ),
      );

      // Save or share the PDF
      final outputDir = await getDownloadsDirectory();
      if (outputDir == null) {
        throw Exception("Error: Downloads directory could not be found");
      }

      var dateNow = DateTime.now();
      final outputPath =
          "${outputDir.path}\\KorisniciReport-${dateNow.day}${dateNow.month}${dateNow.year}.pdf";

      final pdfFile = File(outputPath);
      await pdfFile.writeAsBytes(await pdf.save());
      showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Successful'),
        content: Text("PDF je spašen na: ${outputPath}"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    }
    // Optionally open the file or inform the user
    catch (e) {
      print("Error while exporting PDF: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        selectedIndex: widget.selected,
        child: isLoading
            ? Expanded(
                child: Container(
                    child: Center(child: const CircularProgressIndicator())))
            : Expanded(
                child: Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Korisnici izvještaj",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 91, 91, 91),
                                    )),
                                IconButton(
                                    onPressed: exportPdf,
                                    tooltip: "Download pdf",
                                    icon: Icon(
                                      Icons.download,
                                      color: Colors.grey,
                                    ))
                              ]),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                result?.numberOfRegistered != null
                                    ? RepaintBoundary(
                                        key: _numberOfRegisteredKey,
                                        child: _buildRegistered())
                                    : Container(),
                                result?.mostOrdersUsers != null
                                    ? RepaintBoundary(
                                        key: _mostOrdersUsersKey,
                                        child: _buildMostOrdersUsers())
                                    : Container(),
                                result?.mostActiveUsers != null
                                    ? RepaintBoundary(
                                        key: _mostActiveUsersKey,
                                        child: _buildMostActiveUsers())
                                    : Container(),
                                result?.mostSubscribedCategories != null
                                    ? RepaintBoundary(
                                        key: _mostSubscribedCategoriesKey,
                                        child: _buildMostSubscribedCategories())
                                    : Container(),
                              ])
                        ])))));
  }

//bar
  _buildRegistered() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text("Broj registrovanih korisnika",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 91, 91, 91),
          )),
      Container(
        margin: const EdgeInsets.only(top: 10),
        //  width: 350,
        height: 300,
        child: Chart(
          data: result!.numberOfRegistered!,
          variables: {
            'time': Variable(
              accessor: (Map map) => map['time'] as String,
            ),
            'registered': Variable(
              accessor: (Map map) => map['registered'] as num,
            ),
          },
          marks: [
            IntervalMark(
              label: LabelEncode(
                  encoder: (tuple) => Label(tuple['registered'].toString())),
              gradient: GradientEncode(
                  value: const LinearGradient(colors: [
                    Color(0x8883bff6),
                    Color(0x88188df0),
                    Color(0xcc188df0),
                  ], stops: [
                    0,
                    0.5,
                    1
                  ]),
                  updaters: {
                    'tap': {
                      true: (_) => const LinearGradient(colors: [
                            Color(0xee83bff6),
                            Color(0xee3f78f7),
                            Color(0xff3f78f7),
                          ], stops: [
                            0,
                            0.7,
                            1
                          ])
                    }
                  }),
            )
          ],
          coord: RectCoord(transposed: true),
          axes: [
            Defaults.verticalAxis
              ..line = Defaults.strokeStyle
              ..grid = null,
            Defaults.horizontalAxis
              ..line = null
              ..grid = Defaults.strokeStyle,
          ],
          selections: {'tap': PointSelection(dim: Dim.x)},
        ),
      ),
      SizedBox(
        height: 40,
      ),
    ]);
  }

  _buildMostOrdersUsers() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text("Top 3 korisnika s najviše narudžbi",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 91, 91, 91),
          )),
      Container(
        margin: const EdgeInsets.only(top: 10),
        //    width: 350,
        height: 300,
        child: Chart(
          data: result!.mostOrdersUsers!,
          variables: {
            'korisnik': Variable(
              accessor: (Map map) => map['korisnik'] as String,
            ),
            'narudzbe': Variable(
              accessor: (Map map) => map['narudzbe'] as num,
            ),
          },
          marks: [
            IntervalMark(
              label: LabelEncode(
                  encoder: (tuple) => Label(tuple['narudzbe'].toString())),
              elevation: ElevationEncode(value: 0, updaters: {
                'tap': {true: (_) => 5}
              }),
              color: ColorEncode(value: Defaults.primaryColor, updaters: {
                'tap': {false: (color) => color.withAlpha(100)}
              }),
            )
          ],
          axes: [
            Defaults.horizontalAxis,
            Defaults.verticalAxis,
          ],
          selections: {'tap': PointSelection(dim: Dim.x)},
          tooltip: TooltipGuide(),
          crosshair: CrosshairGuide(),
        ),
      ),
      SizedBox(
        height: 40,
      ),
    ]);
  }

  _buildMostActiveUsers() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text("Top 3 najaktivnijih korisnika",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 91, 91, 91),
          )),
      (result?.mostActiveUsers == null || result!.mostActiveUsers!.isEmpty)
          ? Center(child: Text("Nema dovoljno podataka"))
          : Container(
              margin: const EdgeInsets.only(top: 10),
              //    width: 350,
              height: 300,
              child: Chart(
                data: result!.mostActiveUsers!,
                variables: {
                  'korisnik': Variable(
                    accessor: (Map map) => map['korisnik'] as String,
                  ),
                  'komentari': Variable(
                    accessor: (Map map) => map['komentari'] as num,
                  ),
                },
                marks: [
                  IntervalMark(
                    label: LabelEncode(
                        encoder: (tuple) =>
                            Label(tuple['komentari'].toString())),
                    elevation: ElevationEncode(value: 0, updaters: {
                      'tap': {true: (_) => 5}
                    }),
                    color: ColorEncode(value: Defaults.primaryColor, updaters: {
                      'tap': {false: (color) => color.withAlpha(100)}
                    }),
                  )
                ],
                axes: [
                  Defaults.horizontalAxis,
                  Defaults.verticalAxis,
                ],
                selections: {'tap': PointSelection(dim: Dim.x)},
                tooltip: TooltipGuide(),
                crosshair: CrosshairGuide(),
              ),
            ),
      SizedBox(
        height: 40,
      ),
    ]);
  }

  _buildMostSubscribedCategories() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text("Top 3 kategorije događaja prema broju pratilaca",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 91, 91, 91),
          )),
      Container(
        margin: const EdgeInsets.only(top: 10),
        //    width: 350,
        height: 300,
        child: Chart(
          data: result!.mostSubscribedCategories!,
          variables: {
            'kategorija': Variable(
              accessor: (Map map) => map['kategorija'] as String,
            ),
            'subscribers': Variable(
              accessor: (Map map) => map['subscribers'] as num,
            ),
          },
          marks: [
            IntervalMark(
              label: LabelEncode(
                  encoder: (tuple) => Label(tuple['subscribers'].toString())),
              elevation: ElevationEncode(value: 0, updaters: {
                'tap': {true: (_) => 5}
              }),
              color: ColorEncode(value: Defaults.primaryColor, updaters: {
                'tap': {false: (color) => color.withAlpha(100)}
              }),
            )
          ],
          axes: [
            Defaults.horizontalAxis,
            Defaults.verticalAxis,
          ],
          selections: {'tap': PointSelection(dim: Dim.x)},
          tooltip: TooltipGuide(),
          crosshair: CrosshairGuide(),
        ),
      ),
      SizedBox(
        height: 40,
      ),
    ]);
  }
}
