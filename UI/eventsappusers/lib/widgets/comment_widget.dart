import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {
  String username;
  String text;

  CommentWidget({super.key, required this.username, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(5),
        child: Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(4, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 0.3,
                    color: Color.fromRGBO(141, 141, 153, 1),
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700),
              ),
              Text(
                text,
                style: TextStyle(
                    fontSize: 13,
                    letterSpacing: 0.3,
                    color: Color.fromRGBO(60, 71, 92, 1),
                    fontFamily: 'Montserrat'),
              )
            ],
          ),
        ));
  }
}
