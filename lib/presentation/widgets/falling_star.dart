import 'dart:math';
import 'package:flutter/material.dart';

class FallingStar extends StatefulWidget {
  const FallingStar({super.key});

  @override
  State<FallingStar> createState() => _FallingStarState();
}

class _FallingStarState extends State<FallingStar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double _topPosition;
  late double _leftPosition;
  late double _size;
  late Duration _duration;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _resetStar(); // 별의 초기 상태

    _controller = AnimationController(
      duration: _duration,
      vsync: this,
    );

    // 애니메이션이 시작될 때 위에서 아래로 떨어지도록 값을 변경하기
    final animation =
        Tween<double>(begin: _topPosition, end: 1.0).animate(_controller);

    animation.addListener(() {
      setState(() {
        _topPosition = animation.value;
      });
    });

    // 애니메이션이 끝나면 별을 다시 리셋하고 처음부터 시작!
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _resetStar();
        });
        _controller.duration = _duration;
        _controller.forward(from: 0.0);
      }
    });

    _controller.forward();
  }

  // 별의 위치, 크기, 속도를 무작위로 설정하는 함수
  void _resetStar() {
    _topPosition = -0.2; // 화면 위에서 시작
    _leftPosition = _random.nextDouble(); // 가로 위치는 랜덤
    _size = _random.nextDouble() * 4 + 1; // 1~5 사이의 랜덤 크기
    _duration = Duration(seconds: _random.nextInt(5) + 3); // 3~7초 사이의 랜덤 속도
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Positioned(
      top: _topPosition * screenHeight,
      left: _leftPosition * screenWidth,
      child: Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          color: const Color(0xFFFFD700), // Crown Gold
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD700).withOpacity(0.8),
              blurRadius: _size * 2,
              spreadRadius: _size / 2,
            ),
          ],
        ),
      ),
    );
  }
}
