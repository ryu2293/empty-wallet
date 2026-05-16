import 'package:flutter/material.dart';

class MydataScreen extends StatelessWidget {
  const MydataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF0DF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Image.asset(
                'assets/characters/character_oo.png',
                width: 80,
                height: 80,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Image.asset(
                  'assets/characters/character_normal.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '마이데이터에 접근해야해요',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C2C3E),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '온라인 소비 습관과 고정 지출 내역을 분석하려면\n결제 내역에 접근해야 해요',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8D8D9E),
                  height: 1.6,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/analyzing'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB18160),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    '접근 허용하기',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: const Text(
                    '자세히보기 >',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8D8D9E),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
