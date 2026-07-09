import 'package:flutter/material.dart';
import 'screens/scan_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FallGuardApp());
}

class FallGuardApp extends StatelessWidget {
  const FallGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Premium technical blue seed
    const brandBlue = Color(0xFF0F62FE);

    return MaterialApp(
      title: 'FallGuard AI',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark, // Camera apps feel best in dark UI
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: brandBlue,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: brandBlue,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const ScanScreen(),
    );
  }
}
