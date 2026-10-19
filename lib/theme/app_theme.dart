import 'package:flutter/material.dart';

class C {
  static const navy = Color(0xFFB3192B);//hello 
  static const ink = Color(0xFF253044);
  static const sub = Color(0xFF5B6472);
  static const bg = Color(0xFFF6F7F9);
  static const border = Color(0xFFE5E7EB);
  static const inputBorder = Color(0xFFD1D5DB);
  static const red = Color(0xFFB3192B);
  static const redBright = Color(0xFFE0293C);
  static const green = Color(0xFF2E7D4F);
  static const amber = Color(0xFFD99A00);
  static const critical = Color(0xFFC62828);
  static const skeleton = Color(0xFFE3E7ED);
  static const divider = Color(0xFFEEF0F3);
  static const track = Color(0xFFE8EBF0);
  static const blue1 = Color(0xFF3F5F8A);
  static const scrim = Color(0x8C1D2B3D);
}

class T {
  static const h = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: C.ink,
  );
  static const big = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: C.ink,
  );
  static const value = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: C.ink,
  );
  static const title = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: C.ink,
  );
  static const body = TextStyle(fontSize: 13, color: C.ink);
  static const sub = TextStyle(fontSize: 12, color: C.sub);
}

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: C.bg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: C.navy,
      primary: C.navy,
      surface: Colors.white,
    ),
  );
}
