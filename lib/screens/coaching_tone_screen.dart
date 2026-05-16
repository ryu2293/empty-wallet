import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoachingToneScreen extends StatefulWidget {
  const CoachingToneScreen({super.key});

  @override
  State<CoachingToneScreen> createState() => _CoachingToneScreenState();
}

class _CoachingToneScreenState extends State<CoachingToneScreen>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _confirmed = false;
  String _goalName = '목표';

  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _loadGoalName();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
  }

  Future<void> _loadGoalName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _goalName = prefs.getString('goal_name') ?? '목표');
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _onNext() async {
    final tone = _controller.text.trim();
    if (!_confirmed && tone.isNotEmpty) {
      FocusScope.of(context).unfocus();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('coaching_tone', tone);
      setState(() => _confirmed = true);
      _fadeCtrl.forward();
    } else if (_confirmed) {
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    }
  }

  bool get _hasValue => _controller.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF0DF),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: SafeArea(
          child: _confirmed ? _buildConfirmed() : _buildInput(),
        ),
      ),
    );
  }

  // ── 입력 화면 ──────────────────────────────────────────
  Widget _buildInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 60),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '어떤 톤으로 코칭 해줄까요?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C2C3E),
                  height: 1.3,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "'돈다'는 AI 소비 코치에요.\n돈다의 성격을 입력하면 그대로 코치 해줄 거에요.",
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF8D8D9E),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: Image.asset(
            'assets/characters/character_body.png',
            height: 200,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Image.asset(
              'assets/characters/character_normal.png',
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2C2C3E),
            ),
            decoration: const InputDecoration(
              hintText: '치어리더처럼 활기차게 응원해줘',
              hintStyle: TextStyle(
                fontSize: 17,
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
              onPressed: _hasValue ? _onNext : null,
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
    );
  }

  // ── 확인 화면 ──────────────────────────────────────────
  Widget _buildConfirmed() {
    final tone = _controller.text.trim();
    return FadeTransition(
      opacity: _fadeAnim,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$tone\n코칭 할게요!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C2C3E),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '$_goalName 갈 준비 됐니, 아들?\n그럼 이제 돈 모으러 가볼까요?',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8D7B6A),
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/characters/character_cheer.png',
                height: 260,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Image.asset(
                  'assets/characters/character_happy.png',
                  height: 260,
                  fit: BoxFit.contain,
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
                onPressed: _onNext,
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
    );
  }
}
