import 'package:eventsappadmin/widgets/master_screen.dart';
import 'package:flutter/material.dart';

class DogadjajiDetailsScreen extends StatefulWidget {
  const DogadjajiDetailsScreen({super.key});

  @override
  State<DogadjajiDetailsScreen> createState() => _DogadjajiDetailsScreenState();
}

class _DogadjajiDetailsScreenState extends State<DogadjajiDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(child: Text("Dogadjaji details"));
  }
}
