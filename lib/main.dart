import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'home_screen.dart';

void main() {
  runApp(const AbsherInsightApp());
}

class AbsherInsightApp extends StatelessWidget {
  const AbsherInsightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Absher Insight',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ar', 'SA')],
      locale: const Locale('ar', 'SA'),
      theme: ThemeData(
        primaryColor: const Color(0xFF007A5E),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}