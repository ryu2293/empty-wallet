import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/demo_data.dart';
import 'screens/welcome_screen.dart';
import 'screens/income_screen.dart';
import 'screens/mydata_screen.dart';
import 'screens/analyzing_screen.dart';
import 'screens/spending_result_screen.dart';
import 'screens/goal_screen.dart';
import 'screens/goal_amount_screen.dart';
import 'screens/goal_date_screen.dart';
import 'screens/goal_plan_screen.dart';
import 'screens/coaching_tone_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => DemoState(),
      child: MyApp(initialRoute: '/welcome'),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '돈다',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'sans-serif',
        scaffoldBackgroundColor: const Color(0xFFFEF0DF),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3E2723)),
      ),
      initialRoute: initialRoute,
      routes: {
        '/welcome': (_) => const WelcomeScreen(),
        '/income': (_) => const IncomeScreen(),
        '/mydata': (_) => const MydataScreen(),
        '/analyzing': (_) => const AnalyzingScreen(),
        '/spending_result': (_) => const SpendingResultScreen(),
        '/goal': (_) => const GoalScreen(),
        '/goal_amount': (_) => const GoalAmountScreen(),
        '/goal_date': (_) => const GoalDateScreen(),
        '/goal_plan': (_) => const GoalPlanScreen(),
        '/coaching_tone': (_) => const CoachingToneScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
        '/home': (_) => const HomeScreen(),
      },
    );
  }
}
