import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:domrep_flutter/styles/styles.dart';

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
    if (!_isFormValid) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    final fullPhone = '+7${_phoneMask.getUnmaskedText()}';
    print('Имя: ${_usernameController.text}');
    print('Email: ${_emailController.text}');
    print('Телефон: $fullPhone');
    print('Пароль: ${_passwordController.text}');
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: secondaryBg),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: primaryColor, width: 2),
                          ),
                          suffixIcon: _passwordHasFocus || _passwordController.text.isNotEmpty
                              ? IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: tipColor,
                            ),
                            onPressed: () {
                              setState(() => _obscurePassword = !_obscurePassword);
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
                      onPressed: _isFormValid && !_isLoading ? _submit : null,
                      child: _isLoading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                          : Text('Зарегистрироваться', style: buttonText),
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