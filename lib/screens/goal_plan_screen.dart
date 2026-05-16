import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoalPlanScreen extends StatefulWidget {
  const GoalPlanScreen({super.key});

  @override
  State<GoalPlanScreen> createState() => _GoalPlanScreenState();
}

class _GoalPlanScreenState extends State<GoalPlanScreen> {
  int _goalAmount = 800000;
  DateTime? _targetDate;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final amount = prefs.getInt('goal_amount') ?? 800000;
    final dateStr = prefs.getString('goal_date') ?? '';
    DateTime? date;
    if (dateStr.isNotEmpty) {
      try { date = DateTime.parse(dateStr); } catch (_) {}
    }
    setState(() {
      _goalAmount = amount;
      _targetDate = date ?? DateTime.now().add(const Duration(days: 141));
    });
  }

  int get _dDay {
    if (_targetDate == null) return 0;
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final target = DateTime(_targetDate!.year, _targetDate!.month, _targetDate!.day);
    return target.difference(today).inDays;
  }

  // 만원 단위 버림
  String get _goalMan => '${(_goalAmount ~/ 10000)}만원';
  String get _monthlyMan {
    if (_dDay <= 0) return _goalMan;
    final monthly = (_goalAmount / _dDay * 30).floor();
    final man = monthly ~/ 10000;
    return '${man}만원';
  }

  Future<void> _onNext() async {
    if (mounted) Navigator.pushReplacementNamed(context, '/coaching_tone');
  }

  @override
  Widget build(BuildContext context) {
    if (_targetDate == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFFEF0DF),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFEF0DF),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '목표까지 D-${_dDay}일!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C2C3E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '월 $_monthlyMan을 절약하게 도와드릴게요.\nAI가 온라인 결제 빈도와 가용 소득을 기준으로\n현실적인 주 단위 퀘스트를 세웠어요.',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF8D8D9E),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: const [
                      _QuestCard(
                        tag: '소액결제가 반복돼요, 가용 소득 대비 지출 25%',
                        quest: '쿠팡 주 1회 이하',
                        reward: '+17,500원',
                      ),
                      SizedBox(height: 12),
                      _QuestCard(
                        tag: '야간 결제 비중이 높아요, 가용 소득 대비 지출 36%',
                        quest: '배달의민족 주 2회 이하',
                        reward: '+25,000원',
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
      ),
    );
  }
}

class _QuestCard extends StatelessWidget {
  final String tag;
  final String quest;
  final String reward;

  const _QuestCard({
    required this.tag,
    required this.quest,
    required this.reward,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tag,
            style: const TextStyle(fontSize: 11, color: Color(0xFF8D8D9E)),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.check, size: 16, color: Color(0xFFB18160)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  quest,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2C2C3E),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  reward,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
