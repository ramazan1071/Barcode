import 'package:GULERP_BARKOD/barcode/Barcode_Page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/constants.dart';

import '../contans/app_color.dart';

class SecenekBarkod extends StatefulWidget {
  const SecenekBarkod({super.key});

  @override
  State<SecenekBarkod> createState() => _SecenekBarkodState();
}

class _SecenekBarkodState extends State<SecenekBarkod> {

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: AppColors.profilBackground,
          leading: Transform.scale(
            scale: 1,
            child: IconButton(
              icon: Image.asset('assets/images/logo.jpeg'),
              onPressed: () {
              },
            ),
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
      body: Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Barcode_Page(bolum: 0),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.blue, // Çerçeve rengi
                      width: 2, // Çerçeve kalınlığı
                    ),
                  ),
                  child: Text(
                    " Baskılı Toplar ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20), // İsteğe bağlı boşluk ekleyebilirsiniz
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Barcode_Page(bolum: 1),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.blue, // Çerçeve rengi
                      width: 2, // Çerçeve kalınlığı
                    ),
                  ),
                  child: Text(
                    "Baskısız Toplar",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
