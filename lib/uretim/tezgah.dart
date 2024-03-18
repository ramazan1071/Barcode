import 'dart:convert';

import 'package:GULERP_BARKOD/Model/operatorlar_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grock/grock.dart';

import '../Model/amirler_model.dart';
import '../Model/vardiye_saatleri_model.dart';
import '../contans/app_color.dart';
import '../contans/globals.dart';
import '../design/CustomButton.dart';
import '../design/CustomNumberInputWithMin.dart';
import 'listeler.dart';
import 'package:http/http.dart' as http;

class Tezgah extends StatefulWidget {
  const Tezgah({super.key});

  @override
  State<Tezgah> createState() => _TezgahState();
}

class _TezgahState extends State<Tezgah> {
  TextEditingController teraziCntrl = TextEditingController();
  bool pressed =false;
  String? valueChooseVardiya;
  String? valueChooseOperator;
  String? valueChooseAmir;
  int? vardiyaId=0;
  int? operatorId=0;
  int? amirId=0;
  bool isloading=false;

  List<VardiyeSaatleriModel>listItemsVardiya =[];
  List<KonfOperatorModel>listItemsOperator =[];
  List<VardiyaAmiriModel>listItemsAmir =[];
  Future<void> _getVardiyaSaatleri() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/KonfVardiyeSaatGetir.php'));
      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        setState(() {
          listItemsVardiya  = jsonList.map((item) => VardiyeSaatleriModel.fromJson(item)).toList();
        });

      } else {
        isloading=false;
        throw Exception('Veri alınamadı');
      }
    } catch (e) {
      print('Hata: $e');
    }
  }
  Future<void> _getOperatorler() async {
    final response = await http.post(
      Uri.parse('$baseUrl/KonfOperatorGetir.php'),
    );
    if (response.statusCode == 200) {
      // Başarılı bir şekilde veri alındıysa JSON'dan liste oluşturup döndürüyoruz
      List<dynamic> jsonResponse = json.decode(response.body);
      listItemsOperator = jsonResponse.map((json) => KonfOperatorModel.fromJson(json)).toList();
    } else {
      // İstekte hata oluştuysa boş bir liste döndürüyoruz
      listItemsOperator = [];
    }
  }
  Future<void> _getAmirler() async {
    final response = await http.post(
      Uri.parse('$baseUrl/KonfAmirGetir.php'),
    );
    if (response.statusCode == 200) {
      // Başarılı bir şekilde veri alındıysa JSON'dan liste oluşturup döndürüyoruz
      List<dynamic> jsonResponse = json.decode(response.body);
      listItemsAmir = jsonResponse.map((json) => VardiyaAmiriModel.fromJson(json)).toList();
    } else {
      // İstekte hata oluştuysa boş bir liste döndürüyoruz
      listItemsAmir = [];
    }
  }
  @override
  void initState() {
    isloading=false;
    _getVardiyaSaatleri();
    _getOperatorler();
    _getAmirler();
    isloading=true;
    // TODO: implement initState
    super.initState();
  }
   void kontrol(){
    if(vardiyaId!=0 && operatorId!=0 && amirId!=0 && teraziCntrl.text.isNotEmpty && operatorId.isNotEmpty&& vardiyaId.isNotEmpty && amirId.isNotEmpty){
      print(vardiyaId);
      pressed=true;
    }
    else{
      pressed=false;
    }
  }
  void yenile(){
    valueChooseVardiya="Vardiya Saati";
    valueChooseAmir="Amir";
    valueChooseOperator="Operatör";
    vardiyaId=0;
    amirId=0;
    operatorId=0;
    teraziCntrl.text="";
    kontrol();
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
          title:
          Center(
            child: Text(
              "Güler Konfeksiyon",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
            actions: <Widget>[
            IconButton(
            onPressed: () {
      setState(() {
        yenile();
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
      body:  isloading
          ?Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Vardiya Saati :",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                  ),
                ),
                 Container(
                   width: 400,
                   child: Padding(
                    padding: const EdgeInsets.only(top: 16.0,bottom: 16.0,right: 16.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: ElevatedButton(
                        onPressed: () {
                          _showDropdownList(context, listItemsVardiya.map((item) => item.vardiyaSaat).toList(),"valueChooseVardiya",listItemsVardiya.map((item) => item.id.toString()).toList(),);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          elevation: 0,
                          side: BorderSide(width: 1, color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // Yuvarlaklık değeri burada ayarlanıyor
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  valueChooseVardiya ?? "Vardiya Saati",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black),
                                  softWrap: true,
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_drop_down, color: AppColors.profilBackground, size: 30),
                          ],
                        ),
                      ),
                    ),
                ),
                 ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "  Operatorler :",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                  ),
                ),
                Container(
                  width: 400,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0,bottom: 16.0,right: 16.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: ElevatedButton(
                        onPressed: () {
                          _showDropdownList(context, listItemsOperator.map((operator) => operator.konfOperatoru).toList(),"valueChooseOperator",listItemsOperator.map((operator) => operator.id.toString()).toList(),);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          elevation: 0,
                          side: BorderSide(width: 1, color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // Yuvarlaklık değeri burada ayarlanıyor
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  valueChooseOperator ?? "Operatör",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black),
                                  softWrap: true,
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_drop_down, color: AppColors.profilBackground, size: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "            Amir : ",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                  ),
                ),
                Container(width: 400,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0,bottom: 16.0,right: 16.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: ElevatedButton(
                        onPressed: () {
                          _showDropdownList(context, listItemsAmir.map((amir) => amir.vardiyaAmiri).toList(),"valueChooseAmir",listItemsAmir.map((amir) => amir.id.toString()).toList(),);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          elevation: 0,
                          side: BorderSide(width: 1, color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // Yuvarlaklık değeri burada ayarlanıyor
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  valueChooseAmir ?? "Amir",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black),
                                  softWrap: true,
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_drop_down, color: AppColors.profilBackground, size: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: CustomNumberInputWithMin(
                controller: teraziCntrl,
                labelText: 'Tezgah No',
                width: 250,
                onChanged: (value) {
                  setState(() {
                    if(value.isNotEmpty){
                      kontrol();
                    }
                    else{
                      pressed=false;
                    }
                    print(":$value");
                  });
                },
              ),
            ),
            SizedBox(height: 20,),
            Center(
              child: CustomButton(
                pressed: pressed,//şimdilik
                text: 'Giriş',
                onPressed: () {
                  print("id:${vardiyaId}");
                  if(teraziCntrl.text.isNotEmpty){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Listeler(tezgah: int.parse(teraziCntrl.text),amirId: amirId!, operatorId: operatorId!,vardiyaId: vardiyaId!,operator: valueChooseOperator!,vardiyaAmir: valueChooseAmir!,vardiyaSaat: valueChooseVardiya!),));
                  }

                },
              ),
            ),

          ],
        ),
      ):Center(child: CircularProgressIndicator()),

    );
  }
  void _showDropdownList(BuildContext context, List<String> itemList, String secim, List<String> itemList2) {
    final double itemHeight = 50.0;
    final double separatorHeight = 1.0;
    final double bottomPadding = 8.0;

    double listViewHeight = itemList.length * itemHeight + (itemList.length - 1) * separatorHeight + bottomPadding;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: listViewHeight,
            width: MediaQuery.of(context).size.width*0.1,
            child: ListView.separated(
              itemCount: itemList.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: separatorHeight,
                  thickness: 1,
                  color: Colors.grey,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                final valueItem = itemList[index];
                final valueItem2 = itemList2[index];
                return ListTile(
                  title: Text(valueItem),
                
                  onTap: () {
                    setState(() {
                      if (secim == "valueChooseOperator") {
                        valueChooseOperator = valueItem;
                        operatorId=int.parse(valueItem2);
                        _getOperatorler();
                        kontrol();
                      }
                      else if (secim == "valueChooseVardiya") {
                        valueChooseVardiya = valueItem;
                        vardiyaId=int.parse(valueItem2);
                        setState(() {
                          _getVardiyaSaatleri();
                          kontrol();
                        });
                      }
                      else if (secim == "valueChooseAmir") {
                        valueChooseAmir = valueItem;
                        amirId=int.parse(valueItem2);
                        _getAmirler();
                        kontrol();

                      }

                    });

                    // Dikkat: onPressed'ta setState kullanıyorsanız, Navigator.of(context).pop() öncesinde setState yapmanız gerekebilir.
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

}


