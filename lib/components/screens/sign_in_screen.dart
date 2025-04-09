import 'package:domrep_flutter/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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

  @override
  void initState() {
    super.initState();
    // Убрал слушатели, они нам не нужны
  }

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
    if (!_isFormValid) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    final fullPhone = '+7${_phoneMask.getUnmaskedText()}';
    print('Номер: $fullPhone');
    print('Пароль: ${_passwordController.text}');
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

                // Поле пароля (исправленное)
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}