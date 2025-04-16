import 'package:eventsappadmin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

class KorisniciIzvjestajScreen extends StatefulWidget {
  int? selected = 6;
  KorisniciIzvjestajScreen({this.selected, super.key});

  @override
  State<KorisniciIzvjestajScreen> createState() =>
      _KorisniciIzvjestajScreenState();
}

class _KorisniciIzvjestajScreenState extends State<KorisniciIzvjestajScreen> {
  var basicData = [
    {'genre': 'Sports', 'sold': 275},
    {'genre': 'Strategy', 'sold': 115},
    {'genre': 'Action', 'sold': 120},
    {'genre': 'Shooter', 'sold': 350},
    {'genre': 'Other', 'sold': 150},
  ];
  _KorisniciIzvjestajScreenState();

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
                      _buildRegistered(),
                    ])))));
  }

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
}
