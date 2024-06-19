import 'package:absensi_adhimix/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Adhimix Yuk Absen",
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          surface: Colors.white,
          primary: Color(0xFFEB0009),
          secondary: Color(0xFF840005),
          tertiary: Color(0xFF5F5E5E),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

TextStyle get subHeadingStyle {
  return GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.grey[400],
    ),
  );
}

TextStyle get headingStyle {
  return GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.bold,
    ),
  );
}
