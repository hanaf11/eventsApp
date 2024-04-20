import 'package:eventsappusers/utils/util.dart';
import 'package:eventsappusers/widgets/heading_widget.dart';
import 'package:eventsappusers/widgets/master_screen.dart';
import 'package:flutter/material.dart';

class KategorijeScreen extends StatelessWidget {
  const KategorijeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var isLoading = false;
    return MasterScreen(
        selectedIndex: 0,
        showBackButton: true,
        child: Expanded(
            child: isLoading
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      HeadingWidget(text: "Odaberite kategoriju"),
                      Container(
                        height: 10,
                      ),
                      _buildTilesList()
                    ],
                  )));
  }

  Widget _buildTilesList() {
    return Expanded(
        child: CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverGrid.count(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: <Widget>[
              _buildTile("Festivali"),
              _buildTile("Koncerti"),
              _buildTile("Izlozbe"),
              _buildTile("Literatura"),
              _buildTile("Sport"),
              _buildTile("Predstave"),
              _buildTile("Protesti"),
              _buildTile("Konferencije"),
            ],
          ),
        ),
      ],
    ));
  }

  Container _buildTile(text) {
    return Container(
        padding: const EdgeInsets.all(8),
        // color: Colors.green[400],
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.green[400],
            image: DecorationImage(
              image: AssetImage("assets/images/banner.jpg"),
              fit: BoxFit.cover,
            )),
        child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
                padding: const EdgeInsets.all(5.0), // Adjust as needed
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white, // Text color
                    fontSize: 22,
                    fontFamily: 'Magra',
                    letterSpacing: 1,
                    shadows: [
                      Shadow(
                        color: Color.fromARGB(255, 72, 71, 71),
                        blurRadius: 3.0,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ))));
  }
}
