import 'dart:async';
import 'dart:convert';

import 'package:GULERP_BARKOD/uretim/stokkarti.dart';
import 'package:GULERP_BARKOD/uretim/tezgah.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Model/toplar_model.dart';
import '../contans/app_color.dart';
import '../contans/globals.dart';

class Listeler extends StatefulWidget {
  int tezgah;
  String vardiyaAmir;
  String operator;
  String vardiyaSaat;
  int vardiyaId;
  int operatorId;
  int amirId;


  Listeler({required this.tezgah,required this.vardiyaId,required this.operatorId,required this.amirId,required this.operator,required this.vardiyaAmir,required this.vardiyaSaat});

  @override
  State<Listeler> createState() => _ListelerState();
}




class _ListelerState extends State<Listeler> {
  List<Toplar> toplarList = [];
  bool _isloading=false;
  late Timer _timer;
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 15), (timer) {
      setState(() {
        _toplarVerileriGetir();
      });
    });
  }
  void _stopTimer() {
    _timer.cancel();
  }

  Future<void> _toplarVerileriGetir() async {
    _isloading=false;
    try {
      final response = await http.get(
        Uri.parse("http://192.168.1.164:85/KonfToplarGetir.php?konftezgahno=${widget.tezgah.toString()}"),
      );
      print("ahmet :${response.statusCode}");
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        setState(() {
          toplarList = jsonList.map((json) => Toplar.fromMap(json)).toList();
          // JSON'dan alınan verilerin tipini dönüştürme
        });
      }
      _isloading=true;
    } catch (e) {
      // Hata durumunda yapılacak işlemler
      print("Hata: $e");
    }

  }
  @override
  void initState() {
    _toplarVerileriGetir();
    _startTimer();
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return  Scaffold(
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
              _stopTimer();
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Tezgah()));
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
                 _toplarVerileriGetir();
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
      body: _isloading
          ?Center(
            child: Container(
              height: screenHeight * 0.8, // Ekran yüksekliğinin %80'i kadar olacak
             width: screenWidth * 0.2,
              child: toplarList.isNotEmpty ? Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200], // Arka plan rengi
                    borderRadius: BorderRadius.circular(10), // Kenar yuvarlaklığı
                    border: Border.all(
                      color: Colors.grey, // Kenarlık rengi
                      width: 1, // Kenarlık kalınlığı
                    )
                ),
                child: ListView.builder(
                  itemCount: toplarList.length,
                  itemBuilder: (context, index) {
                    final top = toplarList[index];
                    return InkWell(
                      onTap: () {
                        _stopTimer();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => StokKarti(
                                imageUrl: top.TopId.toString(),
                                TahminiAdet: top.TahminiAdet.toString(),
                                amirId: widget.amirId,
                                operatorId: widget.operatorId,
                                vardiyeId: widget.vardiyaId,
                                tezgah: widget.tezgah,
                                operator: widget.operator!,
                                vardiyaAmir: widget.vardiyaAmir!,
                                vardiyaSaat: widget.vardiyaSaat!,
                                kalan: int.parse(top.Kalan!),
                                BaskiliMiktar: int.parse(top.BaskiliMiktar!),
                                KumasId: top.KumasId!
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
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
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text("Top ID : ${top.TopId.toString()}", style: TextStyle(color: Colors.black)),
                          ),
                          trailing: Text("(${top.Kalan.toString()})"),
                        ),
                      ),
                    );
                  },
                ),
              ) : Center(
                child: Container(
                  child: Text("Tezgah Listesi Boş"),
                ),
              ),
            ),
      ):Center(child: CircularProgressIndicator()),
    );
  }
}
