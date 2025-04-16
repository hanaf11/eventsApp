import 'package:eventsappadmin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:intl/intl.dart';

final _monthDayFormat = DateFormat('MM-dd');

class NarudzbeIzvjestajScreen extends StatefulWidget {
  int? selected = 6;
  NarudzbeIzvjestajScreen({this.selected, super.key});

  @override
  State<NarudzbeIzvjestajScreen> createState() =>
      _NarudzbeIzvjestajScreenState();
}

class _NarudzbeIzvjestajScreenState extends State<NarudzbeIzvjestajScreen> {
  var timeSeriesSales = [
    TimeSeriesSales(DateTime(2017, 9, 19), 5),
    TimeSeriesSales(DateTime(2017, 9, 26), 25),
    TimeSeriesSales(DateTime(2017, 10, 3), 100),
    TimeSeriesSales(DateTime(2017, 10, 10), 75),
  ];
  _NarudzbeIzvjestajScreenState();

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
                      _buildSalesGraph(),
                    ])))));
  }

  _buildSalesGraph() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text("Prodaja karata",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 91, 91, 91),
          )),
      Container(
        margin: const EdgeInsets.only(top: 10),
        //width: 350,
        height: 300,
        child: Chart(
          data: timeSeriesSales,
          variables: {
            'time': Variable(
              accessor: (TimeSeriesSales datum) => datum.time,
              scale: TimeScale(
                formatter: (time) => _monthDayFormat.format(time),
              ),
            ),
            'sales': Variable(
              accessor: (TimeSeriesSales datum) => datum.sales,
            ),
          },
          marks: [
            LineMark(
              shape: ShapeEncode(value: BasicLineShape(dash: [5, 2])),
              selected: {
                'touchMove': {1}
              },
            )
          ],
          coord: RectCoord(color: const Color(0xffdddddd)),
          axes: [
            Defaults.horizontalAxis,
            Defaults.verticalAxis,
          ],
          selections: {
            'touchMove': PointSelection(
              on: {
                GestureType.scaleUpdate,
                GestureType.tapDown,
                GestureType.longPressMoveUpdate
              },
              dim: Dim.x,
            )
          },
          tooltip: TooltipGuide(
            followPointer: [false, true],
            align: Alignment.topLeft,
            offset: const Offset(-20, -20),
          ),
          crosshair: CrosshairGuide(followPointer: [false, true]),
        ),
      ),
      SizedBox(
        height: 40,
      ),
    ]);
  }
}

class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}
