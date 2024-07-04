import 'package:flutter/material.dart';
import 'package:sirehat_cerdas/component/nav.dart';
import 'package:sirehat_cerdas/component/constant/dimens.dart' as example;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:sirehat_cerdas/service/logout.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  int _selectedIndex = 1;
  List<dynamic> registrationData =
      []; // Inisialisasi registrationData sebagai list kosong

  @override
  void initState() {
    super.initState();
    fetchRegistrationData(); // Panggil fetchRegistrationData saat widget pertama kali diinisialisasi
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/registration');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/konsultasi');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/riwayat');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/registration-add');
        break;
    }
  }

  Future<void> fetchRegistrationData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userProfile = prefs.getString('user_profile');

    if (userProfile != null) {
      final userData = json.decode(userProfile);
      final userId = userData['id'];

      print('User ID: $userId');

      final response = await http.post(
        Uri.parse('https://sirehatcerdas.online/api/get-registrasi'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'id_user': userId,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          registrationData =
              data['registrations']; // Sesuaikan dengan struktur data API
        });
      } else {
        throw Exception('Failed to load registration data');
      }
    } else {
      throw Exception('User profile not found in SharedPreferences');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/logo.png', // Path to your image asset
              height: 24, // Adjust the height as needed
            ),
            GestureDetector(
              onTap: () {
                Logout.performLogout(context);
                // Implement your logout functionality here
              },
              child: Icon(
                Icons.logout, // Use the logout icon
                size: 24.0, // Adjust the size of the icon
                color: Colors.blue, // Adjust the color of the icon
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: registrationData.length,
        itemBuilder: (context, index) {
          final registration = registrationData[index];
          return Card(
            color: Color(0xFFE5F1FA),
            elevation: 3,
            margin: EdgeInsets.only(bottom: 8.0), // Margin bawah 8.0
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0), // Radius untuk Card
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12.0), // Radius untuk InkWell
              onTap: () {
                // Handle onTap for Card
              },
              child: ListTile(
                title: Container(
                  margin: EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Poli " +
                            registration[
                                'poli'], // Adjust according to your data structure
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        registration[
                            'tanggal'], // Adjust according to your data structure
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dokter: ${registration['dokter']}', // Adjust according to your data structure
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        Text(
                          'Jadwal: ${registration['jadwal_hari_ini']['rentang_waktu']} Wib', // Adjust according to your data structure
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        Text(
                          'Keluhan: ${registration['keluhan']}', // Adjust according to your data structure
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          registration['no_antrian']
                              .toString(), // Adjust according to your data structure
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                leading: Icon(
                  Icons.schedule,
                  color: Colors.blue,
                  size: 32.0,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: const SizedBox(
        height: example.Dimens.heightNormal,
        width: example.Dimens.widthNormal,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: MyBottomNavigator(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
