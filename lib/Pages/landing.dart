import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sirehat_cerdas/component/nav.dart';
import 'package:sirehat_cerdas/component/constant/dimens.dart' as example;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:sirehat_cerdas/service/logout.dart';

class DoctorModel {
  String name;
  List<String> services;

  DoctorModel({
    required this.name,
    required this.services,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      name: json['nama'],
      services: [Service.fromPoli(json['poli'])],
    );
  }
}

class Service {
  static String umum = "Poli Umum";
  static String gigi = "Poli Gigi";
  static String anak = "Poli Anak";
  static String ibuAndAnak = "Poli Anak & Ibu";
  static String ptm = "Poli Penyakit Tidak Menular";

  static String fromPoli(String poli) {
    switch (poli) {
      case "umum":
        return umum;
      case "gigi":
        return gigi;
      case "anak":
        return anak;
      case "ibu dan anak":
        return ibuAndAnak;
      case "ptm":
        return ptm;
      default:
        return umum;
    }
  }

  static List<String> all() {
    return [umum, gigi, anak, ibuAndAnak, ptm];
  }
}

Future<List<DoctorModel>> fetchDoctors() async {
  final response =
      await http.get(Uri.parse('https://sirehatcerdas.online/api/dokter'));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final List<dynamic> doctorsData = jsonData['dokters'];
    List<DoctorModel> doctorList =
        doctorsData.map((doctor) => DoctorModel.fromJson(doctor)).toList();

    return doctorList;
  } else {
    throw Exception('Failed to load doctors');
  }
}

Future<String?> _loadUserProfile() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final userProfile = prefs.getString('user_profile');
  if (userProfile != null) {
    final userData = json.decode(userProfile);
    return userData['username'];
  }
  return null;
}

class HomePage extends StatefulWidget {
  @override
  HomePage({super.key});
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  var selectedMenu = 0;
  var selectedService = 0;
  List<DoctorModel> doctors = [];
  String searchQuery = "";
  String formattedTime = DateFormat.Hm().format(DateTime.now());

  List<DoctorModel> get filteredDoctors {
    String selectedServiceName = Service.all()[selectedService];

    // Filter berdasarkan layanan yang dipilih
    List<DoctorModel> filteredByService = doctors
        .where((doctor) => doctor.services.contains(selectedServiceName))
        .toList();

    // Filter berdasarkan pencarian nama dokter
    List<DoctorModel> filteredBySearch = filteredByService
        .where((doctor) =>
            doctor.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return filteredBySearch;
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
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
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const SizedBox(
        height: example.Dimens.heightNormal,
        width: example.Dimens.widthNormal,
      ),
      bottomNavigationBar: MyBottomNavigator(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            FutureBuilder<String?>(
              future: _loadUserProfile(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final userName = snapshot.data ?? 'Guest';
                  return _greetings(userName);
                }
              },
            ),
            const SizedBox(
              height: 16,
            ),
            _card(),
            const SizedBox(
              height: 20,
            ),
            _search(),
            const SizedBox(
              height: 20,
            ),
            _services(),
            const SizedBox(
              height: 27,
            ),
            _doctors()
          ],
        ),
      )),
    );
  }

  ListView _doctors() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        FutureBuilder<List<DoctorModel>>(
          future: fetchDoctors(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No doctors found'));
            } else {
              doctors = snapshot.data!;
              return Column(
                children:
                    filteredDoctors.map((doctor) => _doctor(doctor)).toList(),
              );
            }
          },
        ),
      ],
    );
  }

  Container _doctor(DoctorModel doctorModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF35385A).withOpacity(.12),
            blurRadius: 30,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          ),
          const SizedBox(
            width: 20,
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctorModel.name,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3F3E3F),
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                RichText(
                  text: TextSpan(
                    text: "Poli: ${doctorModel.services.join(', ')}",
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                Row(
                  children: [
                    Text(
                      "Available at : 07.00 - 16:00 Wib",
                      style: GoogleFonts.manrope(
                        color: const Color(0xFF50CC98),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    // SvgPicture.asset('assets/svgs/cat.svg'),
                    const SizedBox(
                      width: 10,
                    ),
                    // SvgPicture.asset('assets/svgs/dog.svg'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _services() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            setState(() {
              selectedService = index;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: selectedService == index
                  ? const Color(0xFF1580EB)
                  : const Color(0xFFF6F6F6),
              border: selectedService == index
                  ? Border.all(
                      color: const Color(0xFFF1E5E5).withOpacity(.22),
                      width: 2,
                    )
                  : null,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                Service.all()[index],
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: selectedService == index
                      ? Colors.white
                      : const Color(0xFF3F3E3F).withOpacity(.3),
                ),
              ),
            ),
          ),
        ),
        separatorBuilder: (context, index) => const SizedBox(
          width: 10,
        ),
        itemCount: Service.all().length,
      ),
    );
  }

  Widget _search() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextFormField(
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFFADACAD),
          ),
          hintText: "Find Best Doctor...",
          hintStyle: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFCACACA),
            height: 150 / 100,
          ),
        ),
      ),
    );
  }

  AspectRatio _card() {
    return AspectRatio(
      aspectRatio: 336 / 184,
      child: Container(
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: const Color(0xFF1580EB),
        ),
        child: Stack(children: [
          Positioned(
            left: MediaQuery.of(context).size.width *
                0.1, // Mengatur posisi relatif ke kanan
            child: Container(
              width: 250, // Lebar sesuai kebutuhan
              height: 250, // Tinggi sesuai kebutuhan
              child: Lottie.asset(
                'assets/doctor.json',
                fit: BoxFit.cover,
                repeat: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(
                        text: "Periksakan Kesehatan ",
                        style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: const Color(0xFFDEE1FE),
                            height: 150 / 100),
                        children: [
                      TextSpan(
                          text: "\nKeluarga Anda! ",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800)),
                    ])),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.4),
                      border: Border.all(
                          color: Colors.white.withOpacity(.12), width: 2),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    "$formattedTime WIB",
                    style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }

  Padding _greetings(String userName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Halo, $userName!",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF3F3E3F),
            ),
          ),
        ],
      ),
    );
  }
}
