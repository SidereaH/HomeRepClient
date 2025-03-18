import 'package:domrep_flutter/config/app_config.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // Для обработки JSON
import 'package:http/http.dart' as http;

class AddressItem extends StatefulWidget {
  final String title;
  final String value;

  const AddressItem({super.key, required this.title, required this.value});

  @override
  _AddressItemState createState() => _AddressItemState();
}

class _AddressItemState extends State<AddressItem> {
  late TextEditingController _controller;
  List<String> _suggestions = [];
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final String GeoSuggestAPI = AppConfig.YANDEX_SUGGEST_KEY;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);

    _controller.addListener(_onTextChanged);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _removeOverlay();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onTextChanged() async {
    final text = _controller.text;
    if (text.isNotEmpty) {
      final suggestions = await fetchSuggestions(text);
      setState(() {
        _suggestions = suggestions;
      });
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  Future<List<String>> fetchSuggestions(String query) async {
    final url =
        'https://suggest-maps.yandex.ru/v1/suggest?apikey=$GeoSuggestAPI&text=Ростов-на-Дону$query&results=10&print_address=1&types=biz,street,house,entrance&bbox=47.183808,39.592541~47.300731,39.797455';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final results = data['results'];
        if (results is List) {
          return results
              .map<String>((item) => item['title']?['text'] ?? '')
              .where((text) => text.isNotEmpty)
              .toList();
        } else {
          // Если results нет или он не список
          return [];
        }
      } else {
        // Обработка плохого кода ответа
        return [];
      }
    } catch (e) {
      // Логирование или обработка исключения
      print('Ошибка при получении подсказок: $e');
      return [];
    }
  }

  void _showOverlay() {
    _removeOverlay(); // Remove previous overlay
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + renderBox.size.height + 30,
        width: renderBox.size.width,
        child: Material(
          elevation: 4.0,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: _suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = _suggestions[index];
              return ListTile(
                title: Text(suggestion),
                onTap: () {
                  _controller.text = suggestion;
                  _removeOverlay();
                },
              );
            },
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: TextStyle(fontSize: 14, color: Colors.grey)),
        SizedBox(height: 4),
        TextField(
          focusNode: _focusNode,
          controller: _controller,
          style: TextStyle(fontSize: 16),
          decoration: InputDecoration.collapsed(hintText: 'Введите текст'),
        ),
      ],
    );
  }
}
