// 맘에드는 금색이 없어서 텍스트에 그라데이션 적용하는 위젯 만들어봄

import 'package:flutter/material.dart';
import 'package:tudum_kingdom/presentation/theme/build_context_ext.dart';

class GoldenText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  const GoldenText(
    this.text, {
    super.key,
    required this.fontSize,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          context.colors.goldHighlight!,
          context.colors.crownGold!,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontFamily: 'Cinzel Decorative'),
      ),
    );
  }
}
