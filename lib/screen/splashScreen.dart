import 'package:aisyahh_store/admin/adminlogin.dart';
import 'package:flutter/material.dart';
import 'homeScreen.dart'; // Import halaman Home
import 'loginScreen.dart'; // Import halaman Login
import 'createAccountScreen.dart'; // Import halaman Create Account

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Gambar logo
            Container(
              height: 500,
              color: Colors.brown,
              child: Center(
                child: Image.asset(
                  'assets/images/splash_screen.png',
                  width: 400,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Teks dan Tombol
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Text(
                    'Temukan Gaya Terbaikmu dengan Aisyah Thrift',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Belanja produk thrift berkualitas dengan harga terbaik. Aisyah Thrift, solusi fashion yang cerdas dan hemat.',
                    style: TextStyle(fontSize: 16, color: Colors.brown[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigasi ke halaman Home
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                    ),
                    child: const Text('Belanja Sekarang'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigasi ke halaman Login
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: Text(
                      'Sudah punya akun? Masuk',
                      style: TextStyle(color: Colors.brown[600]),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigasi ke halaman Create Account
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateAccountScreen()),
                      );
                    },
                    child: Text(
                      'Belum punya akun? Buat Akun Baru',
                      style: TextStyle(color: Colors.brown[600]),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigasi ke halaman Login Admin
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AdminLoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                    ),
                    child: const Text('Login sebagai Admin'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
