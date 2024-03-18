class VardiyaAmiriModel {
  final int id;
  final String vardiyaAmiri;

  VardiyaAmiriModel({
    required this.id,
    required this.vardiyaAmiri,
  });

  factory VardiyaAmiriModel.fromJson(Map<String, dynamic> json) {
    return VardiyaAmiriModel(
      id: int.parse(json['ID']),
      vardiyaAmiri: json['VardiyaAmiri'],
    );
  }
}
