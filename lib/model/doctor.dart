import 'dart:convert';
import 'package:http/http.dart' as http;

class DoctorModel {
  String name;
  String image;
  List<String> services;

  DoctorModel({
    required this.name,
    required this.image,
    required this.services,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      name: json['nama'],
      image: "Dr. Stone.jpg", // Placeholder image as API doesn't provide images
      services: [Service.fromPoli(json['poli'])],
    );
  }
}

class Service {
  static String semua = "semua";
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
        return semua;
    }
  }

  static List<String> all() {
    return [semua, umum, gigi, anak, ibuAndAnak, ptm];
  }
}

Future<List<DoctorModel>> fetchDoctors() async {
  final response =
      await http.get(Uri.parse('https://sirehatcerdas.online/api/dokter'));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final List<dynamic> doctorsData = jsonData['dokters'];

    return doctorsData.map((doctor) => DoctorModel.fromJson(doctor)).toList();
  } else {
    throw Exception('Failed to load doctors');
  }
}
