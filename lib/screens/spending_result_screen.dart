import 'package:flutter/material.dart';

class SpendingResultScreen extends StatefulWidget {
  const SpendingResultScreen({super.key});

  @override
  State<SpendingResultScreen> createState() => _SpendingResultScreenState();
}

class _SpendingResultScreenState extends State<SpendingResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF0DF),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '6개월 온라인 소비 중 자주\n일어나는 소비를 찾았어요',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C2C3E),
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '이 습관을 개선한 로드맵을 짜드릴게요',
                    style: TextStyle(fontSize: 13, color: Color(0xFF8D8D9E)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, _) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SpendingBar(
                        amount: '월 평균 20만원',
                        category: '배달의민족',
                        targetRatio: 1.0,
                        progress: _animation.value,
                        color: const Color(0xFFE07070),
                      ),
                      const SizedBox(height: 28),
                      _SpendingBar(
                        amount: '월 평균 14만원',
                        category: '쿠팡',
                        targetRatio: 0.7,
                        progress: _animation.value,
                        color: const Color(0xFFE07070),
                      ),
                      const SizedBox(height: 28),
                      _SpendingBar(
                        amount: '기타',
                        category: null,
                        targetRatio: 0.3,
                        progress: _animation.value,
                        color: const Color(0xFFCCC5B9),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 32),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/goal'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB18160),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    '다음',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpendingBar extends StatelessWidget {
  final String amount;
  final String? category;
  final double targetRatio;
  final double progress;
  final Color color;

  const _SpendingBar({
    required this.amount,
    required this.category,
    required this.targetRatio,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          amount,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C2C3E),
          ),
        ),
        if (category != null) ...[
          const SizedBox(height: 2),
          Text(
            category!,
            style: const TextStyle(fontSize: 12, color: Color(0xFF8D8D9E)),
          ),
        ],
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * targetRatio * progress,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ],
    );
  }
}
