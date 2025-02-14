import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../styles/styles.dart';

class CategoryItem extends StatelessWidget {
  final String imagePath;
  final String categoryName;
  CategoryItem({super.key, 
    required this.imagePath,
    required this.categoryName,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return AlertDialog(
        //       title: Text("Уведомление"),
        //       content: Text("Зачем холодс трахал?"),
        //       actions: <Widget>[
        //         TextButton(
        //           child: Text("ОК"),
        //           onPressed: () {
        //             Navigator.of(context).pop();
        //           },
        //         ),
        //       ],
        //     );
        //   },
        // );
        Fluttertoast.showToast(
          msg: "опять стиралка?",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
    },
      child: Container(
        decoration: BoxDecoration(
          color: secondaryBg, // Цвет фона
          borderRadius: BorderRadius.circular(5),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 159),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                imagePath,
                width: 69,
              ),
              Flexible(
                  child: Text(
                categoryName,
                style: categoryNameTextStyle,
                softWrap: true, // Разрешить перенос текста
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
