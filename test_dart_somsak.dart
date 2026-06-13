import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final url = Uri.parse('https://just-booking-backend.onrender.com/api/auth/register');
  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  final body = {
    'email': 'somsak@gmail.com',
    'password': '123456',
    'role': 'member',
    'firstName': 'สมศักดิ์',
    'lastName': 'โชคดี',
    'phone': '0655555555',
    'address': '672 มหาสารคาม',
  };
  final response = await http.post(url, headers: headers, body: jsonEncode(body));
  print(response.statusCode);
  print(response.body);
}
