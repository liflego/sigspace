import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:textfield_search/textfield_search.dart';
import 'package:url_launcher/url_launcher.dart';
import '../classapi/class.dart';
import 'package:http/http.dart' as http;
import 'package:popup_card/popup_card.dart';
import 'package:gallery_saver/gallery_saver.dart';

class notipage extends StatefulWidget {
  notipage({Key? key}) : super(key: key);

  @override
  _notipage createState() => _notipage();
}

class _notipage extends State<notipage> {
  List<String>? stringpreferences1;
  List<Getnotifordealer> allnotice = [];
  List<Getnotifordealer> allnoticefordisplay = [];

  List<bool> clickimg = [];

  @override
  void initState() {
    // fectalldata().then((value) {
    //   setState(() {
    //     allnotice.addAll(value);
    //     allnoticefordisplay = allnotice;
    //     clickimg.clear();
    //     for (int i = 0; i < allnoticefordisplay.length; i++) {
    //       clickimg.add(false);
    //     }
    //   });
    // });

    // TODO: implement initState
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
                automaticallyImplyLeading: false,
                backgroundColor: ColorConstants.appbarcolor,
                toolbarHeight: 7.h,
                title: Text(
                  "NOTICE",
                  style: TextStyle(fontFamily: 'newtitlefont', fontSize: 25.sp),
                ),
              ),
              backgroundColor: ColorConstants.backgroundbody,
              body: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                // child: ListView.builder(
                //   itemCount: allnoticefordisplay.length,
                //   itemBuilder: (BuildContext context, int index) {
                //     return listitem(index);
                //   },
                // ),
              ),
            ));
      }),
    );
  }

  Widget listitem(index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            Container(
              color: Colors.blue[900],
              width: MediaQuery.of(context).size.width / 2.25,
              height: MediaQuery.of(context).size.height,
              child: OutlinedButton(
                onPressed: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_basket_outlined,
                      color: Colors.white,
                      size: 22.sp,
                    ),
                    Text(
                      "LIST ORDER",
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
          child: SizedBox(
            child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: allnoticefordisplay[index].message == "order" &&
                        allnoticefordisplay[index].nameimg == null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2.5,
                              color: Colors.lightGreen[900],
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Center(
                                  child: Text(
                                    "คำสั่งซื้อสำเร็จ",
                                    style: TextConstants.textstyleheadnotice,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "คำสั่งซื้อของ " +
                                          "${allnoticefordisplay[index].namestore}",
                                      style: TextConstants.textstyle,
                                    ),
                                    Text(
                                      allnoticefordisplay[index]
                                          .date
                                          .substring(5, 25),
                                      style: TextConstants.textstyle,
                                    ),
                                  ],
                                ),
                                Text(
                                  "ออเดอร์ที่ ${allnoticefordisplay[index].ordernumber}",
                                  style: TextConstants.textstyle,
                                ),
                                Text(
                                  "จำนวนรายการ ${allnoticefordisplay[index].countorder}",
                                  style: TextConstants.textstyle,
                                ),
                                Text(
                                  "วิธีการชำระ ${allnoticefordisplay[index].pay}",
                                  style: TextConstants.textstyle,
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    : allnoticefordisplay[index].message == "adminconfirm" &&
                            allnoticefordisplay[index].priceall != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  color: Colors.blue[900],
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Center(
                                      child: Text(
                                        "แอดมินยืนยัน",
                                        style:
                                            TextConstants.textstyleheadnotice,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "คำสั่งซื้อของ " +
                                              "${allnoticefordisplay[index].namestore}",
                                          style: TextConstants.textstyle,
                                        ),
                                        Text(
                                          allnoticefordisplay[index]
                                              .date
                                              .substring(5, 25),
                                          style: TextConstants.textstyle,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "ออเดอร์ที่ ${allnoticefordisplay[index].ordernumber}",
                                      style: TextConstants.textstyle,
                                    ),
                                    Text(
                                      "จำนวนรายการ ${allnoticefordisplay[index].countorder}",
                                      style: TextConstants.textstyle,
                                    ),
                                    Text(
                                      "วิธีการชำระ ${allnoticefordisplay[index].pay}",
                                      style: TextConstants.textstyle,
                                    ),
                                    allnoticefordisplay[index].priceall == null
                                        ? SizedBox()
                                        : Text(
                                            "จำนวนเงิน ${allnoticefordisplay[index].priceall} บาท",
                                            style: TextConstants.textstyle,
                                          )
                                  ],
                                ),
                              )
                            ],
                          )
                        : allnoticefordisplay[index].message == "order" &&
                                allnoticefordisplay[index].nameimg != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.5,
                                      color: Colors.red[900],
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Center(
                                          child: Text(
                                            "ส่งของแล้ว",
                                            style: TextConstants
                                                .textstyleheadnotice,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "คำสั่งซื้อของ : " +
                                                  "${allnoticefordisplay[index].namestore}",
                                              style: TextConstants.textstyle,
                                            ),
                                            Flexible(
                                              child: Text(
                                                allnoticefordisplay[index]
                                                    .datedelivery
                                                    .substring(5, 25),
                                                style: TextConstants.textstyle,
                                                maxLines: 2,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "ออเดอร์ที่ : ${allnoticefordisplay[index].ordernumber}",
                                          style: TextConstants.textstyle,
                                        ),
                                        Text(
                                          "จำนวนรายการ : ${allnoticefordisplay[index].countorder}",
                                          style: TextConstants.textstyle,
                                        ),
                                        Text(
                                          "วิธีการชำระ: ${allnoticefordisplay[index].pay}",
                                          style: TextConstants.textstyle,
                                        ),
                                        allnoticefordisplay[index].priceall ==
                                                null
                                            ? SizedBox()
                                            : Text(
                                                "จำนวนเงิน : ${allnoticefordisplay[index].priceall} บาท",
                                                style: TextConstants.textstyle,
                                              ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.5,
                                      color: Colors.lightBlue[900],
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Center(
                                          child: Text(
                                            "ข้อความ",
                                            style: TextConstants
                                                .textstyleheadnotice,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "บริษัท " +
                                                  "${allnoticefordisplay[index].namestore}",
                                              style: TextConstants.textstyle,
                                            ),
                                            Text(
                                              allnoticefordisplay[index]
                                                  .date
                                                  .substring(5, 25),
                                              style: TextConstants.textstyle,
                                              maxLines: 2,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "${allnoticefordisplay[index].message}",
                                          style: TextConstants.textstyle,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )),
          ),
        ),
      ),
    );
  }

  Future<List<Getnotifordealer>> fectalldata() async {
    SharedPreferences preferences1 = await SharedPreferences.getInstance();
    stringpreferences1 = preferences1.getStringList("codestore");

    String url = "http://185.78.165.189:3001/sigspaceapi/getnoticefordealer";
    var body = {"towho": stringpreferences1![0]};

    List<Getnotifordealer>? _allnotice = [];

    http.Response response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: JsonEncoder().convert(body));

    dynamic jsonres = json.decode(response.body);

    for (var u in jsonres) {
      Getnotifordealer data = Getnotifordealer(
          u["MAX(a.ordernumber)"],
          u["MAX(a.fromwho)"],
          u["MAX(a.towho)"],
          u["MAX(a.message)"],
          u["MAX(a.date)"],
          u["MAX(c.namestore)"],
          u["MAX(b.pay)"],
          u["countorder"],
          u["priceall"],
          u["pathimg"],
          u["nameimg"],
          u["codestore"],
          u["date2"]);
      _allnotice.add(data);
    }

    return _allnotice;
  }
}
