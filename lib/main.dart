import 'package:aisyahh_store/app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aisyahh_store/cardProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('[INFO] Firebase initialized successfully.');
  } catch (e) {
    debugPrint('[ERROR] Failed to initialize Firebase: $e');
  }

  // Inisialisasi CartProvider
  final cartProvider = CartProvider();
  try {
    // Muat keranjang dari local storage terlebih dahulu
    await cartProvider.loadCartFromLocalStorage();
    debugPrint('[INFO] Cart data loaded from local storage.');

    // Periksa apakah ada pengguna yang sedang login
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Jika pengguna sedang login, sinkronkan keranjang dengan Firestore
      await cartProvider.syncCart(user.uid);
      debugPrint(
          '[INFO] Cart data synced from Firestore for user: ${user.uid}');
    }
  } catch (e) {
    debugPrint('[ERROR] Failed to load or sync cart data: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: cartProvider),
      ],
      child: const MyApp(),
    ),
  );
}
