import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _onNext() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('goal_name', name);
    if (mounted) Navigator.pushReplacementNamed(context, '/goal_amount');
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = _controller.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFFEF0DF),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '목표가 있나요?',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C2C3E),
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '어떤 걸 하고 싶어요?\n구체적이든 추상적이든 모두 좋아요.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF8D8D9E),
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'ex) 아이폰 17, 보라카이 여행, 여자친구 생일 선물..',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFB0AEAE),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  autofocus: false,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2C2C3E),
                  ),
                  decoration: const InputDecoration(
                    hintText: '하고 싶은 걸 입력하세요',
                    hintStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFFB0AEAE),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFB0AEAE), width: 1),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFB0AEAE), width: 1),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF2C2C3E), width: 1.5),
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.only(bottom: 8),
                  ),
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => _onNext(),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 0, 28, 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: hasValue ? _onNext : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB18160),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      disabledBackgroundColor: const Color(0xFFE0D9CE),
                      disabledForegroundColor: const Color(0xFF8D8D9E),
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
      ),
    );
  }
}
