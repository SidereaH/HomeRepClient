import 'package:flutter/material.dart';

import '../styles/styles.dart';

class TipArrow extends StatefulWidget {

  final String tip;
  const TipArrow({
    super.key,
    required this.tip,
  });

  @override
  State<TipArrow> createState() => _TipArrowState();
}

class _TipArrowState extends State<TipArrow> {
@override
Widget build(BuildContext context) {
  return TextButton(
    onPressed: () {},
    child: Row(
      children: [
        Text(widget.tip, style: tipText, textAlign: TextAlign.right,),
        SizedBox(width: 4,),
        Image.asset("assets/images/black_mini_arrow.png", width: 7,)
      ],
    ),
  );
}
}