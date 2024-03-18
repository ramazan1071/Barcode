class KonfOperatorModel {
  final int id;
  final String konfOperatoru;
  final String gorevi;

  KonfOperatorModel({
    required this.id,
    required this.konfOperatoru,
    required this.gorevi,
  });

  factory KonfOperatorModel.fromJson(Map<String, dynamic> json) {
    return KonfOperatorModel(
      id: int.parse(json['ID']),
      konfOperatoru: json['Konf_Operatoru'],
      gorevi: json['GOREVI'],
    );
  }
}
