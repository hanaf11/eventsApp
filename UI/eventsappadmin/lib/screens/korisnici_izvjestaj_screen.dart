import 'package:eventsappadmin/models/korisnici_report_response.dart';
import 'package:eventsappadmin/providers/korisnik_provider.dart';
import 'package:eventsappadmin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
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
                          const Text("Korisnici izvještaj",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 91, 91, 91),
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          result?.numberOfRegistered != null
                              ? _buildRegistered()
                              : Container(),
                          result?.mostOrdersUsers != null
                              ? _buildMostOrdersUsers()
                              : Container(),
                          result?.mostActiveUsers != null
                              ? _buildMostActiveUsers()
                              : Container(),
                          result?.mostSubscribedCategories != null
                              ? _buildMostSubscribedCategories()
                              : Container(),
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
      Container(
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
                  encoder: (tuple) => Label(tuple['komentari'].toString())),
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
