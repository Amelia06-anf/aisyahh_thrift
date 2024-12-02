import 'package:flutter/material.dart';

class PaymentMethodScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.qr_code),
            title: const Text('QRIS'),
            onTap: () {
              Navigator.pushNamed(context, '/success');
            },
          ),
        ],
      ),
    );
  }
}
