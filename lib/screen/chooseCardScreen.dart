import 'package:flutter/material.dart';

class ChooseCardScreen extends StatelessWidget {
  const ChooseCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Card'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return const Card(
                  margin: EdgeInsets.all(16.0),
                  child: ListTile(
                    title: Text('Card Number'),
                    subtitle: Text('Dominic Ovo'),
                    trailing: Icon(Icons.credit_card),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/payment_method');
              },
              child: const Text('Pay Rp. 766,000'),
            ),
          ),
        ],
      ),
    );
  }
}
