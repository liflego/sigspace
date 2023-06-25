import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigspace/checkstock.dart';
import 'package:sigspace/login.dart';
import 'package:sigspace/main.dart';
import 'package:sizer/sizer.dart';
import 'package:textfield_search/textfield_search.dart';
import 'package:url_launcher/url_launcher.dart';
import '../classapi/class.dart';
import 'package:http/http.dart' as http;
import 'package:popup_card/popup_card.dart';

class customerpage extends StatefulWidget {
  customerpage({Key? key}) : super(key: key);

  @override
  _customerpageState createState() => _customerpageState();
}

class _customerpageState extends State<customerpage> {
  // GoogleSignIn _googleSignIn = GoogleSignIn();
  List<Getalldealer> alldealer = [];
  List<Getalldealer> alldealerfordisplay = [];
  TextEditingController message = TextEditingController();
  List<String>? stringpreferences1;
  var _scanBarcode;
  late List<String> cusdata;
  TextEditingController mysearh = TextEditingController();
  List<Getcustomerstore> alldata = [];
  bool toggle = false;
  bool toggleall = false;
  List<bool> toggleselect = [];
  final _formkey = GlobalKey<FormState>();
  List<String> list = [];
  String namestore = "";
  bool togglecheck = false;
  String auth = "";
  List<String> getdatatocheckstock = [];
  @override
  void initState() {
    fectalldealerdata().then((value) {
      setState(() {
        alldealer.addAll(value);
        alldealerfordisplay = alldealer;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Sizer(builder: (context, orientation, deviceType) {
        return SafeArea(
          top: false,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: ColorConstants.appbarcolor,
              toolbarHeight: 7.h,
              title: Text(
                "DEALER",
                style: TextStyle(fontFamily: 'newtitlefont', fontSize: 25.sp),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      scanbarcode();
                    },
                    icon: Icon(Icons.qr_code_scanner))
              ],
            ),
            backgroundColor: ColorConstants.backgroundbody,
            body: Form(
              key: _formkey,
              child: ListView(children: [
                serchBar(),
                countstore(),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: ListView.builder(
                    itemCount: alldealerfordisplay.length,
                    itemBuilder: (BuildContext context, int index) {
                      return listItem(index);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.length < 1) {
                              return "Please enter message";
                            }
                          },
                          controller: message,
                          onFieldSubmitted: (value) => {
                            setState(() {
                              message.text = value;
                            })
                          },
                          maxLines: 3,
                          decoration: InputDecoration(
                              hintText: "Message box..",
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1))),
                        ),
                      ),
                      toggle == true
                          ? Container(
                              color: Colors.red,
                              width: MediaQuery.of(context).size.width / 7.5,
                              height: MediaQuery.of(context).size.height / 10,
                              child: IconButton(
                                  onPressed: () {
                                    if (stringpreferences1![1] == "DEALER") {
                                      insertintonoticefordealer();
                                    } else {
                                      insertintonotice();
                                    }
                                  },
                                  icon: Icon(
                                    Icons.send,
                                    size: 30.sp,
                                    color: Colors.white,
                                  )),
                            )
                          : Container(
                              color: Colors.amber,
                              width: MediaQuery.of(context).size.width / 7.5,
                              height: MediaQuery.of(context).size.height / 10,
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      toggle = !toggle;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.check_box_outline_blank,
                                    size: 30.sp,
                                    color: Colors.white,
                                  )),
                            ),
                    ],
                  ),
                ),
              ]),
            ),
            drawer: Drawer(
              backgroundColor: Colors.grey[300],
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Column(
                      children: [
                        Text(
                          namestore,
                          style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'newtitlefont'),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: auth == "null"
                                ? TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.greenAccent[700]),
                                    ),
                                    child: Text(
                                      "รับการแจ้งเตือนผ่าน LINE",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.black,
                                          fontFamily: 'newtitlefont'),
                                    ),
                                    onPressed: () {
                                      insertlineuid();
                                      _openline();
                                      setState(() {
                                        auth = "notnull";
                                      });
                                    },
                                  )
                                : TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.red[400]),
                                    ),
                                    child: Text(
                                      "ยกเลิกรับการแจ้งเตือนผ่าน LINE",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.white,
                                          fontFamily: 'newtitlefont'),
                                    ),
                                    onPressed: () {
                                      cancellinenoti();
                                    },
                                  ))),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 60.h, horizontal: 1.h),
                    child: Center(
                        child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        child: Text(
                          "LOG OUT",
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                              fontFamily: 'newtitlefont'),
                        ),
                        onPressed: () async {
                          SharedPreferences pagepref =
                              await SharedPreferences.getInstance();
                          pagepref.setInt("pagepre", 0);

                          ////update login status
                          String url2 =
                              "http://185.78.165.189:3001/sigspaceapi/updateloginstatus";

                          var body2 = {
                            "loginstatus": "0",
                            "username": stringpreferences1![5].toString(),
                          };

                          http.Response response2 = await http.patch(
                              Uri.parse(url2),
                              headers: {
                                'Content-Type':
                                    'application/json; charset=utf-8'
                              },
                              body: JsonEncoder().convert(body2));
                          stringpreferences1!.clear();

                          SharedPreferences preferences1 =
                              await SharedPreferences.getInstance();
                          preferences1.setStringList(
                              "codestore", stringpreferences1!);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => (login()),
                            ),
                          );
                        },
                      ),
                    )),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget serchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.w, horizontal: 3.h),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border.all(color: HexColor('#39474F'), width: 2),
            borderRadius: BorderRadius.circular(10.0)),
        child: Center(
          child: SizedBox(
            width: 40.w,
            height: 7.h,
            child: Center(
              child: TextField(
                showCursor: true,
                style: TextStyle(fontSize: 15.0.sp),
                decoration: InputDecoration(
                    hintText: "SEARCH...",
                    hintStyle: TextStyle(
                      color: HexColor('#39474F'),
                    ),
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
                onChanged: (text) {
                  text = text.toLowerCase();

                  setState(() {
                    alldealerfordisplay = alldealer.where((_allproduct) {
                      var cusname = _allproduct.cusname.toLowerCase();
                      return cusname.contains(text);
                    }).toList();
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget countstore() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "(${alldealerfordisplay.length} Unit)",
            style: TextConstants.textstyle,
          ),
          toggle == true
              ? Row(
                  children: [
                    Text(
                      "Cancle",
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontFamily: 'newbodyfont',
                          color: Colors.red),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            toggle = !toggle;
                          });
                        },
                        icon: Icon(
                          Icons.cancel_outlined,
                          size: 20.sp,
                          color: Colors.red,
                        )),
                    Text(
                      "เลือกทั้งหมด",
                      style: TextConstants.textstyle,
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            if (toggleall == false) {
                              toggleall = true;
                              for (int i = 0;
                                  i < alldealerfordisplay.length;
                                  i++) {
                                toggleselect[i] = true;
                              }
                            } else {
                              toggleall = false;
                              for (int i = 0;
                                  i < alldealerfordisplay.length;
                                  i++) {
                                toggleselect[i] = false;
                              }
                            }
                          });
                        },
                        icon: toggleall == false
                            ? Icon(Icons.check_box_outline_blank, size: 20.sp)
                            : Icon(Icons.check_box_outlined, size: 20.sp)),
                  ],
                )
              : SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget listItem(index) {
    return alldealerfordisplay[index].sconfrim == 1
        ? Card(
            color: ColorConstants.cardcolor,
            child: OutlinedButton(
              onPressed: () async {
                setState(() {
                  if (alldealerfordisplay[index].auth == null) {
                    getdatatocheckstock = [
                      alldealerfordisplay[index].codestore,
                      "null"
                    ];
                  } else {
                    getdatatocheckstock = [
                      alldealerfordisplay[index].codestore,
                      alldealerfordisplay[index].auth
                    ];
                  }
                });
                SharedPreferences stringpreferences2 =
                    await SharedPreferences.getInstance();
                stringpreferences2.setStringList(
                    "dealercode", getdatatocheckstock);
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => checkstock(
                    codeorder: [],
                    nameorder: [],
                    numorder: [],
                    numpercrate: [],
                    productset: [],
                    priceforpack: [],
                  ),
                ));
              },
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          alldealerfordisplay[index].companyname,
                          style: TextConstants.textstyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {
                                  _launchPhoneURL(index);
                                },
                                icon: Icon(
                                  Icons.call,
                                  color: Colors.black,
                                )),
                            Text(
                              alldealerfordisplay[index].phone,
                              style: TextConstants.textstyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                    toggle == false
                        ? SizedBox(
                            height: 10,
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    toggleselect[index] = !toggleselect[index];
                                    toggleall = false;
                                  });
                                },
                                icon: toggleselect[index] == false
                                    ? Icon(
                                        Icons.check_box_outline_blank,
                                        size: 20.sp,
                                      )
                                    : Icon(
                                        Icons.check_box_outlined,
                                        size: 20.sp,
                                      )),
                          )
                  ],
                ),
              ),
            ),
          )
        : alldealerfordisplay[index].sconfrim == null
            ? Card(
                color: Colors.grey[50],
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            alldealerfordisplay[index].companyname,
                            style: TextConstants.textstyle,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    _launchPhoneURL(index);
                                  },
                                  icon: Icon(
                                    Icons.call,
                                    color: Colors.black,
                                  )),
                              Text(
                                alldealerfordisplay[index].phone,
                                style: TextConstants.textstyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                      toggle == false
                          ? SizedBox(
                              height: 10,
                            )
                          : Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      toggleselect[index] =
                                          !toggleselect[index];
                                      toggleall = false;
                                    });
                                  },
                                  icon: toggleselect[index] == false
                                      ? Icon(
                                          Icons.check_box_outline_blank,
                                          size: 20.sp,
                                        )
                                      : Icon(
                                          Icons.check_box_outlined,
                                          size: 20.sp,
                                        )),
                            )
                    ],
                  ),
                ),
              )
            : SizedBox();
  }

  Future<void> scanbarcode() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      setState(() {
        _scanBarcode = barcodeScanRes;
        list = _scanBarcode.split(" ");
      });
      insertdealertocustomer();
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  Future<List<Getalldealer>> fectalldealerdata() async {
    SharedPreferences preferences1 = await SharedPreferences.getInstance();
    stringpreferences1 = preferences1.getStringList("codestore");

    namestore = stringpreferences1![3];
    auth = stringpreferences1![4];

    String url = "http://185.78.165.189:3001/sigspaceapi/fulldealer";
    var body = {
      "cuscode": stringpreferences1![0],
    };

    http.Response response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: JsonEncoder().convert(body));

    dynamic jsonres = json.decode(response.body);
    List<Getalldealer>? _alldealer = [];

    for (var u in jsonres) {
      Getalldealer data = Getalldealer(
          u["MAX(c.cuscode)"],
          u["MAX(c.cusname)"],
          u["MAX(c.phone)"],
          u["MAX(c.address)"],
          u["MAX(c.codestore)"],
          u["MAX(c.sconfirm)"],
          u["companyname"],
          u["auth"],
          u["saleid"]);
      _alldealer.add(data);
    }

    for (var i in jsonres) {
      toggleselect.add(false);
    }

    return _alldealer;
  }

  _launchPhoneURL(index) async {
    String url = ('tel:' + alldealerfordisplay[index].phone);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future insertintonotice() async {
    if (_formkey.currentState!.validate()) {
      try {
        SharedPreferences preferences1 = await SharedPreferences.getInstance();
        stringpreferences1 = preferences1.getStringList("codestore");
        String url = "http://185.78.165.189:3001/sigspaceapi/insertintonotice";

        for (int i = 0; i < alldealerfordisplay.length; i++) {
          if (toggleselect[i] == true) {
            var body = {
              //if sent message order number set = 0
              "ordernumber": 0.toString(),
              "fromwho": stringpreferences1![0],
              "fromposition": stringpreferences1![1],
              "towho": alldealerfordisplay[i].cuscode,
              "toposition": "DEALER",
              "message": message.text.trim()
            };

            http.Response response = await http.post(Uri.parse(url),
                headers: {'Content-Type': 'application/json; charset=utf-8'},
                body: JsonEncoder().convert(body));
          }
        }
        return showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  content: new Text("Message send successfully"),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      } catch (error) {
        print(error);
      }
    }
  }

  Future insertintonoticefordealer() async {
    if (_formkey.currentState!.validate()) {
      try {
        SharedPreferences preferences1 = await SharedPreferences.getInstance();
        stringpreferences1 = preferences1.getStringList("codestore");
        String url = "http://185.78.165.189:3001/sigspaceapi/insertintonotice";

        for (int i = 0; i < alldealerfordisplay.length; i++) {
          if (toggleselect[i] == true) {
            var body = {
              "ordernumber": 0.toString(),
              "fromwho": stringpreferences1![0],
              "fromposition": stringpreferences1![1],
              "towho": alldealerfordisplay[i].cuscode,
              "toposition": "SALE",
              "message": message.text.trim()
            };
            http.Response response = await http.post(Uri.parse(url),
                headers: {'Content-Type': 'application/json; charset=utf-8'},
                body: JsonEncoder().convert(body));
          }
        }

        setState(() {
          toggle = false;
          toggleall = false;
          message.clear();
          for (int i = 0; i < alldealerfordisplay.length; i++) {
            toggleselect[i] = false;
          }
        });
        return showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  content: new Text("Message send successfully"),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      } catch (error) {
        print(error);
      }
    }
  }

//------------------------------------------------------new--------------------------------------------------//

  Future insertdealertocustomer() async {
    try {
      SharedPreferences preferences1 = await SharedPreferences.getInstance();
      stringpreferences1 = preferences1.getStringList("codestore");
      String url =
          "http://185.78.165.189:3001/sigspaceapi/insertdealertocustomer";

      for (int i = 0; i < alldealerfordisplay.length; i++) {
        if (list[0].trim() == alldealerfordisplay[i].cuscode) {
          togglecheck = true;
          break;
        }
      }

      if (togglecheck == false) {
        var body = {
          "cuscode": stringpreferences1![0],
          "cusname": stringpreferences1![3],
          "phone": list[0].trim(),
          "codestore": list[2].trim(),
          "saleid": list[3].trim(),
          "dealerid": stringpreferences1![2]
        };
        print(body);

        http.Response response = await http.post(Uri.parse(url),
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            body: JsonEncoder().convert(body));

        return showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  content: new Text("Message send successfully"),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      } else {
        return showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  content: new Text("Duplicate Dealer"),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          togglecheck == false;
                        });
                      },
                    )
                  ],
                ));
      }
    } catch (error) {
      print(error);
    }
  }

  Future insertlineuid() async {
    try {
      String url = "http://185.78.165.189:3001/sigspaceapi/insertlineuid";

      var body = {
        "userid": stringpreferences1![2],
      };

      http.Response response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: JsonEncoder().convert(body));
    } catch (error) {
      print(error);
    }
  }

  Future<void> _openline() async {
    String LineURL = 'https://page.line.me/962ekjzu';
    await canLaunch(LineURL)
        ? await launch(LineURL)
        : throw 'Could not launch $LineURL';
  }

  void cancellinenoti() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: SizedBox(
            height: 80.sp,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                new Text("ยกเลิกการแจ้งเตือนผ่านไลน์ ?"),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        child: Container(
                            width: 18.w,
                            height: 5.h,
                            color: Colors.green,
                            child: Center(
                                child: Text(
                              "Yes",
                              style: TextStyle(color: Colors.white),
                            ))),
                        onPressed: () {
                          deletelineuid();
                        }),
                    TextButton(
                        child: Container(
                            width: 18.w,
                            height: 5.h,
                            color: Colors.red,
                            child: Center(
                                child: Text(
                              "No",
                              style: TextStyle(color: Colors.white),
                            ))),
                        onPressed: () {
                          Navigator.canPop(context)
                              ? Navigator.pop(context)
                              : null;
                        })
                  ],
                ),
                // ignore: unnecessary_new
              ],
            ),
          ),
        ),
      );

  Future deletelineuid() async {
    try {
      String url =
          "http://185.78.165.189:3001/sigspaceapi/deletelineuid/${stringpreferences1![2]}";

      http.Response response = await http.delete(Uri.parse(url),
          headers: {'Content-Type': 'application/json; charset=utf-8'});
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return MyApp();
      }));
    } catch (e) {
      print(e);
    }
  }
}
