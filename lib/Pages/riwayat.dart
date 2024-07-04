import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sirehat_cerdas/component/nav.dart';
import 'package:sirehat_cerdas/component/constant/dimens.dart' as example;
import 'package:sirehat_cerdas/service/logout.dart';

class Riwayat {
  final String poli;
  final String tanggal;
  final String diagnosa;
  final String keluhan;
  final String dokter;
  final String status;
  final List<String> resep;

  Riwayat({
    required this.poli,
    required this.tanggal,
    required this.diagnosa,
    required this.keluhan,
    required this.dokter,
    required this.status,
    required this.resep,
  });

  factory Riwayat.fromJson(Map<String, dynamic> json) {
    return Riwayat(
      poli: json['registrasi']['poli'],
      tanggal: json['registrasi']['tanggal'],
      diagnosa: json['diagnosa'],
      keluhan: json['registrasi']['keluhan'],
      dokter: json['dokter']['nama'],
      status: json['registrasi']['status'],
      resep: List<String>.from(json['transaksi_obat'][0]
              ['transaksi_obat_detail']
          .map((obat) => obat['obat']['nama_obat'])),
    );
  }
}

class RiwayatPage extends StatefulWidget {
  @override
  _RiwayatPageState createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  List<Riwayat> riwayatList = [];
  int _selectedIndex = 3;

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

  Future<void> fetchRiwayat() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userProfile = prefs.getString('user_profile');

    if (userProfile != null) {
      final userData = json.decode(userProfile);
      final userId = userData['id'];

      print('User ID: $userId');

      final response = await http.post(
        Uri.parse('https://sirehatcerdas.online/api/riwayat'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'id': userId,
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['kunjungans'];

        setState(() {
          riwayatList = data.map((item) => Riwayat.fromJson(item)).toList();
        });
      } else {
        throw Exception('Failed to load riwayat');
      }
    } else {
      throw Exception('User profile not found in SharedPreferences');
    }
  }

  @override
  void initState() {
    fetchRiwayat();
    super.initState();
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: riwayatList.length,
          itemBuilder: (context, index) {
            final riwayat = riwayatList[index];
            return Card(
              color: Color(0xFFE5F1FA),
              margin: EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Poli: ${riwayat.poli}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1580EB)),
                        ),
                        Text(
                          '${riwayat.tanggal}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1580EB)),
                        ),
                      ],
                    ),
                    Divider(),
                    Text('Diagnosa: ${riwayat.diagnosa}'),
                    Text('Keluhan: ${riwayat.keluhan}'),
                    Text('Dokter: ${riwayat.dokter}'),
                    Text('Status: ${riwayat.status}'),
                    Text('Resep Obat:'),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          riwayat.resep.map((obat) => Text('- $obat')).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const SizedBox(
        height: example.Dimens.heightNormal,
        width: example.Dimens.widthNormal,
      ),
      bottomNavigationBar: MyBottomNavigator(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
