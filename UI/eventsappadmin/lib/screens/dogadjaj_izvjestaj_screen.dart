import 'package:eventsappadmin/models/dogadjaji_report_response.dart';
import 'package:eventsappadmin/providers/dogadjaj_provider.dart';
import 'package:eventsappadmin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:provider/provider.dart';

class DogadjajIzvjestajScreen extends StatefulWidget {
  int? selected = 6;
  List<bool> options;
  DogadjajIzvjestajScreen({this.selected, required this.options, super.key});

  @override
  State<DogadjajIzvjestajScreen> createState() =>
      _DogadjajIzvjestajScreenState();
}

class _DogadjajIzvjestajScreenState extends State<DogadjajIzvjestajScreen> {
  late DogadjajProvider _dogadjajProvider;
  DogadjajiReportResponse? result;
  bool isLoading = true;
  var basicData = [
    {'genre': 'Sports', 'sold': 275},
    {'genre': 'Strategy', 'sold': 115},
    {'genre': 'Action', 'sold': 120},
    {'genre': 'Shooter', 'sold': 350},
    {'genre': 'Other', 'sold': 150},
  ];

  _DogadjajIzvjestajScreenState();

  @override
  void initState() {
    super.initState();
    _dogadjajProvider = context.read<DogadjajProvider>();
    getData();
  }

  getData() async {
    var data = await _dogadjajProvider.getReportData(filter: {
      'EventsByStatus': widget.options[0],
      'EventsByCategory': widget.options[1],
      'TopSellingEvents': widget.options[2],
      'MostViewedEvents': widget.options[3],
      'MostSavedEvents': widget.options[4],
    });
    setState(() {
      result = data;
      isLoading = false;
    });
    print(result?.eventsByStatus);
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
                        const Text("Događaji izvještaj",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 91, 91, 91),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        result?.eventsByStatus != null
                            ? _buildEventsByStatus()
                            : Container(),
                        result?.eventsByCategory != null
                            ? _buildEventsByCategory()
                            : Container(),
                        result?.topSellingEvents != null
                            ? _buildTop3Events()
                            : Container(),
                        result?.mostViewedEvents != null
                            ? _buildMostViewedEvents()
                            : Container(),
                        result?.mostSavedEvents != null
                            ? _buildMostSavedEvents()
                            : Container(),
                      ],
                    )))));
  }

//pie
  _buildEventsByStatus() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text("Broj događaja po statusima",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 91, 91, 91),
          )),
      Container(
        margin: const EdgeInsets.only(top: 10),
        height: 350,
        child: Chart(
          // data: statusData,
          data: result!.eventsByStatus!,
          variables: {
            'status': Variable(
              accessor: (Map map) => map['status'] as String,
            ),
            'count': Variable(
              accessor: (Map map) => map['count'] as num,
            ),
          },
          transforms: [
            Proportion(
              variable: 'count',
              as: 'percent',
            )
          ],
          marks: [
            IntervalMark(
              position: Varset('percent') / Varset('status'),
              label: LabelEncode(
                  encoder: (tuple) => Label(
                        "${tuple['status']}:  ${tuple['count'].toString()}",
                      )),
              color: ColorEncode(variable: 'status', values: Defaults.colors10),
              modifiers: [StackModifier()],
            )
          ],
          coord: PolarCoord(
            transposed: true,
            dimCount: 1,
            dimFill: 1.05,
            radiusRange: [0, 0.8],
          ),
        ),
      ),
      SizedBox(
        height: 40,
      ),
    ]);
  }

  _buildEventsByCategory() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text("Broj događaja po kategorijama",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 91, 91, 91),
          )),
      Container(
        margin: const EdgeInsets.only(top: 10),
        height: 350,
        child: Chart(
          // data: statusData,
          data: result!.eventsByCategory!,
          variables: {
            'kategorija': Variable(
              accessor: (Map map) => map['kategorija'] as String,
            ),
            'count': Variable(
              accessor: (Map map) => map['count'] as num,
            ),
          },
          transforms: [
            Proportion(
              variable: 'count',
              as: 'percent',
            )
          ],
          marks: [
            IntervalMark(
              position: Varset('percent') / Varset('kategorija'),
              label: LabelEncode(
                  encoder: (tuple) => Label(
                        "${tuple['kategorija']}:  ${tuple['count'].toString()}",
                      )),
              color: ColorEncode(
                  variable: 'kategorija', values: Defaults.colors10),
              modifiers: [StackModifier()],
            )
          ],
          coord: PolarCoord(
            transposed: true,
            dimCount: 1,
            dimFill: 1.05,
            radiusRange: [0, 0.8],
          ),
        ),
      ),
      SizedBox(
        height: 40,
      ),
    ]);
  }

//double column
  _buildTop3Events() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text("Top 3 događaja s najvećim prihodom",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 91, 91, 91),
          )),
      Container(
        margin: const EdgeInsets.only(top: 10),
        // width: 350,
        height: 300,
        child: Chart(
          padding: (_) => const EdgeInsets.fromLTRB(40, 5, 10, 40),
          data: result!.topSellingEvents!,
          variables: {
            'dogadjaj': Variable(
              accessor: (Map map) => map['dogadjaj'].toString(),
            ),
            'type': Variable(
              accessor: (Map map) => map['type'] as String,
            ),
            'value': Variable(
              accessor: (Map map) => map['value'] as num,
            ),
          },
          marks: [
            IntervalMark(
              position: Varset('dogadjaj') * Varset('value') / Varset('type'),
              color: ColorEncode(variable: 'type', values: Defaults.colors10),
              size: SizeEncode(value: 2),
              modifiers: [DodgeModifier(ratio: 0.1)],
            )
          ],
          coord: RectCoord(
            horizontalRangeUpdater: Defaults.horizontalRangeEvent,
          ),
          axes: [
            Defaults.horizontalAxis..tickLine = TickLine(),
            Defaults.verticalAxis,
          ],
          selections: {
            'tap': PointSelection(
              variable: 'dogadjaj',
            )
          },
          tooltip: TooltipGuide(multiTuples: true),
          // crosshair: CrosshairGuide(),
          annotations: [
            CustomAnnotation(
                renderer: (_, size) => [
                      CircleElement(
                          center: const Offset(25, 290),
                          radius: 5,
                          style: PaintStyle(fillColor: Defaults.colors10[0]))
                    ],
                anchor: (p0) => const Offset(0, 0)),
            TagAnnotation(
              label: Label(
                'Prihod',
                LabelStyle(
                    textStyle: Defaults.textStyle,
                    align: Alignment.centerRight),
              ),
              anchor: (size) => const Offset(34, 290),
            ),
            CustomAnnotation(
                renderer: (_, size) => [
                      CircleElement(
                          center: Offset(25 + size.width / 5, 290),
                          radius: 5,
                          style: PaintStyle(fillColor: Defaults.colors10[1]))
                    ],
                anchor: (p0) => const Offset(0, 0)),
            TagAnnotation(
              label: Label(
                'Karte',
                LabelStyle(
                    textStyle: Defaults.textStyle,
                    align: Alignment.centerRight),
              ),
              anchor: (size) => Offset(34 + size.width / 5, 290),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 40,
      ),
    ]);
  }

//column
  _buildMostViewedEvents() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text("Top 3 događaja s najviše pregleda",
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
          data: basicData,
          variables: {
            'genre': Variable(
              accessor: (Map map) => map['genre'] as String,
            ),
            'sold': Variable(
              accessor: (Map map) => map['sold'] as num,
            ),
          },
          marks: [
            IntervalMark(
              label: LabelEncode(
                  encoder: (tuple) => Label(tuple['sold'].toString())),
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

  _buildMostSavedEvents() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text("Top 3 najviše sačuvanih događaja",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 91, 91, 91),
          )),
      Container(
        margin: const EdgeInsets.only(top: 10),
        //    width: 350,
        height: 350,
        child: Chart(
          data: result!.mostSavedEvents!,
          variables: {
            'dogadjaj': Variable(
              accessor: (Map map) => map['dogadjaj'] as String,
            ),
            'count': Variable(
              accessor: (Map map) => map['count'] as num,
            ),
          },
          marks: [
            IntervalMark(
              label: LabelEncode(
                  encoder: (tuple) => Label(tuple['count'].toString())),
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
