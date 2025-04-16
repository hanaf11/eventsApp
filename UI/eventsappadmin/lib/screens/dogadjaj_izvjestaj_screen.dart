import 'package:eventsappadmin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

class DogadjajIzvjestajScreen extends StatefulWidget {
  int? selected = 6;
  DogadjajIzvjestajScreen({this.selected, super.key});

  @override
  State<DogadjajIzvjestajScreen> createState() =>
      _DogadjajIzvjestajScreenState();
}

class _DogadjajIzvjestajScreenState extends State<DogadjajIzvjestajScreen> {
  var basicData = [
    {'genre': 'Sports', 'sold': 275},
    {'genre': 'Strategy', 'sold': 115},
    {'genre': 'Action', 'sold': 120},
    {'genre': 'Shooter', 'sold': 350},
    {'genre': 'Other', 'sold': 150},
  ];
  var adjustData = [
    {"type": "Email", "index": 0, "value": 120},
    {"type": "Email", "index": 1, "value": 132},
    {"type": "Email", "index": 2, "value": 101},
    {"type": "Email", "index": 3, "value": 134},
    {"type": "Email", "index": 4, "value": 90},
    {"type": "Email", "index": 5, "value": 230},
    {"type": "Email", "index": 6, "value": 210},
    {"type": "Affiliate", "index": 0, "value": 220},
    {"type": "Affiliate", "index": 1, "value": 182},
    {"type": "Affiliate", "index": 2, "value": 191},
    {"type": "Affiliate", "index": 3, "value": 234},
    {"type": "Affiliate", "index": 4, "value": 290},
    {"type": "Affiliate", "index": 5, "value": 330},
    {"type": "Affiliate", "index": 6, "value": 310},
    {"type": "Video", "index": 0, "value": 150},
    {"type": "Video", "index": 1, "value": 232},
    {"type": "Video", "index": 2, "value": 201},
    {"type": "Video", "index": 3, "value": 154},
    {"type": "Video", "index": 4, "value": 190},
    {"type": "Video", "index": 5, "value": 330},
    {"type": "Video", "index": 6, "value": 410},
    {"type": "Direct", "index": 0, "value": 320},
    {"type": "Direct", "index": 1, "value": 332},
    {"type": "Direct", "index": 2, "value": 301},
    {"type": "Direct", "index": 3, "value": 334},
    {"type": "Direct", "index": 4, "value": 390},
    {"type": "Direct", "index": 5, "value": 330},
    {"type": "Direct", "index": 6, "value": 320},
    {"type": "Search", "index": 0, "value": 320},
    {"type": "Search", "index": 1, "value": 432},
    {"type": "Search", "index": 2, "value": 401},
    {"type": "Search", "index": 3, "value": 434},
    {"type": "Search", "index": 4, "value": 390},
    {"type": "Search", "index": 5, "value": 430},
    {"type": "Search", "index": 6, "value": 420},
  ];
  _DogadjajIzvjestajScreenState();

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        selectedIndex: widget.selected,
        child: Expanded(
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
                    _buildEventsByStatus(),
                    // _buildEventsByCategory(),
                    _buildTop3Events(),
                    _buildMostViewedEvents(),
                    // _buildMostSavedEvents()
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
          transforms: [
            Proportion(
              variable: 'sold',
              as: 'percent',
            )
          ],
          marks: [
            IntervalMark(
              position: Varset('percent') / Varset('genre'),
              label: LabelEncode(
                  encoder: (tuple) => Label(
                        "${tuple['genre']}:  ${tuple['sold'].toString()}",
                      )),
              color: ColorEncode(variable: 'genre', values: Defaults.colors10),
              modifiers: [StackModifier()],
            )
          ],
          coord: PolarCoord(transposed: true, dimCount: 1, dimFill: 1.05),
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
      Text("Top 3 događaja s najviše prodanih karata",
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
          data: adjustData,
          variables: {
            'index': Variable(
              accessor: (Map map) => map['index'].toString(),
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
              position: Varset('index') * Varset('value') / Varset('type'),
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
              variable: 'index',
            )
          },
          tooltip: TooltipGuide(multiTuples: true),
          crosshair: CrosshairGuide(),
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
                'Email',
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
                'Affiliate',
                LabelStyle(
                    textStyle: Defaults.textStyle,
                    align: Alignment.centerRight),
              ),
              anchor: (size) => Offset(34 + size.width / 5, 290),
            ),
            CustomAnnotation(
                renderer: (_, size) => [
                      CircleElement(
                          center: Offset(25 + size.width / 5 * 2, 290),
                          radius: 5,
                          style: PaintStyle(fillColor: Defaults.colors10[2]))
                    ],
                anchor: (p0) => const Offset(0, 0)),
            TagAnnotation(
              label: Label(
                'Video',
                LabelStyle(
                    textStyle: Defaults.textStyle,
                    align: Alignment.centerRight),
              ),
              anchor: (size) => Offset(34 + size.width / 5 * 2, 290),
            ),
            CustomAnnotation(
                renderer: (_, size) => [
                      CircleElement(
                          center: Offset(25 + size.width / 5 * 3, 290),
                          radius: 5,
                          style: PaintStyle(fillColor: Defaults.colors10[3]))
                    ],
                anchor: (p0) => const Offset(0, 0)),
            TagAnnotation(
              label: Label(
                'Direct',
                LabelStyle(
                    textStyle: Defaults.textStyle,
                    align: Alignment.centerRight),
              ),
              anchor: (size) => Offset(34 + size.width / 5 * 3, 290),
            ),
            CustomAnnotation(
                renderer: (_, size) => [
                      CircleElement(
                          center: Offset(25 + size.width / 5 * 4, 290),
                          radius: 5,
                          style: PaintStyle(fillColor: Defaults.colors10[4]))
                    ],
                anchor: (p0) => const Offset(0, 0)),
            TagAnnotation(
              label: Label(
                'Search',
                LabelStyle(
                    textStyle: Defaults.textStyle,
                    align: Alignment.centerRight),
              ),
              anchor: (size) => Offset(34 + size.width / 5 * 4, 290),
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
}
