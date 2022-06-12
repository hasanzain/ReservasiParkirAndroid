import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:parking_reservation/utils/constant_themes.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:get/get.dart';

class WidgetQrcode extends StatefulWidget {
  final String data;

  WidgetQrcode({Key? key, required this.data}) : super(key: key);

  @override
  State<WidgetQrcode> createState() => _WidgetQrcodeState();
}

class _WidgetQrcodeState extends State<WidgetQrcode> {
  @override
  Widget build(BuildContext context) {
    return qr();
  }

  Widget qr() => QrImage(
        data: this.widget.data,
        size: 350.0,
        version: QrVersions.auto,
      );

  Widget dataText() => Text(this.widget.data);

  Widget iconCopy() => InkWell(
        onTap: () => FlutterClipboard.copy(this.widget.data).then(
            (value) => Get.snackbar("Pesan", "Kode booking berhasil disalin")),
        child: Icon(
          Icons.copy,
        ),
      );
}
