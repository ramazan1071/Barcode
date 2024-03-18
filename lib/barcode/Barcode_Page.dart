import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../contans/app_color.dart';
import '../contans/globals.dart';
import '../design/CustomAlertDialog.dart';
import '../design/CustomButton.dart';
import '../design/CustomNumberInputWithMin.dart';
import 'package:http/http.dart' as http;
class Tezgahlar{
  String? Tezgah;
  String? Toplam;
  Tezgahlar({required this.Tezgah,required this.Toplam});
  // Fabrika metodu - JSON verisini ArizaGetirModel nesnesine dönüştürür
  factory Tezgahlar.fromMap(Map<String, dynamic> map) {
    return Tezgahlar(
      Toplam: map['TOPLAM'],
      Tezgah: map['KONFTEZGAHNO'],

    );
  }
}

class Barcode_Page extends StatefulWidget {
  int bolum;
  Barcode_Page({required this.bolum});
  @override
  _Barcode_PageState createState() => _Barcode_PageState();
}

class _Barcode_PageState extends State<Barcode_Page> {
  String _scanBarcode = '';
  TextEditingController teraziCntrl = TextEditingController();
  bool pressed = false;
  List<Tezgahlar> tezgahList = [];
  bool _isloading =false;
  String _scanBarcodeis = '';
  int TezgahSayisi=0;

  Future<void> _tezgahVerileriGetir() async {
    _isloading=false;
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/KonfTezgahGetir.php"),
        // İsteğe ekstra veri ekleyebilirsiniz, ancak bu örnekte gerekli değil.
        // Örneğin, isteğe parametre eklemek için:
        // body: {
        //   'parametre': deger,
        // },
      );
      print("ahmet :${response.statusCode}");

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        setState(() {
          tezgahList = jsonList.map((json) => Tezgahlar.fromMap(json)).toList();
          // JSON'dan alınan verilerin tipini dönüştürme
        });
      }
      _isloading=true;
    } catch (e) {
      // Hata durumunda yapılacak işlemler
      print("Hata: $e");
    }

  }
  Future<void> _tezgahSayisiGetir() async {
    _isloading=false;
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/KonfTezgahSayisiGetir.php"),
      );
      print("ahmet :${response.statusCode}");

      if (response.statusCode == 200) {
        final int? tezgahSayisi = int.tryParse((response.body.replaceAll('"', '')));
        if (tezgahSayisi != null) {
          setState(() {
            TezgahSayisi = tezgahSayisi;
            print("tezgaha sayisi $TezgahSayisi");
          });
        }
      } else {
        print("Hata: ${response.statusCode}");
        _isloading=false;
      }
      _isloading=true;
    } catch (e) {
      // Hata durumunda yapılacak işlemler
      print("Hata: $e");
    }

  }
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Geri', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      if (pressed != null && _scanBarcode != '') {
        if(widget.bolum==1){
          if(_scanBarcodeis!=''){
            int scan = int.parse(_scanBarcodeis);
            pressed = scan > 0;
          }
        }
        int scan = int.parse(_scanBarcode);
        pressed = scan > 0;
      } else {
        pressed = false;
      }
    });
  }
  Future<void> scanBarcodeNormalIs() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Geri', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;
    setState(() {
      _scanBarcode = barcodeScanRes;
      if (pressed != null && _scanBarcode != '') {
        if(widget.bolum==1){
          if(_scanBarcodeis!=''){
            int scan = int.parse(_scanBarcodeis);
            pressed = scan > 0;
          }
        }
        int scan = int.parse(_scanBarcode);
        pressed = scan > 0;
      } else {
        pressed = false;
      }
    });
  }
  Future<void> updateBarcode() async {
    final String url = '$baseUrl/Barcode.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'top_Id': _scanBarcode,
          'terazi': teraziCntrl.text,
        },
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => CustomAlertDialog(
            title: "İşlem Başarılı",
            content: "$_scanBarcode nolu top ${teraziCntrl.text} nolu tezgaha Planlandı",
            icon: Icons.check_circle,
            iconColor: Colors.green,
            onPressed: () {
              setState(() {
                pressed=false;
                teraziCntrl.text="";
                _scanBarcode="";
                _scanBarcodeis="";
                _tezgahVerileriGetir();
              });
              Navigator.of(context).pop();

            },
          ),
        );
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => CustomAlertDialog(
            title: "İşlem Başarısız",
            content: "Bir hata oluştu",
            icon: Icons.error,
            iconColor: Colors.red,
            onPressed: () {
              setState(() {
                pressed=false;
                teraziCntrl.text="";
                _scanBarcode="";
                _tezgahVerileriGetir();
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
  Future<void> updateBarcodeIs() async {
    final String url = '$baseUrl/BarcodeIs.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'top_Id': _scanBarcode,
          'terazi': teraziCntrl.text,
          'kumas':_scanBarcodeis,
        },
      );
      print("deneme${response.statusCode}");

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => CustomAlertDialog(
            title: "İşlem Başarılı",
            content: "$_scanBarcode nolu top ${teraziCntrl.text} nolu tezgaha Planlandı",
            icon: Icons.check_circle,
            iconColor: Colors.green,
            onPressed: () {
              setState(() {
                pressed=false;
                teraziCntrl.text="";
                _scanBarcode="";
                _scanBarcodeis="";
                _tezgahVerileriGetir();
              });
              Navigator.of(context).pop();

            },
          ),
        );
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => CustomAlertDialog(
            title: "İşlem Başarısız",
            content: "Bir hata oluştu",
            icon: Icons.error,
            iconColor: Colors.red,
            onPressed: () {
              setState(() {
                pressed=false;
                teraziCntrl.text="";
                _scanBarcode="";
                _tezgahVerileriGetir();
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
  @override
  void initState() {
    _isloading=false;
    _tezgahVerileriGetir();
    _tezgahSayisiGetir();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titlePadding = calculateTitlePadding(screenWidth);
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false, // Klavye açıldığında ekran boyutunu otomatik olarak değiştirme
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: AppBar(
            backgroundColor: AppColors.profilBackground,
            leading:  IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white, // Geri butonunun rengini beyaz olarak ayarlar
              ),
              onPressed: () {
                Navigator.pop(context);
                // Geri butonuna basıldığında yapılacak işlemler
              },
            ),
            title:
             Center(
               child: Text(
                  "Güler Konfeksiyon Barkod",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
             ),
          ),
        ),
        body:_isloading
            ?
        ConstrainedBox( // Widget'ın boyutunu kısıtlama
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height, // Ekran boyutunu minimum yükseklik olarak ayarlama
            ),
            child:Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
            child: Container(

              margin: EdgeInsets.symmetric(horizontal: 30),
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(15),
              ),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  widget.bolum==1?Column(mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [ ElevatedButton(
                    onPressed: () => scanBarcodeNormalIs(),
                    child: Text('İş Emri Barkod Okut'),
                  ),
                    SizedBox(height: 25),
                    Text(
                      'İş Emri ID : ${_scanBarcodeis == '-1' ? '' : _scanBarcodeis}\n',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),],):Container(),
                  ElevatedButton(
                    onPressed: () => scanBarcodeNormal(),
                    child: Text('Top Barkod Okut'),
                  ),
                  SizedBox(height: widget.bolum==1?10:25),//25 bolum geldikten sonra teklide
                  Text(
                    'Top ID : ${_scanBarcode == '-1' ? '' : _scanBarcode}\n',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),//25
                  CustomNumberInputWithMin(
                    maxValue: TezgahSayisi,
                    controller: teraziCntrl,
                    labelText: 'Tezgah No (1 - $TezgahSayisi)',
                    width: 250,
                    onChanged: (value) {
                      setState(() {
                        if (value == '0') { // Eğer kullanıcı 0 girerse
                          setState(() {
                            teraziCntrl.text = '1'; // Değeri 1 olarak değiştir
                          });
                        }
                        print("ramazan:$value");
                        if (value.isNotEmpty && _scanBarcode.isNotEmpty ) {
                          if(widget.bolum==1){
                            if(_scanBarcodeis.isNotEmpty){
                              int scan2=int.parse(_scanBarcodeis);
                              int scan = int.parse(_scanBarcode);
                              if (scan2 > 0 && scan>0) {
                                pressed = true;
                              }
                              else {
                                pressed = false;
                              }
                            }
                          }
                          else if(widget.bolum == 0){
                            int scan = int.parse(_scanBarcode);
                            if(scan>0) {
                              pressed=true;
                            }
                          } else {
                            pressed = false;
                          }
                          }

                      });
                    },
                  ),
                  SizedBox(height: 25),
                  CustomButton(
                    text: 'Planlama',
                    pressed: pressed,
                    onPressed: () {
                      if (pressed) {
                        print("ramazan : ${widget.bolum}");
                        // if(widget.bolum==0){//bolum diğer sayfadan gelicek
                        //   updateBarcode();
                        // }
                        // else if(widget.bolum==1){
                        //  updateBarcodeIs();
                        // }
                      }
                    },
                  ),
                  SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      _tezgahVerileriGetir();
                      // Yenileme işlemi burada gerçekleştirilir
                    },
                    icon: Icon(Icons.refresh),
                    label: Text('Planlanmış Tezgahlar Listesi'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // Düğme rengi
                      onPrimary: Colors.white, // Düğme metin rengi
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Kenar yuvarlaklığı
                      ),
                    ),),
                  SizedBox(height: 5),
                  tezgahList.isNotEmpty?Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200], // Arka plan rengi
                        borderRadius: BorderRadius.circular(10), // Kenar yuvarlaklığı
                        border: Border.all(
                          color: Colors.grey, // Kenarlık rengi
                          width: 1, // Kenarlık kalınlığı
                        )),
                      child: ListView.builder(
                        shrinkWrap: true, // Ekrana sığmama hatasını önlemek için shrinkWrap özelliğini true olarak ayarlayın
                        physics: BouncingScrollPhysics(),
                        itemCount: tezgahList.length,
                        itemBuilder: (context, index) {
                          final tezgah = tezgahList[index];
                          return InkWell(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.grey[300],
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                              child: ListTile(
                                title: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text("Tezgah : ${tezgah.Tezgah}", style: TextStyle(color: Colors.black)),
                                    ),
                                  ],
                                ),
                                trailing: Text("(${tezgah.Toplam.toString()})"),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ):Center(child: Container(child: Text("Tezgah Listesi Boş"),)),
                  SizedBox(height: 5),

                ],
              )


            ),
          ),

        ],
          ))
        :Center(child: CircularProgressIndicator()),

      ),
    );
  }
}
