import 'package:eventsappadmin/providers/dogadjaj_provider.dart';
import 'package:eventsappadmin/screens/dogadjaj_details_screen.dart';
import 'package:eventsappadmin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DogadjajiListScreen extends StatefulWidget {
  const DogadjajiListScreen({super.key});

  @override
  State<DogadjajiListScreen> createState() => _DogadjajiListScreenState();
}

class _DogadjajiListScreenState extends State<DogadjajiListScreen> {
  late DogadjajProvider _dogadjajProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dogadjajProvider = context.read<DogadjajProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Container(
        child: ElevatedButton(
          child: Text("Get"),
          onPressed: () async {
            var data = await _dogadjajProvider.get();
            print("data ${data['result'][0]['naziv']}");
          },
        ),
      ),
    );
  }
}
