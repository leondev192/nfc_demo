import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import '../database/database_helper.dart';
import '../models/card_model.dart';

class CardDetailsScreen extends StatefulWidget {
  @override
  _CardDetailsScreenState createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen> {
  bool _isWriting = false;
  String _statusMessage = "Press the button below to write NFC";

  void _writeNfc(String nfcData) async {
    setState(() {
      _isWriting = true;
      _statusMessage = "Writing NFC, please wait...";
    });

    try {
      await NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        var ndef = Ndef.from(tag);
        if (ndef == null || !ndef.isWritable) {
          setState(() {
            _statusMessage = "NFC tag is not writable!";
            _isWriting = false;
          });
          NfcManager.instance.stopSession();
          return;
        }

        NdefMessage message = NdefMessage([NdefRecord.createText(nfcData)]);
        try {
          await ndef.write(message);
          setState(() {
            _statusMessage = "NFC tag written successfully!";
            _isWriting = false;
          });
          NfcManager.instance.stopSession();
        } catch (e) {
          setState(() {
            _statusMessage = "Failed to write NFC: $e";
            _isWriting = false;
          });
          NfcManager.instance.stopSession();
        }
      });
    } catch (e) {
      setState(() {
        _statusMessage = "Could not start NFC session: $e";
        _isWriting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final CardModel card =
        ModalRoute.of(context)!.settings.arguments as CardModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(card.name),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              if (card.id != null) {
                print('Deleting card with ID: ${card.id}');
                await DatabaseHelper().deleteCard(card.id!);
                print('Card deleted successfully');
                if (mounted) {
                  Navigator.pop(context, true);
                }
              } else {
                print('Card ID is null, cannot delete');
              }
            },
          ),
        ],
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.nfc, size: 30, color: Colors.blue),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'NFC Data: ${card.nfcData}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _statusMessage,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: _isWriting
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: () => _writeNfc(card.nfcData),
                      icon: const Icon(Icons.nfc),
                      label: const Text('Write NFC Tag'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
