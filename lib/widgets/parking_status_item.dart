import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parking_reservation/models/parking_status_model.dart';
import 'package:parking_reservation/models/status_parking_model.dart';
import 'package:parking_reservation/utils/constant_themes.dart';
import 'package:parking_reservation/widgets/widget_alert.dart';

class StatusParkingItem extends StatefulWidget {
  final ItemStatusParkingModel parkingStatusModel;
  final Function(String) callbackBooking;

  StatusParkingItem(
      {Key? key,
      required this.parkingStatusModel,
      required this.callbackBooking})
      : super(key: key);

  @override
  State<StatusParkingItem> createState() => _StatusParkingItemState();
}

class _StatusParkingItemState extends State<StatusParkingItem> {
  final String available = "tersedia";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: item_margin,
      width: double.infinity,
      padding: item_padding,
      // decoration: decoration_parking_status_item,
      child: Column(
        children: [
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              columnTempat(),
              widget.parkingStatusModel.statusTersedia == available
                  ? activeBooking()
                  : passiveBooking(),
            ],
          ),
        ],
      ),
    );
  }

  Widget namaTempat() => Container(
        width: 200.w,
        padding: EdgeInsets.symmetric(vertical: 3.h),
        child: Text("${widget.parkingStatusModel.idTempat}",
            style: item_text_title_style),
      );

  Widget lokasiTempat() => Container(
        width: 200.w,
        padding: EdgeInsets.symmetric(vertical: 3.h),
        child: Text(
          "Lokasi: ${widget.parkingStatusModel.lokasiTempat}",
          style: item_text_title_style,
        ),
      );

  Widget statusTempat() => Container(
        width: 200.w,
        padding: EdgeInsets.symmetric(vertical: 3.h),
        child: Text(
            "Status tersedia: ${widget.parkingStatusModel.statusTersedia}",
            style: item_text_subtitle_style),
      );

  Widget columnTempat() => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          namaTempat(),
          SizedBox(height: 1.h),
          lokasiTempat(),
          SizedBox(height: 1.h),
          statusTempat(),
        ],
      );

  Widget activeBooking() => WidgetAlert(
      callback: () =>
          widget.callbackBooking(widget.parkingStatusModel.idTempat!),
      content: 'Booking tempat parkir ini?',
      child: Container(
        decoration: decoration_booking_container,
        padding: item_padding,
        child: Text("Booking", style: text_booking_style),
      ));

  Widget passiveBooking() => Container(
        decoration: decoration_booking_container,
        padding: item_padding,
        child: Text("Booking", style: text_no_booking_style),
      );
}
