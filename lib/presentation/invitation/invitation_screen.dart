import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tudum_kingdom/presentation/widgets/falling_star.dart';

class InvitationScreen extends StatefulWidget {
  const InvitationScreen({super.key});

  @override
  State<InvitationScreen> createState() => _InvitationScreenState();
}

class _InvitationScreenState extends State<InvitationScreen> {
  late final List<Widget> _stars;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _stars = List.generate(
      50,
      (_) => FallingStar(delay: Duration(milliseconds: _random.nextInt(5000))),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 화면 아무 곳이나 탭하면 뒤로 가도록 GestureDetector로 감싸줌
    return GestureDetector(
      onTap: () => context.pop(),
      child: Scaffold(
        // 반투명한 배경을 만들어 기존 화면이 살짝 비치게
        backgroundColor: Colors.black.withOpacity(0.85),
        body: Stack(
          children: [
            // 배경에 별똥별 효과
            Positioned.fill(
              child: IgnorePointer(child: Stack(children: _stars)),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset('assets/images/invitation.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
