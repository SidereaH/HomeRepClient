import 'package:domrep_flutter/components/screens/order_form_screen.dart';
import 'package:flutter/material.dart';

import '../../styles/styles.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Регистрация', style: titleStyle),
                SizedBox(height: 20),
                _buildField("Имя пользователя", usernameController),
                SizedBox(height: 16),
                _buildField("Email", emailController, TextInputType.emailAddress),
                SizedBox(height: 16),
                PhoneInfoItem(
                  title: 'Номер для связи',
                  phoneNumber: '+7 971 231-12-32',
                  onPhoneChanged: (value) {passwordController.text =  value.toString();},
                ),
                SizedBox(height: 16),
                _buildField("Пароль", passwordController, TextInputType.text, true),
                SizedBox(height: 24),
                GestureDetector(
                  onTap: () {
                    // TODO: Implement signup logic
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: buttonDecoration,
                    child: Center(child: Text("Зарегистрироваться", style: buttonText)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String hint, TextEditingController controller, [TextInputType type = TextInputType.text, bool obscure = false]) {
    return TextField(
      controller: controller,
      keyboardType: type,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: secondaryBg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
    );
  }
}
