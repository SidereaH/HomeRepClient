import 'package:domrep_flutter/config/app_config.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddressItem extends StatefulWidget {
  final String title;
  final String value;
  final String selectedCity;
  final ValueChanged<String>? onChanged;

  const AddressItem({
    super.key,
    required this.title,
    required this.value,
    required this.selectedCity,
    this.onChanged,
  });

  @override
  _AddressItemState createState() => _AddressItemState();
}

class _AddressItemState extends State<AddressItem> {
  late TextEditingController _controller;
  List<String> _suggestions = [];
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final String geoSuggestAPI = AppConfig.YANDEX_SUGGEST_KEY;
  final LayerLink _layerLink = LayerLink();

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
  void didUpdateWidget(AddressItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onTextChanged() async {
    final text = _controller.text;
    widget.onChanged?.call(text);

    if (text.isNotEmpty) {
      final suggestions = await fetchSuggestions(text);
      if (mounted) {
        setState(() {
          _suggestions = suggestions;
        });
        _showOverlay();
      }
    } else {
      _removeOverlay();
    }
  }

  Future<List<String>> fetchSuggestions(String query) async {
    final city = Uri.encodeComponent(widget.selectedCity);
    final url =
        'https://suggest-maps.yandex.ru/v1/suggest?apikey=$geoSuggestAPI&text=$city $query&results=5&print_address=1&types=street,house,entrance';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List?;
        return results
            ?.map<String>((item) => item['title']?['text']?.toString() ?? '')
            .where((text) => text.isNotEmpty)
            .toList() ??
            [];
      }
      return [];
    } catch (e) {
      debugPrint('Ошибка при получении подсказок: $e');
      return [];
    }
  }

  void _showOverlay() {
    _removeOverlay();

    if (_suggestions.isEmpty) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        offset: const Offset(0, 40),
        child: Material(
          elevation: 4,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_suggestions[index]),
                  onTap: () {
                    _controller.text = _suggestions[index];
                    widget.onChanged?.call(_suggestions[index]);
                    _removeOverlay();
                    _focusNode.unfocus();
                  },
                );
              },
            ),
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
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title, style: TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 4),
          TextField(
            focusNode: _focusNode,
            controller: _controller,
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Введите адрес',
              border: const OutlineInputBorder(),
              suffixIcon: _suggestions.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  _controller.clear();
                  widget.onChanged?.call('');
                },
              )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}