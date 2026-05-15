import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/demo_data.dart';
import '../widgets/character_ring_widget.dart';
import '../widgets/quest_item_widget.dart';
import '../widgets/spending_item_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  final _questKey = GlobalKey();
  int _navIndex = 0;

  String _goalName = '오사카 여행';
  int _goalAmount = 800000;
  int _dDay = 0;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('goal_name') ?? '오사카 여행';
    final amount = prefs.getInt('goal_amount') ?? 800000;
    final dateStr = prefs.getString('goal_date') ?? '';
    int dDay = 0;
    if (dateStr.isNotEmpty) {
      try {
        final goalDate = DateTime.parse(dateStr);
        final today = DateTime.now();
        final todayOnly = DateTime(today.year, today.month, today.day);
        dDay = goalDate.difference(todayOnly).inDays;
      } catch (_) {}
    }
    setState(() {
      _goalName = name;
      _goalAmount = amount;
      _dDay = dDay;
    });
  }

  String _formatAmount(int amount) {
    final s = amount.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  void _scrollToQuest() {
    final ctx = _questKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 400));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DemoState>(
      builder: (context, demo, _) {
        final step = demo.step;
        return Scaffold(
          backgroundColor: const Color(0xFFF5EDD9),
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    _buildAppBar(),
                    if (step == 1)
                      _buildBanner(
                        color: const Color(0xFFF4B860),
                        text: '25일 가까워졌어요',
                      ),
                    if (step == 2)
                      _buildBanner(
                        color: const Color(0xFFE57373),
                        text: '10일 밖에 없어요',
                      ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            // D-day 표시 (링 상단 좌측, 크게)
                            Text(
                              'D-$_dDay',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3E2723),
                              ),
                            ),
                            const SizedBox(height: 4),
                            // 캐릭터 + 링 (가운데 정렬)
                            Center(
                              child: CharacterRingWidget(
                                demoStep: step,
                                goalName: _goalName,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // 금액 표시
                            Center(child: _buildAmountRow(step)),
                            const SizedBox(height: 20),
                            _buildQuestSection(step),
                            const Divider(
                                color: Color(0xFFD9C9A3), height: 32),
                            _buildSpendingSection(step),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // 투명 시연 버튼 (우측 상단 80x80, opacity 0.0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: () => demo.nextStep(),
                    child: Opacity(
                      opacity: 0.0,
                      child: Container(
                        width: 80,
                        height: 80,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomNav(),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
            ),
            child: const Text(
              '홈',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3E2723),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Text(' | ', style: TextStyle(color: Color(0xFF8D6E63))),
          ),
          GestureDetector(
            onTap: _scrollToQuest,
            child: const Text(
              '퀘스트',
              style: TextStyle(fontSize: 16, color: Color(0xFF8D6E63)),
            ),
          ),
          const Spacer(),
          const Icon(Icons.settings_outlined,
              color: Color(0xFF3E2723), size: 22),
          const SizedBox(width: 12),
          const Icon(Icons.notifications_outlined,
              color: Color(0xFF3E2723), size: 22),
        ],
      ),
    );
  }

  Widget _buildBanner({required Color color, required String text}) {
    return Container(
      width: double.infinity,
      color: color,
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAmountRow(int step) {
    final spendAmounts = ['42,500', '155,000', '560,000'];
    final spendColors = [
      const Color(0xFF5C9E6B),
      const Color(0xFFE08C3A),
      const Color(0xFFE53935),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          spendAmounts[step],
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: spendColors[step],
          ),
        ),
        const Text(' / ',
            style: TextStyle(fontSize: 16, color: Color(0xFF8D6E63))),
        Text(
          '${_formatAmount(_goalAmount)}원',
          style:
              const TextStyle(fontSize: 16, color: Color(0xFF8D6E63)),
        ),
      ],
    );
  }

  Widget _buildQuestSection(int step) {
    final weekLabels = ['1주차 퀘스트', '5주차 퀘스트', '13주차 퀘스트'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      key: _questKey,
      children: [
        Row(
          children: [
            Text(
              weekLabels[step],
              style: const TextStyle(fontSize: 14, color: Color(0xFF8D6E63)),
            ),
            const Spacer(),
            if (step == 1)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4B860),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '수정됐요',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (step == 0) ...[
          const QuestItemWidget(
            checked: true,
            text: '쿠팡 주 1회 이하',
            subText: '이번 주 0회',
            reward: '+17,500원',
            rewardColor: Color(0xFF5C9E6B),
          ),
          const QuestItemWidget(
            checked: true,
            text: '배달의민족 주 2회 이하',
            subText: '이번 주 0회',
            reward: '+25,000원',
            rewardColor: Color(0xFF5C9E6B),
          ),
        ],
        if (step == 1) ...[
          const QuestItemWidget(
            checked: true,
            text: '쿠팡 주 1회 이하',
            subText: '이번 주 1회',
            reward: '+17,500원',
            rewardColor: Color(0xFF5C9E6B),
          ),
          const QuestItemWidget(
            checked: false,
            text: '배달의민족 주 1회 이하',
            subText: '이번 주 1회',
            reward: '+25,000원',
            rewardColor: Color(0xFF5C9E6B),
            isModified: true,
            oldText: '배달의민족 주 2회 이하',
          ),
        ],
        if (step == 2) ...[
          const QuestItemWidget(
            checked: true,
            text: '쿠팡 주 1회 이하',
            subText: '이번 주 6회',
            reward: '+17,500원',
            rewardColor: Color(0xFF5C9E6B),
          ),
          const QuestItemWidget(
            checked: false,
            text: '배달의민족 주 2회 이하',
            subText: '이번 주 6회',
            reward: '-100,000원',
            rewardColor: Color(0xFFE53935),
          ),
        ],
      ],
    );
  }

  Widget _buildSpendingSection(int step) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              '오늘 온라인 소비',
              style: TextStyle(fontSize: 14, color: Color(0xFF8D6E63)),
            ),
            Spacer(),
          ],
        ),
        const SizedBox(height: 8),
        if (step == 0)
          const SpendingItemWidget(
            name: '없음',
            amount: '-0원',
            color: Color(0xFF8D6E63),
          ),
        if (step == 1)
          const SpendingItemWidget(
            name: '무신사',
            amount: '-25,000원',
            color: Color(0xFFE08C3A),
          ),
        if (step == 2) ...[
          const SpendingItemWidget(
            name: '쿠팡',
            amount: '-17,500원',
            color: Color(0xFFE53935),
          ),
          const SpendingItemWidget(
            name: 'ABLY',
            amount: '-40,000원',
            color: Color(0xFFE53935),
          ),
        ],
      ],
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFFD9C9A3),
      selectedItemColor: const Color(0xFF3E2723),
      unselectedItemColor: const Color(0xFF8D6E63),
      currentIndex: _navIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        if (index == 0) setState(() => _navIndex = 0);
      },
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded), label: '홈'),
        BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded), label: '검색'),
        BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded), label: '분석'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded), label: '프로필'),
      ],
    );
  }
}
