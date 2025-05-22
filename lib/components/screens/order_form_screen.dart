import 'package:domrep_flutter/components/geoloc/geoTile.dart';
import 'package:domrep_flutter/components/geoloc/location_service.dart';
import 'package:domrep_flutter/components/screens/home_screen.dart';
import 'package:domrep_flutter/components/tip_arrow.dart';
import 'package:domrep_flutter/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../styles/styles.dart';
import '../address_item.dart';
import '../dropdown_category_selector.dart';

class OrderFormScreen extends StatefulWidget {
  final String orderCategory;
  const OrderFormScreen({super.key, required this.orderCategory});
  @override
  _OrderFormScreenState createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  String selectedCity = 'Ростов-на-Дону';
  List<String> cities = [
    'Ростов-на-Дону',
    'Батайск',
    'Аксай',
  ];
  Future<void> _loadAddress() async {
    final address = await LocationService.getCurrentAddress();
    setState(() {
      addressValue = address;
    });
  }
  String addressValue = 'Ваш адрес...';
  String apartmentValue = '';
  String descriptionValue = '';
  String priceValue = '';

  String phoneValue = '+7 971 231-12-32';
  String selectedCategory = '';

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.orderCategory;
  }

  String geocode_api = AppConfig.YANDEX_GEOCODER;
  Future<String> getGeoByAddress(String city, String street, String building) async {
    final url =
        'https://geocode-maps.yandex.ru/1.x/?apikey=$geocode_api&geocode=$city $street $building&format=json';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['response']['GeoObjectCollection']['featureMember'];
        if (results is List && results.isNotEmpty) {
          final pos = results[0]['GeoObject']['Point']['pos'] ?? 'Координаты не найдены';
          return pos;
        }
      }
    } catch (e) {
      return 'Ошибка при получении координат: $e';
    }
    return "Ошибка при получении координат";
  }

  Future<void> _submitOrder() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final SharedPreferences storage = await SharedPreferences.getInstance();
      String? clientID = await storage.getString("id");
      String lonLat = await getGeoByAddress(selectedCity,addressValue.split(',')[0],addressValue.split(' ')[1]);
      final orderData = {
        "description": descriptionValue,
        "category": {"name": selectedCategory},
        "customerId": clientID,
        "address": {
          "streetName": addressValue.split(',')[0], // предполагаем, что улица - первое слово
          "buildingNumber": addressValue.split(',')[1], // а номер дома - второе
          "apartmentNumber": apartmentValue,
          "cityName": selectedCity,
          "longitude" : lonLat.split(' ')[1],
          "latitude": lonLat.split(' ')[0]

        },
        "paymentType": {"name": "MIR"}, // или другой тип оплаты
      };
      print(orderData);

      try {
        final response = await http.post(
          Uri.parse('${AppConfig.MAIN_API_URI}/api/orders'), // замените на ваш URL
          headers: {'Content-Type': 'application/json'},
          body: json.encode(orderData),
        );
        print(response.body);
        if (response.statusCode == 200) {
          // Успешная отправка
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Заказ успешно создан!')),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          // Ошибка сервера
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка при создании заказа: ${response.body}')),
          );
        }
      } catch (e) {
        // Ошибка сети
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка сети: $e')),
        );
      }
    }
  }
  Future<void> fillPhone() async{
    final SharedPreferences storage = await SharedPreferences.getInstance();
    this.phoneValue = storage.getString("userPhone")!;
  }

  @override
  Widget build(BuildContext context) {
    fillPhone();
    _loadAddress();
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
                Image.asset("assets/images/bonuslogo.png", width: 15),
                SizedBox(width: 5),
                Text('1000', style: bonusTextStyle),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 80), // Добавляем отступ снизу для кнопки
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Проверьте и дополните информацию', style: bonusTextStyle),
                  SizedBox(height: 20),
                  DropdownCategorySelector(
                    title: "Категория",
                    categories: [
                      'Сантехника',
                      'Бытовая техника',
                      'Газовое оборудование',
                      'Электрика'
                    ],
                    initialCategory: widget.orderCategory,
                    onCategoryChanged: (selected) {
                      setState(() {
                        selectedCategory = selected;
                      });
                    },
                  ),
                  SizedBox(height: 16),

                  /// ---------- Описание заказа ----------
                  InfoItem(
                    title: 'Описание заказа',
                    value: descriptionValue,
                    isPrice: false,
                    hint: "Что сломалось...",
                    onChanged: (value) {
                      setState(() {
                        descriptionValue = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),

                  /// ---------- Город ----------
                  Text('Город', style: tipText),
                  SizedBox(height: 4),
                  DropdownButton<String>(
                    value: selectedCity,
                    isExpanded: true,
                    items: cities.map((city) {
                      return DropdownMenuItem<String>(
                        value: city,
                        child: Text(city),
                      );
                    }).toList(),
                    onChanged: (city) {
                      setState(() {
                        selectedCity = city!;
                      });
                    },
                  ),
                  SizedBox(height: 16),

                  /// ---------- Адрес ----------
                  AddressItem(
                    title: 'Адрес',
                    value: addressValue,
                    selectedCity: selectedCity,
                    onChanged: (value) {
                      setState(() {
                        addressValue = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),

                  /// ---------- Квартира ----------
                  InfoItem(
                    title: 'Квартира',
                    value: apartmentValue,
                    isPrice: false,
                    hint: "Номер квартиры",
                    onChanged: (value) {
                      setState(() {
                        apartmentValue = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: InfoItem(
                          title: 'Предложите стоимость работы',
                          value: priceValue,
                          isPrice: true,
                          hint: "Сколько вы готовы предложить",
                          onChanged: (value) {
                            setState(() {
                              priceValue = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      TipArrow(tip: "Как определяется\n стоимость?"),
                    ],
                  ),
                  SizedBox(height: 16),
                  PhoneInfoItem(
                    title: 'Номер для связи',
                    phoneNumber: phoneValue,
                    onPhoneChanged: (value) {
                      setState(() {
                        phoneValue = value;
                      });
                    },
                  ),
                  SizedBox(height: 80), // Добавляем дополнительный отступ вниз формы
                ],
              ),
            ),
          ),

          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _submitOrder,
                child: Text('Найти мастера',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoItem extends StatefulWidget {
  final String title;
  final String value;
  final String hint;
  final bool isPrice;
  final Function(String) onChanged;
  const InfoItem({
    super.key,
    required this.title,
    required this.value,
    required this.hint,
    required this.isPrice,
    required this.onChanged,
  });
  @override
  _InfoItemState createState() => _InfoItemState();
}

class _InfoItemState extends State<InfoItem> {
  late TextEditingController _controller;
  String? _errorText;
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

  bool _validatePrice(String value) {
    // Регулярное выражение для проверки формата цены (например, 12990)
    final RegExp priceRegExp = RegExp(r'^\d+$');
    return priceRegExp.hasMatch(value);
  }

  void _onChanged(String value) {
    widget.onChanged(value);

    if (widget.isPrice == true) {
      setState(() {
        if (_validatePrice(value)) {
          _errorText = null;
        } else {
          _errorText = 'Введите корректную цену (например, 12990)';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: TextStyle(fontSize: 16)),
        SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: TextField(
            controller: _controller,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
              errorText: _errorText,
              border: OutlineInputBorder(),
              hintText: widget.hint,
            ),
            onChanged: _onChanged,
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
  const PhoneInfoItem({
    super.key,
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
    filter: {"#": RegExp(r'[0-9]')},
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
        Text(widget.title, style: tipText),
        SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.phone,
            inputFormatters: [maskFormatter],
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(hintText: '+7 (___) ___-__-__'),
            onChanged: _onChanged,
          ),
        ),
      ],
    );
  }
}