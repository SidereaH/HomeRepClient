import 'package:flutter/material.dart';
import '../styles/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'animated_icon_menu.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final int bonuses;
  final String address;
  AppHeader({required this.bonuses, required this.address});

  @override
  Widget build(BuildContext context) {
    final double buttonWidthDifference = 20;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 4,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: AppBar(
        toolbarHeight: 80,
        backgroundColor: bgcolor,
        elevation: 1,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Image.asset("assets/images/menu_button.png", width: 29,),
              onPressed: () { Scaffold.of(context).openDrawer(); },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },),
        // ),
        // SizedBox(
        //   width: 15,
        //   height: 15,
        //   child: InkWell(
        //     onTap: () {
        //       Scaffold.of(context).openDrawer();
        //     },
        //     splashColor: Colors.transparent,
        //     highlightColor: Colors.transparent,
        //     child: Container(
        //       decoration: BoxDecoration(
        //         shape: BoxShape.circle,
        //       ),
        //       child: Image.asset(
        //         "assets/images/menu_button.png",
        //         width: 15,
        //         height: 15,
        //         fit: BoxFit.cover,
        //       ),
        //     ),
        //   ),
        // ),
        title: Row(
          children: [


            // SizedBox(width: buttonWidthDifference),

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
                      highlightColor:
                          Colors.transparent, // Убираем эффект подсветки
                      hoverColor: Colors
                          .transparent, // Убираем эффект наведения (для веба)
                      focusColor: Colors.transparent,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80);
}
