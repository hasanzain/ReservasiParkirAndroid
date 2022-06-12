import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:parking_reservation/models/item_booking_model.dart';
import 'package:parking_reservation/utils/constant_themes.dart';
import 'package:parking_reservation/views/pesanan_page.dart';

class PesananParkirItem extends StatefulWidget {
  final ItemBookingModel item;

  PesananParkirItem({Key? key, required this.item}) : super(key: key);

  @override
  State<PesananParkirItem> createState() => _PesananParkirItemState();
}

class _PesananParkirItemState extends State<PesananParkirItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration_parking_status_item,
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
      margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 3.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          rowMaker(kodeBooking(), Container()),
          SizedBox(height: 8.h),
          rowMaker(keyjmasuk(), valuejmasuk()),
          SizedBox(height: 4.h),
          rowMaker(keyjkeluar(), valuejkeluar()),
        ],
      ),
    );
  }

  String getTime(String rawTime) {
    DateTime start =
        DateTime.fromMillisecondsSinceEpoch(int.parse(rawTime) * 1000);
    return "${start.hour}:${start.minute} ${start.day}/${start.month}/${start.year}";
  }

  Widget keyjmasuk() => Text("Jam masuk: ", style: ts_key_notif);

  Widget keyjkeluar() => Text("Jam keluar: ", style: ts_key_notif);

  Widget valuejmasuk() => Text(
      widget.item.jamMasuk! == "0"
          ? "belum ada"
          : getTime(widget.item.jamMasuk!),
      style: ts_value_notif);

  Widget valuejkeluar() => Text(
      widget.item.jamKeluar! == "0"
          ? "belum ada"
          : getTime(widget.item.jamKeluar!),
      style: ts_value_notif);

  Widget kodeBooking() => Text(widget.item.kodeBooking!, style: ts_kb_item);

  // Widget nomorTempat() =>
  //     Text("Kode tempat ${this.widget.item.kodeTempat}", style: ts_value_notif);

  Widget rowMaker(Widget child1, Widget child2) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [child1, child2]);
}
