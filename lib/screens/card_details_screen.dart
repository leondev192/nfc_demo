import 'package:flutter/material.dart';
import '../models/card_model.dart';

class CardDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CardModel card =
        ModalRoute.of(context)!.settings.arguments as CardModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(card.name),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.nfc, size: 30, color: Colors.blue),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'NFC Data: ${card.nfcData}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
