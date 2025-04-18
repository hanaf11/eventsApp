import 'package:eventsappadmin/models/narudzbe_report_response.dart';
import 'package:eventsappadmin/providers/narudzba_provider.dart';
import 'package:eventsappadmin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

final _monthDayFormat = DateFormat('MM-dd');

class NarudzbeIzvjestajScreen extends StatefulWidget {
  int? selected = 6;
  List<bool> options;
  NarudzbeIzvjestajScreen({this.selected, required this.options, super.key});

  @override
  State<NarudzbeIzvjestajScreen> createState() =>
      _NarudzbeIzvjestajScreenState();
}

class _NarudzbeIzvjestajScreenState extends State<NarudzbeIzvjestajScreen> {
  late NarudzbaProvider _narudzbaProvider;
  NarudzbeReportResponse? result;
  bool isLoading = true;
  _NarudzbeIzvjestajScreenState();

  @override
  void initState() {
    super.initState();
    _narudzbaProvider = context.read<NarudzbaProvider>();
    getData();
  }

  getData() async {
    var data = await _narudzbaProvider.getReportData(filter: {
      'NumOfOrders': widget.options[0],
      'Revenue': widget.options[1],
      'NumOfSoldTickets': widget.options[2],
      'MostSoldEvents': widget.options[3],
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
                          const Text("Narudžbe izvještaj",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 91, 91, 91),
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          result?.numOfOrders != null
                              ? _buildNumOfOrders()
                              : Container(),
                          result?.revenue != null
                              ? _buildRevenue()
                              : Container(),
                          result?.numOfSoldTickets != null
                              ? _buildNumOfSoldTickets()
                              : Container(),
                          result?.mostSoldEvents != null
                              ? _buildMostSoldEvents()
                              : Container(),
                        ])))));
  }

  _buildNumOfOrders() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text("Broj narudžbi u zadnjih mjesec dana",
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
          data: result!.numOfOrders!,
          variables: {
            'time': Variable(
              accessor: (Map map) => map['time'] as String,
            ),
            'narudzbe': Variable(
              accessor: (Map map) => map['narudzbe'] as num,
            ),
          },
          marks: [
            IntervalMark(
              label: LabelEncode(
                  encoder: (tuple) => Label(tuple['narudzbe'].toString())),
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

  _buildRevenue() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text("Zarada u zadnjih mjesec dana",
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
          data: result!.revenue!,
          variables: {
            'time': Variable(
              accessor: (Map map) => map['time'] as String,
            ),
            'revenue': Variable(
              accessor: (Map map) => map['revenue'] as num,
            ),
          },
          marks: [
            IntervalMark(
              label: LabelEncode(
                  encoder: (tuple) => Label(tuple['revenue'].toString())),
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

  _buildNumOfSoldTickets() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text("Broj prodanih karata u zadnjih mjesec dana",
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
          data: result!.numOfSoldTickets!,
          variables: {
            'time': Variable(
              accessor: (Map map) => map['time'] as String,
            ),
            'tickets': Variable(
              accessor: (Map map) => map['tickets'] as num,
            ),
          },
          marks: [
            IntervalMark(
              label: LabelEncode(
                  encoder: (tuple) => Label(tuple['tickets'].toString())),
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

  _buildMostSoldEvents() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text("Top 3 događaja s najviše prodanih karata",
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
          data: result!.mostSoldEvents!,
          variables: {
            'dogadjaj': Variable(
              accessor: (Map map) => map['dogadjaj'] as String,
            ),
            'tickets': Variable(
              accessor: (Map map) => map['tickets'] as num,
            ),
          },
          marks: [
            IntervalMark(
              label: LabelEncode(
                  encoder: (tuple) => Label(tuple['tickets'].toString())),
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
