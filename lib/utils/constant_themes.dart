import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final primary_color = Colors.green[600];

final secondary_color = Colors.green[400];

final inactive_color = Colors.grey;

final border_radius = BorderRadius.circular(5.r);

final small_padding = EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w);

final item_padding = EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w);

final item_text_title_style = TextStyle(
    fontSize: 12.6.sp, fontWeight: FontWeight.w600, color: Colors.black);

final item_text_subtitle_style = TextStyle(
    fontSize: 11.sp, fontWeight: FontWeight.w400, color: Colors.black54);

final decoration_button_active =
    BoxDecoration(borderRadius: border_radius, color: Colors.blue);

final text_active_white = TextStyle(
    color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13.sp);

final decoration_parking_status_item = BoxDecoration(
    borderRadius: border_radius,
    color: Colors.white,
    border: Border.all(color: Colors.black12));

final text_booking_style = TextStyle(
  color: primary_color,
  fontSize: 10.sp,
  fontWeight: FontWeight.w700,
);

final text_no_booking_style = TextStyle(
  color: inactive_color,
  fontSize: 10.sp,
  fontWeight: FontWeight.w700,
);

final decoration_booking_container =
    BoxDecoration(color: Colors.white, borderRadius: border_radius);

final item_margin = EdgeInsets.symmetric(vertical: 2.h);

final decoration_alert_yes =
    BoxDecoration(borderRadius: BorderRadius.circular(3.r), color: Colors.blue);

final text_alert_yes = TextStyle(
    fontSize: 11.sp, fontWeight: FontWeight.w500, color: Colors.white);

final decoration_alert_batal = BoxDecoration(
    borderRadius: BorderRadius.circular(3.r),
    border: Border.all(color: Colors.black38));

final text_alert_batal = TextStyle(
    fontSize: 11.sp, fontWeight: FontWeight.w500, color: Colors.black87);

final text_alert_title = TextStyle(
    fontSize: 11.sp, fontWeight: FontWeight.w500, color: Colors.black87);

final margin_container_notif =
    EdgeInsets.symmetric(vertical: 3.h, horizontal: 8.w);

final padding_container_notif = EdgeInsets.symmetric(horizontal: 7.w);

final decoration_available_container_notif = BoxDecoration(
    color: Colors.blue[50], borderRadius: BorderRadius.circular(6.r));

final decoration_unavailable_container_notif = BoxDecoration(
    color: Colors.orange[50], borderRadius: BorderRadius.circular(6.r));

final text_greet_style_topbar_dashboard = TextStyle(
    fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.white);

final text_name_style_topbar_dashboard = TextStyle(
    fontSize: 12.sp, fontWeight: FontWeight.w600, color: Colors.white);

final text_title_topbar = TextStyle(
    fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.white);

final decoration_batal_pesanan =
    BoxDecoration(color: Colors.white, border: Border.all(color: Colors.red));

final margin_button = EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h);

final text_style_batalkan_pesanan =
    TextStyle(color: Colors.red, fontSize: 13.sp, fontWeight: FontWeight.w600);

final ts_key_notif = TextStyle(
    fontWeight: FontWeight.w700, color: Colors.black54, fontSize: 11.sp);

final ts_value_notif = TextStyle(
    fontWeight: FontWeight.w700, color: Colors.black87, fontSize: 11.sp);

final ts_kb_item = TextStyle(
    fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.black87);
