import 'package:domrep_flutter/components/quick_request_items.dart';
import 'package:flutter/cupertino.dart';

import 'category_item.dart';

class QuickRequests extends StatelessWidget {
  var categories = [
    "Бытовая техника",
    "Сантехника",
    "Электрика",
    "Газовое оборуд-е",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10), child: QuickRequestItems());
  }
}
