import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeProvider? _themeProvider;
  StorageService? _storageService;

  Future<void> _initializeApp() async {
    // Initialize providers
    _themeProvider = ThemeProvider();
    await _themeProvider!.init();

    _storageService = StorageService();
    await _storageService!.init();

    // Trigger rebuild after initialization
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show splash screen while initializing
    if (_themeProvider == null || _storageService == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: SplashScreen(
          onInit: _initializeApp,
          child: const SizedBox(), // Placeholder, won't be shown
        ),
      );
    }

    // App is initialized, show main app
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _themeProvider!),
        ChangeNotifierProvider.value(value: _storageService!),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Loan Tracker',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
