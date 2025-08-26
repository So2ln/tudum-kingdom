import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.midnightBlack,
    required this.royalDeepPurple,
    required this.sparklePink,
    required this.crownGold,
  });

  final Color? midnightBlack;
  final Color? royalDeepPurple;
  final Color? sparklePink;
  final Color? crownGold;

  @override
  AppColors copyWith({
    Color? midnightBlack,
    Color? royalDeepPurple,
    Color? sparklePink,
    Color? crownGold,
  }) {
    return AppColors(
      midnightBlack: midnightBlack ?? this.midnightBlack,
      royalDeepPurple: royalDeepPurple ?? this.royalDeepPurple,
      sparklePink: sparklePink ?? this.sparklePink,
      crownGold: crownGold ?? this.crownGold,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      midnightBlack: Color.lerp(midnightBlack, other.midnightBlack, t),
      royalDeepPurple: Color.lerp(royalDeepPurple, other.royalDeepPurple, t),
      sparklePink: Color.lerp(sparklePink, other.sparklePink, t),
      crownGold: Color.lerp(crownGold, other.crownGold, t),
    );
  }
}

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF0D0D0D), // 기본 배경색
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent, // 앱바 배경 투명하게
    elevation: 0,
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF1C0B33), // 로얄 딥 퍼플을 기본 색상으로
    brightness: Brightness.dark,
  ),
  extensions: const <ThemeExtension<dynamic>>[
    AppColors(
      midnightBlack: Color(0xFF0D0D0D),
      royalDeepPurple: Color(0xFF1C0B33),
      sparklePink: Color(0xFFFFB6E6),
      crownGold: Color(0xFFFFD700),
    ),
  ],
);
