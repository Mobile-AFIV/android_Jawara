import 'package:flutter/material.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jawara Pintar Dashboard'),
        backgroundColor: AppStyles.primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: AppStyles.primaryColor,
              size: 80,
            ),
            SizedBox(height: 24),
            Text(
              'Login Berhasil!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Selamat datang, Admin',
              style: TextStyle(
                fontSize: 18,
                color: AppStyles.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}