import 'package:flutter/material.dart';
import 'package:my_login_app/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:my_login_app/src/utils/theme/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


void main() async {
  // Initialize Supabase client (replace with your Supabase URL and anon key)
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://dztymiwemdfqpwgkpapg.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR6dHltaXdlbWRmcXB3Z2twYXBnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjQzMjg5MDYsImV4cCI6MjAzOTkwNDkwNn0.-JTCRfSKyC69IgH6kPHrp9HIHWxRxwy2qXcYESd4A3Q'
  );

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}

