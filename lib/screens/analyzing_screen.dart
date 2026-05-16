import 'dart:async';
import 'package:flutter/material.dart';

class AnalyzingScreen extends StatefulWidget {
  const AnalyzingScreen({super.key});

  @override
  State<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends State<AnalyzingScreen> {
  static const _frames = [
    'assets/characters/character_1.png',
    'assets/characters/character_2.png',
    'assets/characters/character_3.png',
    'assets/characters/character_4.png',
    'assets/characters/character_5.png',
  ];

  int _frameIndex = 0;
  Timer? _animTimer;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();
    // 프레임 전환: 150ms마다 (빠른 스피닝 효과)
    _animTimer = Timer.periodic(const Duration(milliseconds: 150), (_) {
      setState(() => _frameIndex = (_frameIndex + 1) % _frames.length);
    });
    // 3.5초 후 온보딩으로 이동
    _navTimer = Timer(const Duration(milliseconds: 3500), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/spending_result');
    });
  }

  @override
  void dispose() {
    _animTimer?.cancel();
    _navTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF0DF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              _frames[_frameIndex],
              width: 90,
              height: 90,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Image.asset(
                'assets/characters/character_normal.png',
                width: 90,
                height: 90,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '3개월치 소비내역\n분석 중이에요...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C2C3E),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
