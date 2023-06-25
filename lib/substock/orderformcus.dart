import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigspace/checkstock.dart';
import 'package:sigspace/classapi/class.dart';
import 'package:sigspace/main.dart';
import 'package:sizer/sizer.dart';
import 'package:textfield_search/textfield_search.dart';
import 'package:http/http.dart' as http;

class orderfromcus extends StatefulWidget {
  List<String> codeorder = [];
  List<String> nameorder = [];
  List<int> numorder = [];
  List<String> numpercrate = [];
  List<String> productset = [];
  List<int> priceforpack = [];

  orderfromcus({
    Key? key,
    required this.codeorder,
    required this.nameorder,
    required this.numorder,
    required this.numpercrate,
    required this.productset,
    required this.priceforpack,
  }) : super(key: key);

  @override
  _orderfromcus createState() => _orderfromcus();
}

class _orderfromcus extends State<orderfromcus> {
  @override
  TextEditingController mysearh = TextEditingController();
  TextEditingController notes = TextEditingController();
  TextEditingController step1 = TextEditingController();
  TextEditingController step2 = TextEditingController();
  TextEditingController step3 = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  late String pay;
  List<double>? listgetprice = [];
  List<double>? listgetpricevat = [];
  final numformat = new NumberFormat("#,##0.00", "en_US");

  _printLatestValue() {
    print("text field: ${mysearh.text}");
  }

  bool toggle1 = false;
  bool toggle2 = false;
  bool togglecal = false;

  int toggleaddstep = 0;
  List<bool>? togglechoose = [];
  List<String>? stringpreferences1;
  String? stringpreferences2;
  List<String>? getdatatocheckstock;
  List<Getcustomerstore> alldata = [];
  late int lastorder;

  @override
  void initState() {
    mysearh.addListener(_printLatestValue);
    for (int i = 0; i < widget.codeorder.length; i++) {
      togglechoose!.add(false);
    }

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
                  leading: IconButton(
                      onPressed: () async {
                        if (stringpreferences1?[1] == "DEALER") {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => checkstock(
                                        codeorder: [],
                                        nameorder: [],
                                        numorder: [],
                                        numpercrate: [],
                                        productset: [],
                                        priceforpack: [],
                                      )));
                        } else {
                          SharedPreferences pagepref =
                              await SharedPreferences.getInstance();
                          pagepref.setInt("pagepre", 0);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => MyApp()));
                        }
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20.sp,
                      )),
                  actions: [
                    IconButton(
                        onPressed: () {
                          if (togglecal == false) {
                            setState(() {
                              togglecal = true;
                            });
                          } else {
                            setState(() {
                              togglecal = false;
                              listgetprice!.clear();
                              listgetpricevat!.clear();
                            });
                          }
                        },
                        icon: Icon(
                          Icons.local_shipping,
                          size: 20.sp,
                          color: Colors.white,
                        )),
                    IconButton(
                        onPressed: backtostock,
                        icon: Icon(
                          Icons.add_circle,
                          size: 20.sp,
                          color: Colors.white,
                        ))
                  ],
                  toolbarHeight: 7.h,
                  title: Text(
                    "ORDER",
                    style: TextConstants.appbartextsyle,
                  ),
                  backgroundColor: ColorConstants.appbarcolor,
                ),
                body: ListView(
                  children: [
                    Container(
                      color: Colors.amber,
                      height: MediaQuery.of(context).size.height / 2,
                      child: listitems(),
                    ),
                    data()
                  ],
                )));
      }),
    );
  }

  Widget tabsearch() {
    return Expanded(
      child: TextFieldSearch(
          label: '',
          textStyle: TextStyle(
              color: Colors.white, fontFamily: "newtitlefont", fontSize: 20.sp),
          controller: mysearh,
          decoration: InputDecoration(
            hintText: "เลือกร้านค้า",
            hintStyle: TextStyle(color: Colors.white),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: HexColor('#1034A6')),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          future: () {
            return fetchSimpleData();
          }),
    );
  }

  Widget listitems() {
    return Padding(
      padding: EdgeInsets.all(2.0),
      child: ListView.builder(
        itemCount: widget.codeorder.length,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Slidable(
              endActionPane: ActionPane(
                motion: ScrollMotion(),
                children: [
                  Container(
                    color: Colors.red[900],
                    width: MediaQuery.of(context).size.width / 2.25,
                    height: MediaQuery.of(context).size.height,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          widget.codeorder.removeAt(index);
                          widget.nameorder.removeAt(index);
                          widget.numorder.removeAt(index);
                          widget.numpercrate.removeAt(index);
                          widget.productset.removeAt(index);
                          widget.priceforpack.removeAt(index);
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 22.sp,
                          ),
                          Text(
                            "delete",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'newbodyfont',
                                fontSize: 15.sp),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.nameorder[index],
                          maxLines: 3,
                          style: TextStyle(
                              fontFamily: 'newbodyfont', fontSize: 18.sp)),
                      Text(widget.codeorder[index],
                          style: TextStyle(
                            fontFamily: 'newbodyfont',
                            fontSize: 18.sp,
                          )),
                      //exvat
                      Text(
                          "จำนวน ${widget.numorder[index]}" +
                              "("
                                  "${(widget.numorder[index] / int.parse(widget.numpercrate[index])).toInt().toString()}" +
                              "${widget.productset[index]})",
                          style: TextStyle(
                            fontFamily: 'newbodyfont',
                            fontSize: 18.sp,
                          )),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "หน่วยละ " +
                                    widget.priceforpack[index]
                                        .toStringAsFixed(2) +
                                    " บาท",
                                style: TextStyle(
                                    fontFamily: 'newbodyfont',
                                    fontSize: 18.sp,
                                    color: Colors.red)),
                            Text(
                                "รวม " +
                                    (widget.numorder[index] *
                                            widget.priceforpack[index])
                                        .toStringAsFixed(2) +
                                    " บาท",
                                style: TextStyle(
                                    fontFamily: 'newbodyfont',
                                    fontSize: 18.sp,
                                    color: Colors.red))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget textpriceall() {
  //   return Padding(
  //     padding: const EdgeInsets.all(6.0),
  //     child: Center(
  //         child: togglecal == false
  //             ? SizedBox()
  //             : togglevat == true
  //                 ? listgetpricevat!.isNotEmpty
  //                     ? Text(
  //                         "ราคารวม " +
  //                             listgetpricevat!
  //                                 .reduce((value, element) => (value) + element)
  //                                 .toStringAsFixed(2),
  //                         style: TextConstants.textstyle,
  //                       )
  //                     : Text("ราคารวม", style: TextConstants.textstyle)
  //                 : listgetprice!.isNotEmpty
  //                     ? Text(
  //                         "ราคารวม " +
  //                             listgetprice!
  //                                 .reduce((value, element) => (value) + element)
  //                                 .toStringAsFixed(2),
  //                         style: TextConstants.textstyle,
  //                       )
  //                     : Text("ราคารวม", style: TextConstants.textstyle)),
  //   );
  // }

  Widget data() {
    return Column(
      children: [
        SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: TextFormField(
              controller: notes,
              onFieldSubmitted: (value) => {},
              maxLines: 5,
              decoration: InputDecoration(hintText: " หมายเหตุ"),
            ),
          ),
        ),
        SizedBox(
          child: Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "วิธีชำระ",
                  style: TextStyle(
                      fontFamily: 'newbodyfont',
                      fontSize: 18.sp,
                      color: Colors.black),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        toggle1 = !toggle1;
                        toggle2 = false;
                      });
                    },
                    icon: toggle1 == false
                        ? Icon(Icons.circle_outlined)
                        : Icon(Icons.check_circle_outline)),
                Text(
                  "เงินสด",
                  style: TextStyle(
                      fontFamily: 'newbodyfont',
                      fontSize: 18.sp,
                      color: Colors.black),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        toggle2 = !toggle2;
                        toggle1 = false;
                      });
                    },
                    icon: toggle2 == false
                        ? Icon(Icons.circle_outlined)
                        : Icon(Icons.check_circle_outline)),
                Text(
                  "เครดิต",
                  style: TextStyle(
                      fontFamily: 'newbodyfont',
                      fontSize: 18.sp,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: TextButton(
              onPressed: done,
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 16,
                color: ColorConstants.buttoncolor,
                child: Center(
                  child: Text(
                    "DONE",
                    style: TextStyle(
                        fontFamily: 'newbodyfont',
                        fontSize: 18.sp,
                        color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<List> fetchSimpleData() async {
    await Future.delayed(Duration(milliseconds: 500));
    List _list = <dynamic>[];

    // create a list from the text input of three items
    // to mock a list of items from an http call
    List<String> stringpreferences1;
    SharedPreferences preferences1 = await SharedPreferences.getInstance();
    stringpreferences1 = preferences1.getStringList("codestore")!;
    String url = "http://185.78.165.189:3000/pythonapi/fullcustomer";
    var body = {
      "codestore": stringpreferences1[0],
    };

    http.Response response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: JsonEncoder().convert(body));

    dynamic jsonres = json.decode(response.body);

    for (var u in jsonres) {
      Getcustomerstore data = Getcustomerstore(
          u["MAX(c.cusname)"] + "[" + u["MAX(c.cuscode)"] + "]",
          u["MAX(c.cuscode)"],
          u["MAX(c.dealerid)"],
          u["auth"]);
      alldata.add(data);
      _list.add(u["MAX(c.cusname)"] + "[" + u["MAX(c.cuscode)"] + "]");
    }

    return _list;
  }

//สร้างเงื่อนไขสำหรับร้านค้าสั่งของเอง
  Future done() async {
    // getlastorder();
    String url = "http://185.78.165.189:3000/pythonapi/getlastorders";
//test api
    http.Response response = await http.get(Uri.parse(url));
    dynamic jsonres = json.decode(response.body);
    try {
      setState(() {
        lastorder = jsonres["ordernumber"] + 1;
        print(lastorder);
      });
    } catch (e) {
      setState(() {
        lastorder = 1;
      });
    }

    //insert to orders
    SharedPreferences preferences1 = await SharedPreferences.getInstance();
    stringpreferences1 = preferences1.getStringList("codestore");
    SharedPreferences preferences2 = await SharedPreferences.getInstance();
    getdatatocheckstock = preferences2.getStringList("dealercode");

    try {
      String url = "http://185.78.165.189:3000/pythonapi/insertorders";

      if ((toggle1 == true) & (toggle2 == false)) {
        setState(() {
          pay = "Cash";
        });
      } else if ((toggle1 == false) & (toggle2 == true)) {
        setState(() {
          pay = "Check";
        });
      } else {
        return showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  content: new Text("CHOOSE YOUR PAYMENT METHOD"),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      }
      if (notes.text == "") {
        setState(() {
          notes.text = "-";
        });
      }
      String getcuscode = "";
      String getcodestore = "";
      String getauth = "";
      int getdealerid = 0;
      if (stringpreferences1![1] == "DEALER") {
        getcodestore = getdatatocheckstock![0];
        getcuscode = stringpreferences1![0];
        getdealerid = int.parse(stringpreferences1![2]);
      } else {
        getcodestore = stringpreferences1![0];
        //filtet cuscode
        Iterable<Getcustomerstore> visi = alldata.where(
            (customercode) => customercode.name.contains(mysearh.text.trim()));
        visi.forEach((customercode) => getcuscode = customercode.code);
        //filter cusid
        Iterable<Getcustomerstore> visicusid =
            alldata.where((cusid) => cusid.name.contains(mysearh.text.trim()));
        visi.forEach((cusid) => getdealerid = cusid.dealerid);
        print("cusid is $getdealerid");
        //filter lineauth
        Iterable<Getcustomerstore> visiauth =
            alldata.where((auth) => auth.name.contains(mysearh.text.trim()));
        visi.forEach((auth) => getauth = auth.auth);
      }

      for (var i = 0; i < widget.codeorder.length; i++) {
        var body = {
          "ordernumber": lastorder,
          "codeproduct": widget.codeorder[i].trim(),
          "nameproduct": widget.nameorder[i].trim(),
          "amount": "${widget.numorder[i]}",
          "amountpercrate": int.parse(widget.numpercrate[i].trim()),
          "getprice": widget.priceforpack[i],
          "saleconfirm": 1,
          "codestore": getcodestore,
          "saleid": stringpreferences1![2],
          "cuscode": getcuscode.trim(),
          "cusid": getdealerid,
          "date": DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
          "pay": pay.trim(),
          "notes": notes.text.trim()
        };
        http.Response response = await http.post(Uri.parse(url),
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            body: JsonEncoder().convert(body));
        print(body);
      }
      deleteamount();
      insertintonotice();
      if (stringpreferences1![1] == "DEALER") {
        notiorderforsale();
      } else {
        notiorderfordealer(getauth);
        notiorderforadmin();
      }
      return showDialog(
          context: context,
          builder: (_) => new AlertDialog(
                content: new Text("ORDER SUCCESSFULLY"),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return MyApp();
                      }));
                    },
                  )
                ],
              ));
    } catch (error) {
      print(error);
    }
  }

  Future backtostock() async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => checkstock(
              codeorder: widget.codeorder,
              nameorder: widget.nameorder,
              numorder: widget.numorder,
              numpercrate: widget.numpercrate,
              productset: widget.productset,
              priceforpack: widget.priceforpack,
            )));
  }

  Future deleteamount() async {
    try {
      String url = "http://185.78.165.189:3000/pythonapi/deleteamount";
      SharedPreferences preferences1 = await SharedPreferences.getInstance();
      stringpreferences1 = preferences1.getStringList("codestore");
      for (var i = 0; i < widget.codeorder.length; i++) {
        var body = {
          "amount": "${widget.numorder[i]}",
          "codeproduct": widget.codeorder[i].trim(),
          "codestore": stringpreferences1![0],
        };

        http.Response response = await http.patch(Uri.parse(url),
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            body: JsonEncoder().convert(body));
      }
    } catch (e) {
      print(e);
    }
  }

  Future insertintonotice() async {
    try {
      String url = "http://185.78.165.189:3000/pythonapi/insertnewnotice";

      String cuscode = "";
      Iterable<Getcustomerstore> visi = alldata.where(
          (customercode) => customercode.name.contains(mysearh.text.trim()));
      visi.forEach((customercode) => cuscode = customercode.code);

      var body = {
        "ordernumber": lastorder,
        "fromwho": stringpreferences1![0],
        "fromposition": stringpreferences1![1],
        "towho": stringpreferences1![0],
        "toposition": "DEALER",
        "message": "order",
        "date": DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
      };
      http.Response response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: JsonEncoder().convert(body));
    } catch (error) {
      print(error);
    }
  }

  Future notiorderforsale() async {
    try {
      SharedPreferences preferences2 = await SharedPreferences.getInstance();
      getdatatocheckstock = preferences2.getStringList("dealercode");
      String url = "https://api.line.me/v2/bot/message/push";

      var body = {
        "to": getdatatocheckstock![1],
        "messages": [
          {
            "type": "text",
            "text": "ร้าน " + stringpreferences1![3] + " สั่งสินค้าเข้ามา"
          }
        ]
      };

      http.Response response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json; charset=utf-8',
            "Authorization":
                "Bearer Udr/QZCEGnv1Ylq05t7fuQqCMK9OSuoN5dIUWI/l+t8LEa3hiv+9l4Z/BhdtGJKd0dlXvWxrot5y4M3s5ID9r091xsS32x6/td+PzuZF2cPU8p633PaPQ4+nFwvCcjua109piyIgCJ4C7BbJ1DAblwdB04t89/1O/w1cDnyilFU="
          },
          body: JsonEncoder().convert(body));
    } catch (error) {}
  }

  Future notiorderfordealer(getauth) async {
    try {
      String url = "https://api.line.me/v2/bot/message/push";

      var body = {
        "to": getauth.toString(),
        "messages": [
          {
            "type": "text",
            "text":
                "ORDER $lastorder \nเซลล์สั่งสินค้าเข้ามาเเล้ว\nสามารถเข้าไปตรวจสอบได้ที่ SIGB ในหน้าแจ้งเตือน"
          }
        ]
      };

      http.Response response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json; charset=utf-8',
            "Authorization":
                "Bearer Udr/QZCEGnv1Ylq05t7fuQqCMK9OSuoN5dIUWI/l+t8LEa3hiv+9l4Z/BhdtGJKd0dlXvWxrot5y4M3s5ID9r091xsS32x6/td+PzuZF2cPU8p633PaPQ4+nFwvCcjua109piyIgCJ4C7BbJ1DAblwdB04t89/1O/w1cDnyilFU="
          },
          body: JsonEncoder().convert(body));
    } catch (error) {
      print(error);
    }
  }

  Future notiorderforadmin() async {
    try {
      String url = "http://185.78.165.189:3000/pythonapi/getadminauth";
      List<String> stringpreferences1;
      SharedPreferences preferences1 = await SharedPreferences.getInstance();
      stringpreferences1 = preferences1.getStringList("codestore")!;

      var body = {"codestore": stringpreferences1[0]};
      http.Response response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: JsonEncoder().convert(body));

      List jsonRes = json.decode(response.body);
      print(jsonRes[0]["auth"]);

      String lineurl = "https://api.line.me/v2/bot/message/push";
      for (int i = 0; i <= jsonRes.length; i++) {
        var linebody = {
          "to": jsonRes[i]["auth"].toString(),
          "messages": [
            {
              "type": "text",
              "text": "ORDER $lastorder \n จากเซลล์ ${stringpreferences1[2]}"
            }
          ]
        };
        print(linebody);
        http.Response lineresponse = await http.post(Uri.parse(lineurl),
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
              "Authorization":
                  "Bearer Udr/QZCEGnv1Ylq05t7fuQqCMK9OSuoN5dIUWI/l+t8LEa3hiv+9l4Z/BhdtGJKd0dlXvWxrot5y4M3s5ID9r091xsS32x6/td+PzuZF2cPU8p633PaPQ4+nFwvCcjua109piyIgCJ4C7BbJ1DAblwdB04t89/1O/w1cDnyilFU="
            },
            body: JsonEncoder().convert(linebody));
      }
    } catch (error) {
      print(error);
    }
  }
}
