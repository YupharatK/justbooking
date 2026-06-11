import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'lib/models/dormitory.dart';

void main() async {
  final response = await http.get(Uri.parse('https://just-booking-backend.onrender.com/api/dormitories'));
  final data = jsonDecode(response.body);
  final list = (data['dormitories'] as List).map((json) => Dormitory.fromJson(json)).toList();
  print('Parsed \${list.length} dorms');
}
