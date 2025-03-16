import 'package:domrep_flutter/components/history_item.dart';
import 'package:flutter/cupertino.dart';

import '../styles/styles.dart';

class HistoryList extends StatelessWidget{
  const HistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: bgcolor,
          boxShadow: [
            BoxShadow(
              color: Color(0x40000000),
              blurRadius: 10,
              offset: Offset(0, -4),
              spreadRadius: -6,
            ),
          ],
        ),
        child: Column(mainAxisSize: MainAxisSize.max, children:[
          SizedBox(height: 15,),
          Text("История заявок", style: headerComponentStyle,),
          SizedBox(height: 23,),
          HistoryItem()
        ],
      )
      ),
    );
  }
}