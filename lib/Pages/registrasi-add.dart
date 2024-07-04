import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sirehat_cerdas/component/nav.dart';
import 'package:sirehat_cerdas/component/constant/dimens.dart' as example;
import 'package:sirehat_cerdas/service/logout.dart';

class RegistrationAddPage extends StatefulWidget {
  @override
  _RegistrationAddPageState createState() => _RegistrationAddPageState();
}

class _RegistrationAddPageState extends State<RegistrationAddPage> {
  int _selectedIndex = 1;
  String hintText = 'tanggal';
  final TextEditingController keluhanController = TextEditingController();
  String? selectedPoli;
  String selectedDate = ''; // Inisialisasi dengan string kosong

  @override
  void initState() {
    super.initState();
    // Inisialisasi selectedDate dengan tanggal saat ini
    final now = DateTime.now();
    selectedDate = '${now.year}-${now.month}-${now.day}';
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

  Future<void> submitRegistration() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userProfile = prefs.getString('user_profile');

    if (userProfile != null) {
      final userData = json.decode(userProfile);
      final userId = userData['id'];

      String formattedPoli;
      switch (selectedPoli) {
        case 'Poli Umum':
          formattedPoli = 'umum';
          break;
        case 'Poli Anak':
          formattedPoli = 'anak';
          break;
        case 'Poli Gigi':
          formattedPoli = 'gigi';
          break;
        case 'Poli Penyakit Tidak Menular':
          formattedPoli = 'ptm';
          break;
        case 'Poli Ibu dan Anak':
          formattedPoli = 'ibu dan anak';
          break;
        default:
          formattedPoli = 'umum'; // Default jika tidak ada yang cocok
      }

      final response = await http.post(
        Uri.parse('https://sirehatcerdas.online/api/registrasi'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'id_user': userId,
          'poli': formattedPoli,
          'keluhan': keluhanController.text,
        }),
      );

      if (response.statusCode == 200) {
        print('Registration successful');
        Navigator.pushReplacementNamed(context, '/registration');
      } else {
        print('Failed to register: ${response.body}');
        throw Exception('Failed to register');
      }
    } else {
      throw Exception('User profile not found in SharedPreferences');
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Januari';
      case 2:
        return 'Februari';
      case 3:
        return 'Maret';
      case 4:
        return 'April';
      case 5:
        return 'Mei';
      case 6:
        return 'Juni';
      case 7:
        return 'Juli';
      case 8:
        return 'Agustus';
      case 9:
        return 'September';
      case 10:
        return 'Oktober';
      case 11:
        return 'November';
      case 12:
        return 'Desember';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> poliList = [
      'Poli Umum',
      'Poli Anak',
      'Poli Gigi',
      'Poli Penyakit Tidak Menular',
      'Poli Ibu'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/logo.png', // Path to your image asset
              height: 28, // Adjust the height as needed
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
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(), // Atur physics agar bisa di-scroll
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text(
                'Registrasi Pengobatan',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Periksakan Kesehatan Keluarga Anda!',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w200,
                  color: Color(0xff636973),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: DropdownButtonFormField<String>(
                  value: selectedPoli,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPoli = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.medical_services,
                      color: Color(0xff9AA2AF),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    hintText: 'Select Poli', // Hint untuk input
                  ),
                  items: poliList.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value), // Teks untuk setiap item
                    );
                  }).toList(),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.date_range,
                      color: Color(0xff9AA2AF),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                          color: Colors.blue), // Warna border saat terfokus
                    ),
                    hintText: selectedDate,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: TextField(
                  controller: keluhanController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                          color: Colors.blue), // Warna border saat terfokus
                    ),
                    hintText: 'Keluhan',
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xffffffff),
                  backgroundColor: const Color(0xFF1580EB),
                  padding: const EdgeInsets.all(8),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  submitRegistration();
                },
                child: const Text(
                  'Daftar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                  height: example.Dimens
                      .heightNormal), // Sesuaikan ukuran sesuai kebutuhan
            ],
          ),
        ),
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
