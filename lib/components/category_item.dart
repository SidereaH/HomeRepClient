import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../config/app_config.dart';
import '../styles/styles.dart';

class CategoryItem extends StatelessWidget {
  final String imageName;
  final String categoryName;

  CategoryItem({
    super.key,
    required this.imageName,
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
          constraints: BoxConstraints(maxWidth: 175),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.network(
                "${AppConfig.API_URI}/api/image/$imageName",
                height: 69,
              ),
              Expanded(
                child: Text(
                  categoryName,
                  style: categoryNameTextStyle,
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
