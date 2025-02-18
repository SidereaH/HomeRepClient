import 'package:domrep_flutter/components/quick_request_items.dart';
import 'package:flutter/cupertino.dart';

class QuickRequests extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10), child: QuickRequestItems());
  }
}
