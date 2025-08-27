// import 'package:flutter/material.dart';

// @immutable
// class AppColors extends ThemeExtension<AppColors> {
//   const AppColors({
//     required this.midnightBlack,
//     required this.royalDeepPurple,
//     required this.sparklePink,
//     required this.crownGold,
//   });

//   final Color? midnightBlack;
//   final Color? royalDeepPurple;
//   final Color? sparklePink;
//   final Color? crownGold;

//   @override
//   AppColors copyWith({
//     Color? midnightBlack,
//     Color? royalDeepPurple,
//     Color? sparklePink,
//     Color? crownGold,
//   }) {
//     return AppColors(
//       midnightBlack: midnightBlack ?? this.midnightBlack,
//       royalDeepPurple: royalDeepPurple ?? this.royalDeepPurple,
//       sparklePink: sparklePink ?? this.sparklePink,
//       crownGold: crownGold ?? this.crownGold,
//     );
//   }

//   @override
//   AppColors lerp(ThemeExtension<AppColors>? other, double t) {
//     if (other is! AppColors) {
//       return this;
//     }
//     return AppColors(
//       midnightBlack: Color.lerp(midnightBlack, other.midnightBlack, t),
//       royalDeepPurple: Color.lerp(royalDeepPurple, other.royalDeepPurple, t),
//       sparklePink: Color.lerp(sparklePink, other.sparklePink, t),
//       crownGold: Color.lerp(crownGold, other.crownGold, t),
//     );
//   }
// }

// final darkTheme = ThemeData(
//   brightness: Brightness.dark,
//   scaffoldBackgroundColor: const Color(0xFF0D0D0D), // 기본 배경색
//   appBarTheme: const AppBarTheme(
//     backgroundColor: Colors.transparent, // 앱바 배경 투명하게
//     elevation: 0,
//   ),
//   colorScheme: ColorScheme.fromSeed(
//     seedColor: const Color(0xFF1C0B33), // 로얄 딥 퍼플을 기본 색상으로
//     brightness: Brightness.dark,
//   ),
//   extensions: const <ThemeExtension<dynamic>>[
//     AppColors(
//       midnightBlack: Color(0xFF0D0D0D),
//       royalDeepPurple: Color(0xFF1C0B33),
//       sparklePink: Color(0xFFFFB6E6),
//       crownGold: Color(0xFFFFCC00),
//     ),
//   ],
// );

import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    // required this.midnightBlack,
    // required this.royalDeepPurple,
    required this.sparklePink,
    required this.crownGold,
    required this.goldHighlight, //  반짝이는 효과를 위한 밝은 금색 추가
    required this.deepPurpleNight, // 새로운 배경색 추가
    required this.mistyLavender,
    required this.silverMist,
  });

  // final Color? midnightBlack;
  // final Color? royalDeepPurple;
  final Color? sparklePink;
  final Color? crownGold;
  final Color? goldHighlight;
  final Color? deepPurpleNight;
  final Color? mistyLavender;
  final Color? silverMist;

  @override
  AppColors copyWith({
    // ...
    Color? sparklePink,
    Color? crownGold,
    Color? goldHighlight,
    Color? deepPurpleNight,
    Color? mistyLavender,
    Color? silverMist,
  }) {
    return AppColors(
      // ...
      sparklePink: sparklePink ?? this.sparklePink,
      crownGold: crownGold ?? this.crownGold,
      goldHighlight: goldHighlight ?? this.goldHighlight,
      deepPurpleNight: deepPurpleNight ?? this.deepPurpleNight,
      mistyLavender: mistyLavender ?? this.mistyLavender,
      silverMist: silverMist ?? this.silverMist,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      // ...
      sparklePink: Color.lerp(sparklePink, other.sparklePink, t),
      crownGold: Color.lerp(crownGold, other.crownGold, t),
      goldHighlight: Color.lerp(goldHighlight, other.goldHighlight, t),
      deepPurpleNight: Color.lerp(deepPurpleNight, other.deepPurpleNight, t),
      mistyLavender: Color.lerp(mistyLavender, other.mistyLavender, t),
      silverMist: Color.lerp(silverMist, other.silverMist, t),
    );
  }
}

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  // scaffoldBackgroundColor: const Color(0xFF0D0D0D),
  scaffoldBackgroundColor: const Color(0xFF120E1A), // 아주 어두운 보라색 배경으로 변경

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
  ),
  // ...
  extensions: const <ThemeExtension<dynamic>>[
    AppColors(
      // midnightBlack: Color(0xFF0D0D0D),
      // royalDeepPurple: Color(0xFF1C0B33),
      sparklePink: Color(0xFFFFB6E6),

      // 황금색을 2가지로 나눠서 그라데이션 효과
      crownGold: Color(0xFFE3A802), // 더 깊고 진한 금색
      goldHighlight: Color(0xFFFFF4D1), // 빛나는 하이라이트 금색

      deepPurpleNight: Color(0xFF120E1A), // 새로운 배경색
      mistyLavender: Color(0xFFD8BFD8),
      silverMist: Color(0xFF4A4A5A),
    ),
  ],
);
