import 'package:aisyahh_store/admin/adminlogin.dart';
import 'package:aisyahh_store/admin/dashboardAdmin.dart';
import 'package:aisyahh_store/cardProvider.dart';
import 'package:aisyahh_store/screen/accountScreen.dart';
import 'package:aisyahh_store/screen/completeAccountScreen.dart';
import 'package:aisyahh_store/screen/createAccountScreen.dart';
import 'package:aisyahh_store/screen/homeScreen.dart';
import 'package:aisyahh_store/screen/loginScreen.dart';
import 'package:aisyahh_store/screen/order.dart';
import 'package:aisyahh_store/screen/profileScreen.dart';
import 'package:aisyahh_store/screen/shiptoScreen.dart';
import 'package:aisyahh_store/screen/splashScreen.dart';
import 'package:aisyahh_store/screen/sucsesScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Aisyahh Store',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.brown),

        // Gunakan initialRoute untuk menentukan halaman awal
        initialRoute: '/kerjabagus',

        // Rute untuk aplikasi
        routes: {
          '/': (context) => const SplashScreen(),
          '/adminlog': (context) => const AdminLoginScreen(),
          '/admin': (context) => const AdminDashboard(),
          '/home': (context) => HomeScreen(),
          '/sign_in': (context) => const LoginScreen(),
          '/sign_up': (context) => const CreateAccountScreen(),
          '/complete_profile': (context) => const CompleteProfileScreen(),
          '/account': (context) => AccountScreen(),
          '/profile': (context) => ProfileScreen(),
          '/address': (context) => AddressScreen(),
          '/kerjabagus': (context) => SuccessScreen(),
          '/order': (context) => OrderScreen(),
        },

        // Tampilkan halaman error jika rute tidak ditemukan
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: const Text('Page Not Found')),
              body: Center(
                child: Text('Halaman tidak ditemukan: ${settings.name}'),
              ),
            ),
          );
        },
      ),
    );
  }
}
