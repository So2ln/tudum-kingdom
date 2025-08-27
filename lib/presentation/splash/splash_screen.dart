import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tudum_kingdom/presentation/theme/build_context_ext.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 3초 후에 홈 화면으로 이동
    Timer(const Duration(seconds: 3), () {
      // 'replace'를 사용하면 스플래시 화면으로 다시 돌아올 수 없게 해줌
      if (mounted) {
        context.replace('/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.deepPurpleNight, // 앱 테마 배경색과 통일
      body: Center(
        child: Image.asset('assets/images/Tudum_Kingdom.png'),
      ),
    );
  }
}
