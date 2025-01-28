import 'package:flutter/material.dart';

final ThemeData myCustomTheme = ThemeData(
  // Основные цвета
  primaryColor: Color(0xFFFF8200), // Основной цвет кнопок
  colorScheme: ColorScheme.light(
    primary: Color(0xFFFF8200), // Основной цвет (кнопки)
    secondary: Color(0xFF009EDC), // Цвет для маленьких кнопок
    background: Color(0xFFF5F6F8), // Главный фон страницы
    surface: Color(0xFFF5F6F8), // Фон маленьких карточек и категорий
    onPrimary: Colors.white, // Цвет текста на основном цвете
    onSecondary: Colors.white, // Цвет текста на второстепенном цвете
    onBackground: Color(0xFF0C0C2D), // Основной цвет текста
    onSurface: Color(0xFF0C0C2D), // Цвет текста на фоне
  ),
  // Текстовые стили
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF0C0C2D)), // Основной текст
    bodyMedium: TextStyle(color: Color(0xFF0C0C2D)), // Основной текст
    bodySmall: TextStyle(color: Color(0xFF0C0C2D)), // Основной текст
    displayLarge: TextStyle(color: Color(0xFF0C0C2D)), // Заголовки
    displayMedium: TextStyle(color: Color(0xFF0C0C2D)), // Заголовки
    displaySmall: TextStyle(color: Color(0xFF0C0C2D)), // Заголовки
    titleLarge: TextStyle(color: Color(0xFF0C0C2D)), // Заголовки
    titleMedium: TextStyle(color: Color(0xFF0C0C2D)), // Заголовки
    titleSmall: TextStyle(color: Color(0xFF0C0C2D)), // Заголовки
    labelLarge: TextStyle(color: Color(0xFFFFF8F2)), // Текст на кнопках
    labelMedium: TextStyle(color: Color(0xFFFFF8F2)), // Текст на кнопках
    labelSmall: TextStyle(color: Color(0xFFFFF8F2)), // Текст на кнопках
  ),
  // Фон отделов
  cardTheme: CardTheme(
    color: Color(0xFFFFF8F2), // Фон отдела
    elevation: 0, // Убираем тень по умолчанию
    margin: EdgeInsets.all(8), // Отступы для карточек
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8), // Закругленные углы
    ),
  ),
  // Тени
  appBarTheme: AppBarTheme(
    elevation: 0, // Убираем тень у AppBar
  ),
  // Тень для карточек
  shadowColor: Color(0x33000000), // Цвет тени (20% прозрачности)
  extensions: <ThemeExtension<dynamic>>[
    CustomShadows(
      cardShadow: BoxShadow(
        color: Color(0x33000000), // Цвет тени (20% прозрачности)
        offset: Offset(0, 1), // Позиция тени (x: 0, y: 1)
        blurRadius: 8.1, // Размытие
        spreadRadius: 0, // Распространение
      ),
    ),
  ],
);

// Расширение для кастомных теней
class CustomShadows extends ThemeExtension<CustomShadows> {
  final BoxShadow cardShadow;

  CustomShadows({required this.cardShadow});

  @override
  ThemeExtension<CustomShadows> copyWith({BoxShadow? cardShadow}) {
    return CustomShadows(
      cardShadow: cardShadow ?? this.cardShadow,
    );
  }

  @override
  ThemeExtension<CustomShadows> lerp(
      ThemeExtension<CustomShadows>? other, double t) {
    if (other is! CustomShadows) {
      return this;
    }
    return CustomShadows(
      cardShadow: BoxShadow.lerp(cardShadow, other.cardShadow, t)!,
    );
  }
}
