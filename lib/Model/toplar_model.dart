class Toplar {
  String? TopId;
  String? BaskiliMiktar;
  String? TahminiAdet;
  String? Kalan;
  String? KumasId;

  Toplar({required this.TopId, required this.BaskiliMiktar,required this.TahminiAdet,required this.Kalan,required this.KumasId});

  factory Toplar.fromMap(Map<String, dynamic> map) {
    return Toplar(
      TopId: map['BASKILITOPID'] != null ? map['BASKILITOPID'] : "0",
      BaskiliMiktar: map['BASKILIMKTR'] != null ? map['BASKILIMKTR'] : "0",
      TahminiAdet: map['TAHMINIADET'] != null ? map['TAHMINIADET'] : "0",
      Kalan: map['KALAN'] != null ? map['KALAN'] : "0",
      KumasId: map['KUMASID '] != null ? map['KUMASID '] : "0",
    );
  }
}