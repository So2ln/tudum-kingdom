import 'package:flutter/material.dart';
import 'package:tudum_kingdom/presentation/theme/app_theme.dart';

// BuildContext를 확장해서 화면 사이즈에 쉽게 접근할 수 있게 따로 만들어주기
extension SizeExt on BuildContext {
  double get sw => MediaQuery.of(this).size.width; // screenWidth
  double get sh => MediaQuery.of(this).size.height; // screenHeight
}

// BuildContext를 확장해서 커스텀 테마 색상에 쉽게 접근할 수 있게 해준담
extension ThemeExt on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
