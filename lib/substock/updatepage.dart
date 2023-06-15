import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigspace/classapi/class.dart';
import 'package:sigspace/main.dart';
import 'package:sizer/sizer.dart';
import 'dart:io' as io;

class updatepage extends StatefulWidget {
  String codeproduct;
  String nameproduct;
  String type;
  String pdpd;
  int amount;
  int amountper;

  updatepage({
    Key? key,
    required this.codeproduct,
    required this.nameproduct,
    required this.type,
    required this.pdpd,
    required this.amount,
    required this.amountper,
  }) : super(key: key);

  @override
  _updatepage createState() => _updatepage();
}

class _updatepage extends State<updatepage> {
  @override
  List<dynamic>? allproductfordisplay = [];
  TextEditingController score = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController price = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  List<String>? stringpreferences1;
  io.File? selectedImage;
  String? getnameimg;
  var resJson;
  int toggle = 0;
  int toggle1 = 0;
  int toggle2 = 0;

  void initState() {
    amount.text = "0";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return SafeArea(
            top: false,
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 7.h,
                title: Text(
                  "UPDATE",
                  style: TextStyle(fontFamily: 'newtitlefont', fontSize: 25.sp),
                ),
                backgroundColor: ColorConstants.appbarcolor,
                leading: IconButton(
                    onPressed: () async {
                      SharedPreferences pagepref =
                          await SharedPreferences.getInstance();
                      pagepref.setInt("pagepre", 1);
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => MyApp()));
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 20.sp,
                    )),
              ),
              backgroundColor: ColorConstants.backgroundbody,
              body: Form(
                key: _formkey,
                child: ListView(children: [
                  SizedBox(child: listitem()),
                  update(),
                  buttondone()
                ]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget update() {
    return Padding(
        padding: EdgeInsets.all(8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "EDIT :",
            style: TextStyle(
                fontSize: 20.sp,
                fontFamily: 'newbodyfont',
                color: Colors.black),
          ),
          //toggle check
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  child: Text("แก้ไขคะแนน :", style: TextConstants.textstyle)),
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (toggle == 0) {
                        toggle = 1;
                      } else {
                        toggle = 0;
                      }
                      print(toggle);
                    });
                  },
                  icon: Icon(Icons.arrow_drop_down)),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  child: Text("เพิ่มจำนวนสินค้า :",
                      style: TextConstants.textstyle)),
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (toggle1 == 0) {
                        toggle1 = 1;
                      } else {
                        toggle1 = 0;
                      }
                      print(toggle1);
                    });
                  },
                  icon: Icon(Icons.arrow_drop_down)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                toggle1 == 0
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                      )
                    : SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "จำนวน :",
                              style: TextConstants.textstyle,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 3,
                                child: TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      amount.text = value;
                                    });
                                  },
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontFamily: 'newbodyfont',
                                      color: Colors.black),
                                  textAlign: TextAlign.start,
                                  decoration: InputDecoration(
                                    helperText: "จำนวนที่ต้องการเพิ่ม",
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: BorderSide(
                                          color: HexColor('#39474F'), width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: BorderSide(
                                          color: Colors.yellow.shade800,
                                          width: 2),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  child: Text("แก้ไขราคา :", style: TextConstants.textstyle)),
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (toggle2 == 0) {
                        toggle2 = 1;
                      } else {
                        toggle2 = 0;
                      }
                      print(toggle2);
                    });
                  },
                  icon: Icon(Icons.arrow_drop_down)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                toggle2 == 0
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                      )
                    : SizedBox(
                        child: Row(
                          children: [
                            Text(
                              "Price :",
                              style: TextConstants.textstyle,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 3,
                                child: TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      price.text = value;
                                    });
                                  },
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontFamily: 'newbodyfont',
                                      color: Colors.black),
                                  textAlign: TextAlign.start,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: BorderSide(
                                          color: HexColor('#39474F'), width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                          color: Colors.yellow.shade800,
                                          width: 2),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ]));
  }

  Widget buttondone() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        child: TextButton(
          onPressed: updateamountproduct,
          child: Text(
            "DONE",
            style: TextStyle(
                fontSize: 20.sp,
                fontFamily: 'newbodyfont',
                color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget listitem() {
    return Card(
        elevation: 2,
        color: ColorConstants.cardcolor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 0.w),
          child: SingleChildScrollView(
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                              widget.nameproduct +
                                  "(" +
                                  widget.type +
                                  "ละ" +
                                  "${widget.amountper}" +
                                  ")",
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'newbodyfont',
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.codeproduct,
                                  style: TextConstants.textstyle,
                                ),
                                Text(
                                  "ประเภท: ${widget.type}",
                                  style: TextConstants.textstyle,
                                ),
                                widget.amount == 0
                                    ? Text(
                                        "จำนวน : ${widget.amount}",
                                        style: TextStyle(
                                            fontSize: 18.sp,
                                            fontFamily: 'newbodyfont',
                                            color: Colors.red),
                                      )
                                    : Text(
                                        "จำนวน : ${widget.amount}" +
                                            "(${((widget.amount) / widget.amountper).toInt()}" +
                                            widget.pdpd +
                                            ")",
                                        style: TextConstants.textstyle,
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future updateamountproduct() async {
    if (_formkey.currentState!.validate()) {
      try {
        SharedPreferences preferences1 = await SharedPreferences.getInstance();
        stringpreferences1 = preferences1.getStringList("codestore");
        String url =
            "http://185.78.165.189:3001/sigspaceapi/updateamountproduct";
        if (getnameimg == null || getnameimg == "null") {
          var body = {
            "nameproduct": widget.nameproduct,
            "score": score.text.trim(),
            "amount": amount.text.trim(),
            "price": price.text.trim(),
            "pathimg": "Cpic",
            "nameimg": "null",
            "codestore": stringpreferences1![0],
            "codeproduct": widget.codeproduct
          };
          print(body);
          http.Response response = await http.patch(Uri.parse(url),
              headers: {'Content-Type': 'application/json; charset=utf-8'},
              body: JsonEncoder().convert(body));

          if (response.statusCode == 200) {
            return showDialog(
                context: context,
                // ignore: unnecessary_new
                builder: (_) => new AlertDialog(
                      content: new Text("UPDATE SUCCESSFULLY"),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            //onUploadImage();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => MyApp()));
                          },
                        )
                      ],
                    ));
          } else {
            print("server error");
          }
        } else {
          var body = {
            "nameproduct": widget.nameproduct,
            "score": score.text.trim(),
            "amount": amount.text.trim(),
            "price": price.text.trim(),
            "pathimg": "Cpic",
            "nameimg": getnameimg,
            "codestore": stringpreferences1![0],
            "codeproduct": widget.codeproduct
          };
          print(body);
          http.Response response = await http.patch(Uri.parse(url),
              headers: {'Content-Type': 'application/json; charset=utf-8'},
              body: JsonEncoder().convert(body));

          if (response.statusCode == 200) {
            return showDialog(
                context: context,
                // ignore: unnecessary_new
                builder: (_) => new AlertDialog(
                      content: new Text("UPDATE SUCCESSFULLY"),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => MyApp()));
                          },
                        )
                      ],
                    ));
          } else {
            print("server error");
          }
        }
      } catch (e) {
        print(e);
      }
    } else {
      print("server error");
    }
  }
}
