import 'package:domrep_flutter/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:domrep_flutter/styles/styles.dart';
import 'dart:convert';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
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
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    final phone = _phoneMask.getUnmaskedText();
    return _usernameController.text.isNotEmpty &&
        _emailController.text.contains('@') &&
        phone.length == 10 &&
        _passwordController.text.length >= 6;
  }

  Future<void> _submit() async {
    if (!_isFormValid || _isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final phone = '7${_phoneMask.getUnmaskedText()}';

      final response = await http.post(
        Uri.parse( AppConfig.MAIN_API_URI +'/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text,
          'email': _emailController.text,
          'phone': phone,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 201) {
        // Успешная регистрация
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/signin');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Регистрация прошла успешно!')),
          );
        }
      } else {
        // Ошибка от сервера
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
      backgroundColor: screenColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Регистрация', style: titleStyle),
                  const SizedBox(height: 32),

                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),

                  // Имя пользователя
                  Text('Имя пользователя', style: tipText),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Введите ваше имя',
                      hintStyle: TextStyle(color: tipColor),
                      filled: true,
                      fillColor: whiteColor,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: secondaryBg),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),

                  const SizedBox(height: 24),

                  // Email
                  Text('Email', style: tipText),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'example@mail.com',
                      hintStyle: TextStyle(color: tipColor),
                      filled: true,
                      fillColor: whiteColor,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: secondaryBg),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                      errorText: _emailController.text.isNotEmpty &&
                          !_emailController.text.contains('@')
                          ? 'Введите корректный email'
                          : null,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),

                  const SizedBox(height: 24),

                  // Телефон
                  Text('Номер телефона', style: tipText),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [_phoneMask],
                    decoration: InputDecoration(
                      hintText: '+7 (___) ___-__-__',
                      hintStyle: TextStyle(color: tipColor),
                      filled: true,
                      fillColor: whiteColor,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: secondaryBg),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                      errorText: _phoneMask.getUnmaskedText().length < 10
                          ? 'Введите 10 цифр номера'
                          : null,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),

                  const SizedBox(height: 24),

                  // Пароль
                  Text('Пароль', style: tipText),
                  const SizedBox(height: 6),
                  FocusScope(
                    child: Focus(
                      onFocusChange: (hasFocus) {
                        setState(() => _passwordHasFocus = hasFocus);
                      },
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'Не менее 6 символов',
                          hintStyle: TextStyle(color: tipColor),
                          filled: true,
                          fillColor: whiteColor,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: secondaryBg),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: primaryColor, width: 2),
                          ),
                          suffixIcon: _passwordHasFocus ||
                              _passwordController.text.isNotEmpty
                              ? IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: tipColor,
                            ),
                            onPressed: () {
                              setState(
                                      () => _obscurePassword = !_obscurePassword);
                            },
                          )
                              : null,
                          errorText: _passwordController.text.isNotEmpty &&
                              _passwordController.text.length < 6
                              ? 'Минимум 6 символов'
                              : null,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Кнопка регистрации
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isFormValid
                            ? accentColor
                            : accentColor.withOpacity(0.5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _submit,
                      child: _isLoading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                          : Text('Зарегистрироваться', style: buttonText),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Ссылка на регистрацию
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signin');
                    },
                    child: Text(
                      'Есть аккаунт? Войти',
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
      ),
    );
  }
}