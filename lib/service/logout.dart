import 'package:flutter/material.dart';
import 'package:sirehat_cerdas/service/auth.dart';
import 'package:sirehat_cerdas/pages/login.dart';

class Logout {
  static void performLogout(BuildContext context) {
    // Clear authentication token
    ApiService.clearToken();

    // Navigate back to login page
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) =>
              Login()), // Ganti LoginPage dengan nama halaman login Anda
      (Route<dynamic> route) => false, // Hapus semua rute sebelumnya
    );
  }
}
