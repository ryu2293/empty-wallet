import 'dart:math';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'speech_bubble_widget.dart';

class CharacterRingWidget extends StatelessWidget {
  final int demoStep;
  final String goalName;

  const CharacterRingWidget({
    super.key,
    required this.demoStep,
    required this.goalName,
  });

  @override
  Widget build(BuildContext context) {
    final configs = [
      _StepConfig(
        percent: 0.053,
        ringColor: const Color(0xFFA8D5A2),
        imagePath: 'assets/characters/character_happy.png',
        imageSize: 170,
        speechText: '$goalName~ 드가자~',
      ),
      _StepConfig(
        percent: 0.194,
        ringColor: const Color(0xFFF4B860),
        imagePath: 'assets/characters/character_normal.png',
        imageSize: 190,
        speechText: '$goalName가 보이기 시작~',
      ),
      _StepConfig(
        percent: 0.70,
        ringColor: const Color(0xFFE57373),
        imagePath: 'assets/characters/character_sad.png',
        imageSize: 160,
        speechText: '잘하자..?',
      ),
    ];

    final cfg = configs[demoStep];
    const double outerRadius = 130;
    const double ringLineWidth = 18;
    const double widgetSize = outerRadius * 2 + 16;

    return SizedBox(
      width: widgetSize,
      height: widgetSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 점선 내부 원 (링 안쪽)
          SizedBox(
            width: widgetSize,
            height: widgetSize,
            child: CustomPaint(
              painter: DashedCirclePainter(),
            ),
          ),
          // 원형 진행 링
          CircularPercentIndicator(
            radius: outerRadius,
            lineWidth: ringLineWidth,
            percent: cfg.percent,
            backgroundColor: const Color(0xFFE8D5B0),
            progressColor: cfg.ringColor,
            circularStrokeCap: CircularStrokeCap.round,
            center: Image.asset(
              cfg.imagePath,
              width: cfg.imageSize,
              height: cfg.imageSize,
              fit: BoxFit.contain,
            ),
          ),
          // 말풍선
          Positioned(
            top: 22,
            right: 8,
            child: SpeechBubbleWidget(text: cfg.speechText),
          ),
        ],
      ),
    );
  }
}

class _StepConfig {
  final double percent;
  final Color ringColor;
  final String imagePath;
  final double imageSize;
  final String speechText;

  const _StepConfig({
    required this.percent,
    required this.ringColor,
    required this.imagePath,
    required this.imageSize,
    required this.speechText,
  });
}

class DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD9C9A3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    const double radius = 100.0;
    const double dashLength = 4.0;
    const double gapLength = 6.0;

    final double circumference = 2 * pi * radius;
    final int dashCount = (circumference / (dashLength + gapLength)).floor();

    for (int i = 0; i < dashCount; i++) {
      final double startAngle =
          (i * (dashLength + gapLength) / circumference) * 2 * pi - pi / 2;
      final double sweepAngle = (dashLength / circumference) * 2 * pi;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(DashedCirclePainter oldDelegate) => false;
}
