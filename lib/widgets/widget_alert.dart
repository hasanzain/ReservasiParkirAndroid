import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ndialog/ndialog.dart';
import 'package:parking_reservation/utils/constant_themes.dart';

class WidgetAlert extends StatefulWidget {
  final String content;
  final VoidCallback callback;
  final Widget child;

  WidgetAlert(
      {Key? key,
      required this.content,
      required this.callback,
      required this.child})
      : super(key: key);

  @override
  State<WidgetAlert> createState() => _WidgetAlertState();
}

class _WidgetAlertState extends State<WidgetAlert> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: this.widget.child,
      onTap: () => showAlert(),
    );
  }

  showAlert() async => await NAlertDialog(
        content: Padding(
          padding: EdgeInsets.only(top: 20.h, bottom: 5.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(this.widget.content, style: text_alert_title)],
          ),
        ),
        actions: [
          Container(
            width: 300.w,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w, bottom: 7.h),
                    child: buttonBatal(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 5.w, bottom: 7.h, right: 10.w),
                    child: buttonKonfirmasi(),
                  ),
                )
              ],
            ),
          ),
        ],
      ).show(context);

  Widget buttonBatal() => InkWell(
        onTap: () => Navigator.pop(context),
        child: Container(
          height: 22.h,
          decoration: decoration_alert_batal,
          child: Center(child: Text('Batal', style: text_alert_batal)),
        ),
      );

  Widget buttonKonfirmasi() => InkWell(
        onTap: () => this.widget.callback(),
        child: Container(
          height: 22.h,
          decoration: decoration_alert_yes,
          child: Center(child: Text('Ya', style: text_alert_yes)),
        ),
      );
}
