import 'package:flutter/material.dart';

class DiscountsScreen extends StatefulWidget {
  const DiscountsScreen({super.key});

  @override
  State<DiscountsScreen> createState() => _DiscountsScreenState();
}

class _DiscountsScreenState extends State<DiscountsScreen> {
  final TextEditingController _promoController = TextEditingController();
  List<String> activePromos = ['SUMMER2023', 'NEWUSER50'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Скидки и промокоды'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _promoController,
              decoration: InputDecoration(
                labelText: 'Введите промокод',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: _applyPromo,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Активные промокоды',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: activePromos.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(activePromos[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => _removePromo(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _applyPromo() {
    if (_promoController.text.isNotEmpty) {
      setState(() {
        activePromos.add(_promoController.text);
        _promoController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Промокод применен')),
      );
    }
  }

  void _removePromo(int index) {
    setState(() {
      activePromos.removeAt(index);
    });
  }
}