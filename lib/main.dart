import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigspace/checkstock.dart';
import 'package:sigspace/customerpage.dart';
import 'package:sigspace/notipage.dart';
import 'package:sigspace/showlogo.dart';
import 'package:sizer/sizer.dart';
import 'classapi/class.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  runApp(
      new MaterialApp(debugShowCheckedModeBanner: false, home: new showlogo()));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  List<String>? position;
  List<String>? stringpreferences1;
  @override
  void initState() {
    pagepref();
    updatestatus().then((value) => position = stringpreferences1);
    super.initState();
  }

  int _selectpage = 0;
  final _pageOption = [customerpage()];
  final _pageOption2 = [
    checkstock(
      codeorder: [],
      nameorder: [],
      numorder: [],
      numpercrate: [],
      productset: [],
      price: [],
    ),
    notipage()
  ];

  // final _pageOption3 = [dealerpage(), notipage()];

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, device) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: position?[1] == "ADMIN"
            ? _pageOption[_selectpage]
            : _pageOption2[_selectpage],
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: ColorConstants.appbarcolor,
            selectedItemColor: Colors.amber,
            unselectedItemColor: Colors.white,
            currentIndex: _selectpage,
            onTap: (index) {
              setState(() {
                _selectpage = index;
              });
            },
            items: position?[1] == "ADMIN"
                ? [
                    new BottomNavigationBarItem(
                      icon: Icon(
                        Icons.list,
                        size: 30.sp,
                      ),
                      label: "ORDER",
                    ),
                    // ignore: unnecessary_new
                    new BottomNavigationBarItem(
                      icon: Icon(
                        Icons.check_box_outlined,
                        size: 30.sp,
                      ),
                      label: "UPDATE",
                    ),
                  ]
                : [
                    new BottomNavigationBarItem(
                      icon: Icon(
                        Icons.check_box_outlined,
                        size: 30.sp,
                      ),
                      label: "STOCK",
                    ),
                    new BottomNavigationBarItem(
                      icon: Icon(
                        Icons.notifications_outlined,
                        size: 30.sp,
                      ),
                      label: "NOTICE",
                    ),
                  ]),
      );
    });
  }

  Future updatestatus() async {
    SharedPreferences preferences1 = await SharedPreferences.getInstance();

    setState(() {
      stringpreferences1 = preferences1.getStringList("codestore");
    });
  }

  Future pagepref() async {
    SharedPreferences pagepref = await SharedPreferences.getInstance();
    if (pagepref.getInt("pagepre") == null) {
      _selectpage = 0;
    } else {
      setState(() {
        _selectpage = pagepref.getInt("pagepre")!;
      });
    }
  }
}
