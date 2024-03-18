import 'dart:convert';


import 'package:GULERP_BARKOD/contans/globals.dart';
import 'package:GULERP_BARKOD/uretim/listeler.dart';
import 'package:flutter/material.dart';
import 'package:grock/grock.dart';
import 'package:http/http.dart' as http;

import '../contans/app_color.dart';
import '../design/CustomAlertDialog.dart';
import '../design/CustomButton.dart';
import '../design/CustomNumberInput.dart';

class StokKarti extends StatefulWidget {
  String imageUrl;
  String TahminiAdet;
  int tezgah;
  String vardiyaAmir;
  String operator;
  String vardiyaSaat;
  int vardiyeId;
  int operatorId;
  int amirId;
  int kalan;
  int BaskiliMiktar;
  String KumasId;
  StokKarti({required this.imageUrl,required this.TahminiAdet,required this.tezgah,required this.vardiyeId,required this.operatorId,required this.amirId,required this.vardiyaAmir,required this.operator ,required this.vardiyaSaat,required this.kalan,required this.BaskiliMiktar,required this.KumasId});

  @override
  _StokKartiState createState() => _StokKartiState();

}

class _StokKartiState extends State<StokKarti> {
  late String _imageUrl = '';
  TextEditingController uretimMiktariCntrl = TextEditingController();
  TextEditingController baskiliHataliMiktarCntrl = TextEditingController();
  TextEditingController defoluMiktarCntrl = TextEditingController();
  bool pressed=false;
  int uretimToplam=0;
  bool _isloading=false;

  //image alma fonksiyonu
  Future<void> _getImage() async {
    _isloading=false;
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.1.164:85/resimler/${widget.imageUrl}.jpg')); // Sunucunuzun adresini buraya girin
      if (response.statusCode == 200) {
        setState(() {
          _imageUrl = 'http://192.168.1.164:85/resimler/${widget.imageUrl}.jpg';
          _getToplamUretim();
        });
      }
      else if (response.statusCode == 404) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => CustomAlertDialog(
            title: "İşlem Başarısız",
            content: "Resim bulunamadı.",
            icon: Icons.error,
            iconColor: Colors.red,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        );
      }else {
        throw Exception('Failed to load image: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
  Future<void> _getToplamUretim() async {
      final response = await http.get(
        Uri.parse("http://192.168.1.164:85/KonfUretimAnaliz.php?operatorid=${widget.operatorId.toString()}&arizavrdsaati=${widget.vardiyeId.toString()}&konftezgahno=${widget.tezgah.toString()}"),);
      if (response.statusCode == 200) {
        // Başarılı cevap alındı
        String responseBody = response.body;
        // JSON stringini bir Map nesnesine dönüştür
        Map<String, dynamic> jsonData = jsonDecode(responseBody);

        // Artık jsonData içinde gelen verileri kullanabilirsiniz
        // Örnek olarak, TOPLAM değerine erişelim
        setState(() {
          uretimToplam = int.parse(jsonData['TOPLAM']??"0");
          _isloading=true;
        });

      } else {
        _isloading=false;

      }

  }
  Future<void> insert_update() async {

    bool kontrol=false;
    int toplam=int.parse(uretimMiktariCntrl.text==""?"0":uretimMiktariCntrl.text)+int.parse(defoluMiktarCntrl.text==""?"0":defoluMiktarCntrl.text)+int.parse(baskiliHataliMiktarCntrl.text==""?"0":baskiliHataliMiktarCntrl.text);

        //%10 koşulu
        if(toplam>widget.kalan+(widget.kalan*10/100)){
          kontrol=false;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => CustomAlertDialog(
              title: "İşlem Başarısız",
              content: "Üretim Miktarı fazla Girilmiştir",
              icon: Icons.error,
              iconColor: Colors.red,
              onPressed: () {
                setState(() {
                  _getImage();
                });
                Navigator.of(context).pop();
              },
            ),
          );
        }
        else{
          kontrol=true;
        }

      if(kontrol){
        try {
        String url = "$baseUrl/KonfUretimGiris.php";
        Map<String, String> headers = {"Content-Type": "application/x-www-form-urlencoded"};
        Map<String, String> body = {
          'BASKILITOPID': widget.imageUrl.toString(),
          'OPERATORID': widget.operatorId.toString(),
          'AMIRID': widget.amirId.toString(),
          'ARIZAVRDSAATID': widget.vardiyeId.toString(),
          'KONFPALETID': "0",
          'BALYALAMADURUM': "0",
          'KONFURTMKTR': uretimMiktariCntrl.text==""?"0":uretimMiktariCntrl.text,
          'KONFBSKHATALIMKTR': baskiliHataliMiktarCntrl.text==""?"0":baskiliHataliMiktarCntrl.text,
          'KONFTELEFMKTR': defoluMiktarCntrl.text==""?"0":defoluMiktarCntrl.text,
          'KONFTEZGAHNO': widget.tezgah.toString(),
          'KUMASID':widget.KumasId,

        };
        var response = await http.post(Uri.parse(url), headers: headers, body: body);
        print("response : ${response.statusCode}");
        print("responsebody : ${response.body}");

        if (response.statusCode == 200) {
          // Başarılı cevap alındı
          String responseBody = response.body;
          // İşlem başarıyla gerçekleştirildi
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => CustomAlertDialog(
              title: "İşlem Başarılı",
              content: "Üretim Girildi",
              icon: Icons.check_circle,
              iconColor: Colors.green,
              onPressed: () {
                setState(() {
                  pressed = false;
                  uretimMiktariCntrl.text = "";
                  baskiliHataliMiktarCntrl.text = "";
                  defoluMiktarCntrl.text = "";
                  _getImage();
                });
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return Listeler(tezgah: widget.tezgah, vardiyaId: widget.vardiyeId, operatorId: widget.operatorId, amirId: widget.amirId, operator: widget.operator, vardiyaAmir: widget.vardiyaAmir, vardiyaSaat: widget.vardiyaSaat);
                  },
                ), (route) => false,);

              },
            ),
          );
        } else {
          // HTTP isteği başarısız oldu
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => CustomAlertDialog(
              title: "İşlem Başarısız",
              content: "HTTP isteği başarısız: ${response.request}",
              icon: Icons.error,
              iconColor: Colors.red,
              onPressed: () {
                setState(() {
                  pressed = false;
                  uretimMiktariCntrl.text = "";
                  baskiliHataliMiktarCntrl.text = "";
                  defoluMiktarCntrl.text = "";
                  _getImage();
                });
                Navigator.of(context).pop();
              },
            ),
          );
        }
      } catch (error) {
      print("Hata: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $error")),
      );
    }
      }

  }

  @override
  void initState() {
    print("deneme ${widget.KumasId}");
    super.initState();
    _getImage();
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: AppColors.profilBackground,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white, // Geri butonunun rengini beyaz olarak ayarlar
            ),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                builder: (BuildContext context) {
                  return Listeler(tezgah: widget.tezgah, vardiyaId: widget.vardiyeId, operatorId: widget.operatorId, amirId: widget.amirId, operator: widget.operator, vardiyaAmir: widget.vardiyaAmir, vardiyaSaat: widget.vardiyaSaat);
                },
              ), (route) => false,);
              // Geri butonuna basıldığında yapılacak işlemler
            },
          ),
          title:
          Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tezgah : (${widget.tezgah})",
                  style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold),
                ),

                Text(
                  "Operatör : (${widget.operator})       -       Amir : (${widget.vardiyaAmir})  -       Vardiya : (${widget.vardiyaSaat})",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                setState(() {
                  _getImage();
                });
              },
              icon: Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.refresh,color: Colors.white,size: 30,),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body:_isloading
          ?Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              widget.BaskiliMiktar==0?Text(
                "BASKISIZ",
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Kalın font
                  fontSize: 24, // Yazı boyutu
                  color: Colors.black, // Yazı rengi
                  shadows: [
                    Shadow(
                      blurRadius: 4, // Gölge bulanıklığı
                      color: Colors.grey, // Gölge rengi
                      offset: Offset(2, 2), // Gölge konumu
                    ),
                  ],
                ),
              ):Container(),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: screenWidth*0.6,
                  height:   widget.BaskiliMiktar==0?screenHeight*0.88:screenHeight*0.9,
                  child: Image.network(
                    _imageUrl,
                    fit: BoxFit.fill, // Resmi tamamen kaplamak için
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 5), // Boşluk ekleyerek metin ve giriş kutularını resmin sağına yerleştir
          Container(
            width: screenWidth*0.2, // Metin ve giriş kutularının genişliği
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Metin ve giriş kutularını sola hizala
              children: [
                widget.BaskiliMiktar==0?SizedBox(height: 48,):SizedBox(height: 15,),
                CustomNumberInput(
                  controller: uretimMiktariCntrl,
                  labelText: 'Üretim Miktarı (${widget.kalan})',
                  width: screenWidth*0.17,
                  onChanged: (newValue) {}
                ),

                SizedBox(height: 15,),
                CustomNumberInput(
                  controller: baskiliHataliMiktarCntrl,
                  labelText: 'Baskı Hatalı Miktar ',
                  width: screenWidth*0.17,
                  onChanged: (newValue) {
                  },

                ),
                SizedBox(height: 15,),
                CustomNumberInput(
                  controller: defoluMiktarCntrl,
                  labelText: 'Defolu Miktar',
                  width: screenWidth*0.17,
                  onChanged: (newValue) {
                  },
                ),
                SizedBox(height: 15,),
                CustomButton(
                  pressed: true,//şimdilik
                  text: 'Üretim Kaydet',
                  onPressed: () {
                    insert_update();
                  },
                ),

                // Diğer metin kutularını ve giriş kutularını buraya ekleyebilirsiniz
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Toplam Üretim Miktarı",
                  style: TextStyle(fontSize: 25),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "$uretimToplam",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
