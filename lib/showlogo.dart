/*หน้าที่แก้
showlogo Checkstock subcheckstock login update addnerproduct
main dealer noti
*/

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigspace/classapi/class.dart';
import 'package:sigspace/login.dart';
import 'package:sigspace/main.dart';
import 'package:sizer/sizer.dart';

class showlogo extends StatefulWidget {
  showlogo({Key? key}) : super(key: key);

  @override
  _showlogoState createState() => _showlogoState();
}

class _showlogoState extends State<showlogo> {
  List<String> strintpre = [];
  @override
  void initState() {
    autologin();

    Future.delayed(const Duration(seconds: 2), () async {
      if (strintpre.isEmpty) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => login()));
      } else {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => MyApp()));
      }
    });

    super.initState();
  }

  autologin() async {
    final preferences1 = await SharedPreferences.getInstance();

    if (preferences1.getStringList("codestore") != null) {
      strintpre = preferences1.getStringList("codestore")!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        backgroundColor: ColorConstants.appbarcolor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(50.0),
              //   child: Image.asset("assets/images/logo.png"),
              // ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Center(
                  child: Text(
                    "SIGMA SPACE",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 60.0.sp,
                        fontFamily: 'newbodyfont'),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
