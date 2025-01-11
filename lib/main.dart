import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netflix_clone/screens/splash/splash_screen.dart';

import 'screens/details/detail_screen.dart';
import 'screens/main/main_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Netflix Clone',
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(
              nextScreen: MainScreen(),
            ),
        '/details': (context) => const MovieDetailScreen(),
        '/main': (context) => const MainScreen(),
      },
    );
  }
}
