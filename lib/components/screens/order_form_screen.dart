import 'package:domrep_flutter/components/screens/home_screen.dart';
import 'package:domrep_flutter/components/tip_arrow.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../styles/styles.dart';
import '../address_item.dart';
import '../dropdown_category_selector.dart';

class OrderFormScreen extends StatelessWidget {
  final String orderCategory;

  const OrderFormScreen({
    super.key,
    required this.orderCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 12),
            child: Row(
              children: [
                Image.asset(
                  "assets/images/bonuslogo.png",
                  width: 15,
                ),
                SizedBox(width: 5),
                Text(
                  1000.toString(),
                  style: bonusTextStyle,
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Проверьте и дополните информацию',
              style: bonusTextStyle,
            ),
            SizedBox(height: 20),
            DropdownCategorySelector(
              title: "Категория",
              categories: ['Сантехника', 'Бытовая техника', 'Газовое оборудование', 'Электрика'],
              initialCategory: orderCategory,
              onCategoryChanged: (selected) {
                // print('Выбрана категория: $selected');
              },
            ),

            SizedBox(height: 16),
            InfoItem(title: 'Описание проблемы', value: 'Трубы горят'),
            SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AddressItem(title: 'Адрес', value: 'ул Смычки 72'),
                ),
                SizedBox(width: 8),
                TipArrow(tip: "Изменить")
              ],
            ),
            SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: InfoItem(
                      title: 'Относительная стоимость работ',
                      value: '12 990 р.'),
                ),
                SizedBox(width: 8),
                TipArrow(tip: "Как определяется\n стоимость?")
              ],
            ),
            SizedBox(height: 16),
            PhoneInfoItem(
              title: 'Номер для связи',
              phoneNumber: '+7 971 231-12-32',
              onPhoneChanged: (value) {
                // print('Новый номер: $value');
              },
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {},
                child: Text('Найти мастера',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class InfoItem extends StatefulWidget {
  final String title;
  final String value;

  const InfoItem({super.key, required this.title, required this.value});

  @override
  _InfoItemState createState() => _InfoItemState();
}

class _InfoItemState extends State<InfoItem> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: tipText,
        ),
        SizedBox(height: 4),

        SizedBox(
          width: double.infinity,
          child: TextField(
            controller: _controller,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration.collapsed(
              hintText: 'Введите текст',
            ),
          ),
        ),
      ],
    );
  }
}


class PhoneInfoItem extends StatefulWidget {
  final String title;
  final String phoneNumber;
  final Function(String) onPhoneChanged;

  const PhoneInfoItem({super.key,
    required this.title,
    required this.phoneNumber,
    required this.onPhoneChanged,
  });

  @override
  _PhoneInfoItemState createState() => _PhoneInfoItemState();
}

class _PhoneInfoItemState extends State<PhoneInfoItem> {
  late TextEditingController _controller;
  final maskFormatter = MaskTextInputFormatter(
    mask: '+7 (###) ###-##-##',
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: maskFormatter.maskText(widget.phoneNumber),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    widget.onPhoneChanged(maskFormatter.getUnmaskedText());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: tipText,
        ),
        SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.phone,
            inputFormatters: [maskFormatter],
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration.collapsed(
              hintText: '+7 (___) ___-__-__',
            ),
            onChanged: _onChanged,
          ),
        ),
      ],
    );
  }
}