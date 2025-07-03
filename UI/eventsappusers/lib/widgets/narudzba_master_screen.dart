import 'package:eventsappusers/widgets/heading_widget.dart';
import 'package:flutter/material.dart';

import 'dogadjaj_small_overview.dart';

class NarudzbaMasterScreen extends StatefulWidget {
/*  final int? selectedIndex;
  final bool showBreadcrumbs;
  String naslov;*/
  Widget child;
  double childHeight;
  String naslov;
  int? tabActive;
  bool? hideFooter;
  VoidCallback? onClickNext;

  NarudzbaMasterScreen(
      {required this.childHeight,
      required this.child,
      required this.naslov,
      this.tabActive,
      this.hideFooter,
      this.onClickNext,
      super.key});

  @override
  State<NarudzbaMasterScreen> createState() => _NarudzbaMasterScreenState();
}

class _NarudzbaMasterScreenState extends State<NarudzbaMasterScreen> {
  double footerHeight = 45;
  double headerHeight = 70;
  List selected = [false, false];

  _NarudzbaMasterScreenState();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenHeight =
            constraints.maxHeight - (headerHeight + footerHeight);
        return Column(
          children: [
            if (widget.childHeight > screenHeight)
              Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                children: [_buildHeader(), widget.child],
              )))
            else
              Expanded(
                  child: Column(
                children: [_buildHeader(), widget.child, Spacer()],
              )),

            if (widget.hideFooter == null || widget.hideFooter == false)
              _buildFooter(), // Footer placed at the bottom
          ],
        );
      },
    );
  }

  SizedBox _buildHeader() {
    if (widget.tabActive != null &&
        widget.tabActive! > 0 &&
        widget.tabActive! < 3) {
      for (int i = 0; i < widget.tabActive!; i++) {
        selected[i] = true;
      }
    }
    return SizedBox(
        height: headerHeight,
        child: Column(children: [
          HeadingWidget(text: widget.naslov),
          if (widget.tabActive != null &&
              widget.tabActive! > 0 &&
              widget.tabActive! < 3)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.all(4),
                    child: Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                          color: selected[0] == true
                              ? Color.fromRGBO(44, 152, 240, 1)
                              : Color.fromRGBO(217, 217, 217, 1),
                          borderRadius: BorderRadius.circular(50)),
                    )),
                Padding(
                    padding: EdgeInsets.all(4),
                    child: Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                          color: selected[1] == true
                              ? Color.fromRGBO(44, 152, 240, 1)
                              : Color.fromRGBO(217, 217, 217, 1),
                          borderRadius: BorderRadius.circular(50)),
                    )),

              ],
            )
        ]));
  }

  Align _buildFooter() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            height: footerHeight,
            decoration: BoxDecoration(
              color: Color.fromRGBO(44, 152, 240, 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(-5, -5),
                ),
              ],
            ),
            child: Center(
              child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Nastavite kupovinu",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                              fontSize: 20),
                        ),
                        Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(44, 152, 240, 1),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 46, 57, 78)
                                      .withOpacity(0.4),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: Offset(3, 3),
                                ),
                              ],
                            ),
                            child: IconButton(
                                onPressed: widget.onClickNext,
                                icon: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                )))
                      ])),
            )));
  }
}
