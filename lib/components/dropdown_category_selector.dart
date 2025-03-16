import 'package:domrep_flutter/styles/styles.dart';
import 'package:flutter/material.dart';

class DropdownCategorySelector extends StatefulWidget {
  final String title;
  final List<String> categories;
  final String initialCategory;
  final Function(String) onCategoryChanged;

  const DropdownCategorySelector({
    super.key,
    required this.title,
    required this.categories,
    required this.initialCategory,
    required this.onCategoryChanged,
  });

  @override
  _DropdownCategorySelectorState createState() => _DropdownCategorySelectorState();
}

class _DropdownCategorySelectorState extends State<DropdownCategorySelector> {
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
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
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              items: widget.categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                  widget.onCategoryChanged(newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
