import 'package:flutter/material.dart';

class AuthService {
  // Check for specific credentials
  Future<Map<String, dynamic>> login(String email, String password) async {
    // Add validation
    if (email.isEmpty || password.isEmpty) {
      return {
        'success': false,
        'message': 'Email dan password tidak boleh kosong'
      };
    }
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Check for the specific credentials
    if (email == 'admin1@gmail.com' && password == 'password') {
      return {
        'success': true,
        'message': 'Login berhasil'
      };
    } else {
      return {
        'success': false,
        'message': 'Email atau password salah'
      };
    }
  }
}