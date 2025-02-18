import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../styles/styles.dart';

class QuestionButton extends StatelessWidget {
  final Color colorAccent;
  final String question;
  QuestionButton({
    super.key,
    required this.colorAccent,
    required this.question,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Fluttertoast.showToast(
          msg: "опять стиралка?",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: colorAccent, // Цвет фона
          borderRadius: BorderRadius.circular(5),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 272, maxHeight: 52),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Image.network(
              //   "localhost:8081/api/image/Газовое_оборудование",
              //   height: 69,
              // ),
              Image.asset(
                "assets/images/what_is_group.png",
                height: 69,
              ),
              Expanded(
                child: Text(
                  question,
                  style: questionAccentStyle,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
