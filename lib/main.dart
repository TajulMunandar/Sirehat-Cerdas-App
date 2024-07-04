import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sirehat_cerdas/Pages/chat.dart';
import 'package:sirehat_cerdas/Pages/landing.dart';
import 'package:sirehat_cerdas/Pages/login.dart';
import 'package:sirehat_cerdas/Pages/registrasi-add.dart';
import 'package:sirehat_cerdas/Pages/riwayat.dart';

import 'package:sirehat_cerdas/Pages/splash.dart';
import 'package:sirehat_cerdas/Pages/registrasi.dart';
import 'package:sirehat_cerdas/Pages/konsultasi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      title: 'Sirehat Cerdas',
      home: SplashScreen(),
      routes: {
        '/login': (context) => Login(),
        '/home': (context) => HomePage(),
        '/registration': (context) => RegistrationPage(),
        '/konsultasi': (context) => Konsultasi(),
        '/registration-add': (context) => RegistrationAddPage(),
        '/riwayat': (context) => RiwayatPage(),
        '/chat': (context) => ChatPage(),
      }, // Gunakan SplashScreen sebagai halaman utama
    );
  }
}
