import 'package:domrep_flutter/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:domrep_flutter/styles/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});


  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();


  final _phoneMask = MaskTextInputFormatter(
    mask: '+7 (###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _passwordHasFocus = false;
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    final phone = _phoneMask.getUnmaskedText();
    return phone.length == 10 && _passwordController.text.length >= 6;
  }

  Future<void> _submit() async {
    if (!_isFormValid || _isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final phone = '7${_phoneMask.getUnmaskedText()}';
      // print(phone);
      final response = await http.post(
        Uri.parse(AppConfig.MAIN_API_URI + '/auth/signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone': phone,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        // Успешный вход
        final authResponse = jsonDecode(response.body);
        final accessToken = authResponse['accessToken'];
        final refreshToken = authResponse['refreshToken'];

        final SharedPreferences storage = await SharedPreferences.getInstance();
        // Сохраняем токены (например, в SharedPreferences)
        await storage.setString('accessToken', accessToken);
        await storage.setString('refreshToken', refreshToken);

        // Переходим на главный экран
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        // Ошибка аутентификации
        final error = jsonDecode(response.body);
        setState(() => _errorMessage = error.toString());
      }
    } catch (e) {
      setState(() => _errorMessage = 'Ошибка соединения: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Поле телефона
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [_phoneMask],
                  decoration: InputDecoration(
                    labelText: 'Номер телефона',
                    hintText: '+7 (XXX) XXX-XX-XX',
                    errorText: _phoneMask.getUnmaskedText().length < 10
                        ? 'Введите 10 цифр номера'
                        : null,
                  ),
                  onChanged: (_) => setState(() {}),
                ),

                const SizedBox(height: 20),

                // Поле пароля
                FocusScope(
                  child: Focus(
                    onFocusChange: (hasFocus) {
                      setState(() => _passwordHasFocus = hasFocus);
                    },
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Пароль',
                        suffixIcon: _passwordHasFocus || _passwordController.text.isNotEmpty
                            ? IconButton(
                          icon: Icon(_obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                        )
                            : null,
                        errorText: _passwordController.text.length < 6 && _passwordController.text.isNotEmpty
                            ? 'Минимум 6 символов'
                            : null,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ),

                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                const SizedBox(height: 30),

                // Кнопка входа
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFormValid
                          ? accentColor
                          : accentColor.withOpacity(0.5),
                    ),
                    onPressed: _isFormValid && !_isLoading ? _submit : null,
                    child: _isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    )
                        : const Text(
                      'Войти',
                      style: questionAccentStyle,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Ссылка на регистрацию
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Text(
                    'Нет аккаунта? Зарегистрироваться',
                    style: TextStyle(
                      color: primaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}