import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:parking_reservation/utils/constant_themes.dart';

class TopbarPesanan extends StatefulWidget {
  final String title;
  final VoidCallback callback;

  TopbarPesanan({Key? key, required this.title, required this.callback})
      : super(key: key);

  @override
  State<TopbarPesanan> createState() => _TopbarPesananState();
}

class _TopbarPesananState extends State<TopbarPesanan> {
  @override
  Widget build(BuildContext context) {
    return topbar();
  }

  Widget topbar() => Container(
        color: Colors.blue,
        width: double.infinity,
        height: 40.h,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 10.w),
              back(),
              SizedBox(width: 10.w),
              title(),
            ],
          ),
        ),
      );

  Widget back() => InkWell(
        onTap: () => this.widget.callback(),
        child: Icon(Icons.chevron_left, color: Colors.white),
      );

  Widget title() => Text(this.widget.title, style: text_title_topbar);
}
