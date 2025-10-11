import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'screens/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: AppStyles.primaryColor.withValues(alpha: 0.4),
          cursorColor: AppStyles.primaryColor,
          selectionHandleColor: AppStyles.primaryColor,
        ),
      ),
      title: 'Jawara Pintar',
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}