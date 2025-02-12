import 'package:flutter/material.dart';
import '../styles/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final int bonuses = 1000;
  final String address = "Гагарина 1";

  @override
  Widget build(BuildContext context) {

    final double buttonWidthDifference = 20; // Разница в ширине

    return AppBar(
      toolbarHeight: 80,
      backgroundColor: bgcolor,
      elevation: 1,
      title: Row(
        children: [
          IconButton(
            icon: SvgPicture.asset(
              "assets/images/menubutton.svg",
              width: 30,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Меню открыто"),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: IconButton.styleFrom(
              splashFactory: NoSplash.splashFactory, // Убираем эффект нажатия
              highlightColor: Colors.transparent, // Убираем подсветку
              hoverColor: Colors.transparent, // Убираем эффект наведения (для веба)
              focusColor: Colors.transparent, // Убираем эффект фокуса
              padding: EdgeInsets.zero, // Убираем внутренние отступы
              visualDensity: VisualDensity.compact, // Уменьшаем размеры кнопки
            ),
          ),

          SizedBox(width: buttonWidthDifference),

          // Логотип и адрес (по центру)
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    "assets/images/logo.svg",
                    width: 126,
                    height: 29,
                  ),
                  SizedBox(height: 5),
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("я знаю где ты с"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    splashColor: Colors.transparent, // Убираем эффект нажатия
                    highlightColor: Colors.transparent, // Убираем эффект подсветки
                    hoverColor:
                    Colors.transparent, // Убираем эффект наведения (для веба)
                    focusColor: Colors.transparent,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: buttonDecoration,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(address, style: buttonTextStyle),
                          SizedBox(width: 10),
                          Image.asset(
                            "assets/images/arrow.png",
                            width: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Кнопка с бонусами (справа)

          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Бонусы: $bonuses"),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            splashColor: Colors.transparent, // Убираем эффект нажатия
            highlightColor: Colors.transparent, // Убираем эффект подсветки
            hoverColor:
                Colors.transparent, // Убираем эффект наведения (для веба)
            focusColor: Colors.transparent,
            child: Row(
              children: [
                Image.asset(
                  "assets/images/bonuslogo.png",
                  width: 15,
                ),
                SizedBox(width: 5),
                Text(
                  bonuses.toString(),
                  style: bonusTextStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80);
}
