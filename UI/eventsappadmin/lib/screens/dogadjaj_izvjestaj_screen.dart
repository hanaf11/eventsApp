import 'package:eventsappadmin/widgets/master_screen.dart';
import 'package:flutter/material.dart';

class DogadjajIzvjestajScreen extends StatefulWidget {
  int? selected = 6;
  DogadjajIzvjestajScreen({this.selected, super.key});

  @override
  State<DogadjajIzvjestajScreen> createState() =>
      _DogadjajIzvjestajScreenState();
}

class _DogadjajIzvjestajScreenState extends State<DogadjajIzvjestajScreen> {
  /*final List<ChartData> chartData = [
    ChartData('David', 25, Colors.red),
    ChartData('Steve', 38, Colors.blue),
    ChartData('Jack', 34, Colors.green),
    ChartData('Others', 52, Colors.orange),
  ];*/
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
                    /* _buildEventsByCategory(),
                            _buildTop3Events(),
                            _buildMostViewedEvents(),
                            _buildMostSavedEvents()*/
                  ],
                )))));
  }

  _buildEventsByStatus() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Broj događaja po statusima",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 91, 91, 91),
          ))
    ]);
  }
}
