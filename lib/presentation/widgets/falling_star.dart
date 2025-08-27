import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tudum_kingdom/presentation/theme/build_context_ext.dart';

class FallingStar extends StatefulWidget {
  const FallingStar({super.key, required this.delay});
  final Duration delay;

  @override
  State<FallingStar> createState() => _FallingStarState();
}

class _FallingStarState extends State<FallingStar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final Random _random = Random();

  late double _topPosition;
  late double _leftPosition;
  late double _size;

  @override
  void initState() {
    super.initState();

    // 별의 위치, 크기, 속도를 무작위로 설정
    _topPosition = -0.2; // 화면 위에서 시작
    _leftPosition = _random.nextDouble(); // 가로 위치는 랜덤
    _size = _random.nextDouble() * 4 + 1; // 1~5 사이의 랜덤 크기
    // duration = Duration(seconds: _random.nextInt(5) + 3); // 3~7초 사이의 랜덤 속도
    final duration =
        Duration(seconds: _random.nextInt(6) + 1); // 15~20초 사이의 랜덤 속도

    _controller = AnimationController(duration: duration, vsync: this);
    _animation = Tween<double>(begin: -0.2, end: 1.2).animate(_controller);

// 애니메이션의 상태를 감시하는 리스너를 추가합시다
    _controller.addStatusListener((status) {
      // 애니메이션이 끝나면 (completed)
      if (status == AnimationStatus.completed) {
        // 다시 처음부터 시작하도록
        _controller.forward(from: 0.0);
      }
    });

// 그리고! 화면 켜진 후부터 시작되면 처음에는 줄지어서 나타나니까, 별들의 시작위치도 무작위로 지정해주기!

    Future.delayed(widget.delay, () {
      if (mounted) {
        // 시작 지점을 무작위로 정해주고,
        _controller.value = _random.nextDouble();
        // repeat 대신 앞으로 가서 리스너가 다음 루프 실행하도록
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _animation.value * context.sh,
      left: _leftPosition * context.sw,
      child: Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          color: context.colors.crownGold,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: context.colors.crownGold!.withOpacity(0.8),
              blurRadius: _size * 2,
              spreadRadius: _size / 2,
            ),
          ],
        ),
      ),
    );
  }
}
