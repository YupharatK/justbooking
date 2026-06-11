import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

void main() async {
  // Try to read baseUrl from api_config.dart
  final configContent = await File('lib/core/api_config.dart').readAsString();
  final RegExp regex = RegExp(r"baseUrl\s*=\s*'([^']+)'");
  final match = regex.firstMatch(configContent);
  if (match == null) {
    print("Could not find baseUrl");
    return;
  }
  final baseUrl = match.group(1);
  print("Base URL: $baseUrl");

  // Fetch dormitories
  try {
    final response = await http.get(Uri.parse('$baseUrl/api/dormitories/1'));
    print("Status: ${response.statusCode}");
    if (response.body.isNotEmpty) {
      print("Body: ${response.body}");
    }
  } catch (e) {
    print("Error: $e");
  }
}
