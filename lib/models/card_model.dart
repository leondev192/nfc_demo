class CardModel {
  final int? id;
  final String name;
  final String nfcData;

  CardModel({this.id, required this.name, required this.nfcData});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nfc_data': nfcData,
    };
  }

  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      id: map['id'],
      name: map['name'],
      nfcData: map['nfc_data'],
    );
  }
}
