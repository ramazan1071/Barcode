class VardiyeSaatleriModel {
  int id;
  String vardiyaSaat;

  VardiyeSaatleriModel({
    required this.id,
    required this.vardiyaSaat,
  });

  factory VardiyeSaatleriModel.fromJson(Map<String, dynamic> json) {
    return VardiyeSaatleriModel(
      id: int.parse(json['ID']),
      vardiyaSaat: json['Vardiya_Saat'],
    );
  }
}


String convertToTurkishDay(String englishDay) {
  switch (englishDay) {
    case 'Monday':
      return 'Monday';
    case 'Tuesday':
      return 'Tuesday';
    case 'Wednesday':
      return 'Wednesday';
    case 'Thursday':
      return 'Thursday';
    case 'Friday':
      return 'Friday';
    case 'Saturday':
      return 'Saturday';
    case 'Sunday':
      return 'Sunday';
    default:
      return englishDay; // Eğer dönüşüm yapılamazsa aynı günü geri döndürüyoruz.
  }
}
