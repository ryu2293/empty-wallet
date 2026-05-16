import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoalDateScreen extends StatefulWidget {
  const GoalDateScreen({super.key});

  @override
  State<GoalDateScreen> createState() => _GoalDateScreenState();
}

class _GoalDateScreenState extends State<GoalDateScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 141));

  int get _dDay {
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final target = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    return target.difference(today).inDays;
  }

  Future<void> _onNext() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'goal_date',
      '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
    );
    if (mounted) Navigator.pushReplacementNamed(context, '/goal_plan');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF0DF),
      body: SafeArea(
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
                    '언제까지 모을까요?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C2C3E),
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '목표 날짜를 선택하면\n월 절약 금액을 계산해드릴게요.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8D8D9E),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // D-day 뱃지
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFB18160).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'D-$_dDay  ·  ${_selectedDate.year}년 ${_selectedDate.month}월 ${_selectedDate.day}일',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFB18160),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // 인라인 캘린더
            Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: Color(0xFFB18160),
                    onPrimary: Colors.white,
                    surface: Color(0xFFFEF0DF),
                    onSurface: Color(0xFF2C2C3E),
                  ),
                ),
                child: CalendarDatePicker(
                  initialDate: _selectedDate,
                  firstDate: DateTime.now().add(const Duration(days: 1)),
                  lastDate: DateTime(DateTime.now().year + 5),
                  onDateChanged: (date) => setState(() => _selectedDate = date),
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
