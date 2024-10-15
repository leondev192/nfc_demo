import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/card_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CardModel> cards = [];

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final List<CardModel> cardList = await DatabaseHelper().getCards();
    setState(() {
      cards = cardList;
    });
  }

  void _navigateToAddCard() {
    Navigator.pushNamed(context, '/addCard').then((result) {
      if (result == true) {
        _loadCards();
      }
    });
  }

  void _navigateToCardDetails(CardModel card) {
    Navigator.pushNamed(context, '/cardDetails', arguments: card)
        .then((result) {
      if (result == true) {
        _loadCards(); // Reload lại danh sách thẻ khi có sự thay đổi từ màn hình chi tiết
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC Cards'),
        centerTitle: true,
      ),
      body: cards.isEmpty
          ? const Center(child: Text('No cards stored'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final card = cards[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    leading: Icon(Icons.credit_card, color: Colors.blue[400]),
                    title:
                        Text(card.name, style: const TextStyle(fontSize: 18)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _navigateToCardDetails(
                          card); // Điều hướng đến chi tiết thẻ
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddCard,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        child: const Icon(Icons.add),
      ),
    );
  }
}
