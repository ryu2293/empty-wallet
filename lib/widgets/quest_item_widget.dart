import 'package:flutter/material.dart';

class QuestItemWidget extends StatelessWidget {
  final bool checked;
  final String text;
  final String subText;
  final String reward;
  final Color rewardColor;
  final bool isModified;
  final String oldText;

  const QuestItemWidget({
    super.key,
    required this.checked,
    required this.text,
    required this.subText,
    required this.reward,
    required this.rewardColor,
    this.isModified = false,
    this.oldText = '',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            checked ? Icons.check_circle : Icons.radio_button_unchecked,
            color: checked ? const Color(0xFF5C9E6B) : const Color(0xFF8D6E63),
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isModified)
                  Text(
                    oldText,
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Color(0xFF8D6E63),
                      fontSize: 12,
                    ),
                  ),
                Text(
                  text,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF3E2723)),
                ),
                Text(
                  subText,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF8D6E63)),
                ),
              ],
            ),
          ),
          Text(
            reward,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: rewardColor,
            ),
          ),
        ],
      ),
    );
  }
}
