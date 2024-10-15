import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NfcWriteScreen extends StatefulWidget {
  @override
  _NfcWriteScreenState createState() => _NfcWriteScreenState();
}

class _NfcWriteScreenState extends State<NfcWriteScreen> {
  bool _isWriting = false;
  String _statusMessage = "Press the button below to write NFC";
  final TextEditingController _textController = TextEditingController();

  void _writeNfc(String content) async {
    setState(() {
      _isWriting = true;
      _statusMessage = "Writing NFC, please wait...";
    });

    try {
      await NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        var ndef = Ndef.from(tag);
        if (ndef == null) {
          setState(() {
            _statusMessage = "NFC tag is not NDEF compatible!";
            _isWriting = false;
          });
          NfcManager.instance.stopSession();
          return;
        }

        if (!ndef.isWritable) {
          setState(() {
            _statusMessage = "NFC tag is not writable!";
            _isWriting = false;
          });
          NfcManager.instance.stopSession();
          return;
        }

        NdefMessage message = NdefMessage([NdefRecord.createText(content)]);

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write to NFC Tag'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Content to Write on NFC',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _statusMessage,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: _isWriting
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: () => _writeNfc(_textController.text),
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

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
