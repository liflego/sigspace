import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';

import 'package:sizer/sizer.dart';

class ColorConstants {
  static Color? backgroundbody = Colors.white;
  static Color? appbarcolor = Colors.teal[800];
  static Color? buttoncolor = Colors.amber;
  static Color? cardcolor = HexColor("#F6D55C");
  static Color? sc4 = HexColor("#FFB117");
  static Color? sc3 = HexColor("#FFDC2E");
  static Color? sc2 = HexColor("#FAE39C");
  static Color? colorcardorder = HexColor("#E5E5E5");
}

class TextConstants {
  static TextStyle? textstyle = TextStyle(
      fontSize: 18.sp, fontFamily: 'newbodyfont', color: Colors.black);
  static TextStyle? textstylewh = TextStyle(
      fontSize: 18.sp, fontFamily: 'newbodyfont', color: Colors.white);
  static TextStyle? textstyleforhistory = TextStyle(
      fontSize: 16.sp, fontFamily: 'newbodyfont', color: Colors.black);
  static TextStyle? textstyleforheader = TextStyle(
      fontSize: 20.sp, fontFamily: 'newbodyfont', color: Colors.black);
  static TextStyle? textStylenotes = TextStyle(
      fontSize: 18.sp, fontFamily: 'newbodyfont', color: Colors.grey[600]);
  static TextStyle? appbartextsyle = TextStyle(
      fontFamily: 'newtitlefont', fontSize: 25.sp, color: Colors.white);
  static TextStyle? textstyleheadnotice = TextStyle(
      fontSize: 20.sp, fontFamily: 'newbodyfont', color: Colors.white);
}

class Getallproduct {
  String codeproduct;
  String nameproduct;
  int amount;
  int amountpercrate;
  String productset;
  String alltype;

  Getallproduct(
    this.codeproduct,
    this.nameproduct,
    this.amount,
    this.amountpercrate,
    this.productset,
    this.alltype,
  );
}

class Getallcustomer {
  String cuscode;
  String cusname;
  String phone;
  String address;
  String codestore;
  int sconfrim;
  String auth;
  int saleid;
  Getallcustomer(this.cuscode, this.cusname, this.phone, this.address,
      this.codestore, this.sconfrim, this.auth, this.saleid);
}

class Getalldealer {
  String cuscode;
  String cusname;
  String phone;
  String address;
  String codestore;
  int sconfrim;
  String companyname;
  String auth;
  int saleid;
  Getalldealer(this.cuscode, this.cusname, this.phone, this.address,
      this.codestore, this.sconfrim, this.companyname, this.auth, this.saleid);
}

//get data from table order by codestore and customer code
class GetorderBycodestoreandcuscodeandordernumber {
  int ordernumber;
  String codeproduct;
  String nameproduct;
  int amount;
  int getprice;
  String pay;
  String notes;
  String date;
  num price;

  GetorderBycodestoreandcuscodeandordernumber(
      this.ordernumber,
      this.codeproduct,
      this.nameproduct,
      this.amount,
      this.getprice,
      this.pay,
      this.notes,
      this.date,
      this.price);
}

class Getalldelivery {
  int? orders;
  String? codeproduct;
  String? nameproduct;
  int numbers;
  String? address;
  String? iddelivery;
  String? username;
  int? success;
  int? companyid;
  String codestore;
  String? cpn_deliveryname;
  String? cpn_deliverylink;

  Getalldelivery(
      this.orders,
      this.codeproduct,
      this.nameproduct,
      this.numbers,
      this.address,
      this.iddelivery,
      this.username,
      this.success,
      this.companyid,
      this.codestore,
      this.cpn_deliveryname,
      this.cpn_deliverylink);
}

class Getdeliverylist {
  int? orders;
  String? codeproduct;
  String? nameproduct;
  int? numbers;
  String? address;

  Getdeliverylist(this.orders, this.codeproduct, this.nameproduct, this.numbers,
      this.address);
}

class Getcustomerstore {
  String name;
  String code;
  int dealerid;
  String auth;
  Getcustomerstore(this.name, this.code, this.dealerid, this.auth);
}

class Getallorders {
  String cuscode;
  int ordernumber;
  String pay;
  num price;
  int saleconfirm;
  String cusname;
  int amountlist;
  String date;
  String auth;
  String track;

  Getallorders(
      this.cuscode,
      this.ordernumber,
      this.pay,
      this.price,
      this.saleconfirm,
      this.cusname,
      this.amountlist,
      this.date,
      this.auth,
      this.track);
}

// class for get data from noti database
class Getnotifordealer {
  int ordernumber;
  String fromwho;
  String towho;
  String message;
  String date;
  String namestore;
  String pay;
  int countorder;
  num priceall;
  String pathimg;
  String nameimg;
  String codestore;
  String datedelivery;

  Getnotifordealer(
      this.ordernumber,
      this.fromwho,
      this.towho,
      this.message,
      this.date,
      this.namestore,
      this.pay,
      this.countorder,
      this.priceall,
      this.pathimg,
      this.nameimg,
      this.codestore,
      this.datedelivery);
}

// uusadfiybh
