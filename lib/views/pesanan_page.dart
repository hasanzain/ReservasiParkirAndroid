import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:parking_reservation/models/item_booking_model.dart';
import 'package:parking_reservation/utils/constant_themes.dart';
import 'package:parking_reservation/utils/general.dart';
import 'package:parking_reservation/widgets/topbar_pesanan.dart';
import 'package:parking_reservation/widgets/widget_alert.dart';
import 'package:parking_reservation/widgets/widget_qrcode.dart';
import 'package:intl/intl.dart';

class PesananPage extends StatefulWidget {
  final ItemBookingModel item;

  PesananPage({Key? key, required this.item}) : super(key: key);

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> {
  // halaman ini memuat informasi pesanan parkir yang sudah ada
  // 1. kode booking dalam bentuk qr code
  // 2. opsi pembatalan booking

  // initialize firebase auth
  FirebaseAuth auth = FirebaseAuth.instance;

  DatabaseReference bookingRef =
      FirebaseDatabase.instance.ref("booking_parkir_tbl");
  DatabaseReference statusParkirRef =
      FirebaseDatabase.instance.ref("parking_status_tbl");

  var kodeBooking = "".obs;
  var kodeTempat = "".obs;
  var statusDitempati = "".obs;

  bool loading = false;

  var jamMasuk = "-".obs;
  var jamKeluar = "-".obs;

  var estimasiBiaya = "Belum ada".obs;
  int? fee;

  // hapus data booking dari booking_parkir_tbl
  cancelDeleteBooking(String kodeBooking) async {
    await bookingRef
        .child(kodeBooking)
        .remove()
        .then((value) => print("removed succesfully"))
        .catchError((error) => print("error"));
  }

  cancelUpdateUserList(String kodeBooking) async {
    DatabaseReference reference = FirebaseDatabase.instance
        .ref("user_booking_tbl")
        .child(auth.currentUser!.uid);

    await reference.child("list_booking").remove();
  }

  // ubah status parkir
  cancelUpdateStatusParkir(String idTempat) async {
    statusParkirRef
        .update({"$idTempat/status_tersedia": "tersedia"})
        .then((value) => print("Updated succesfuly"))
        .onError((error, stackTrace) => print("error : $error"));
  }

  feeParkirListener() {
    FirebaseDatabase.instance.ref("tarif_tbl").onValue.listen((event) {
      final data = event.snapshot.value;

      Map map = data as Map;
      fee = map["per30menit"];

      print("fee: $fee");
      getDetailDataBooking(kodeBooking.value);
    });
  }

  getDetailDataBooking(String kodeBooking) async {
    bookingRef.child(kodeBooking).onValue.listen((event) {
      if (event.snapshot.exists) {
        final data = event.snapshot.value;

        Map map = data as Map;
        Map<String, dynamic> _ = {};

        List<String> keys = [];
        List<dynamic> values = [];

        for (var item in map.keys) keys.add(item);

        for (var item in map.values) values.add(item);

        for (int i = 0; i < keys.length; i++) _[keys[i]] = values[i];

        statusDitempati.value = _["status_ditempat"];
        hitungEstimasiBiaya(_["jam_masuk"], _["jam_keluar"]);
      }
    });
  }

  void hitungEstimasiBiaya(String jMasuk, String jKeluar) {
    if (jMasuk != "0") {
      if (jKeluar != "0") {
        DateTime start =
            DateTime.fromMillisecondsSinceEpoch(int.parse(jMasuk) * 1000);
        DateTime finish =
            DateTime.fromMillisecondsSinceEpoch(int.parse(jKeluar) * 1000);

        var result = finish.difference(start).inMinutes / 30;
        estimasiBiaya.value = ((result * fee!) + fee!).toString();

        jamMasuk.value = GeneralUtils.parseDt(start);
        jamKeluar.value = GeneralUtils.parseDt(finish);
      } else {
        DateTime start =
            DateTime.fromMillisecondsSinceEpoch(int.parse(jMasuk) * 1000);
        DateTime now = DateTime.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch);

        var result = now.difference(start).inMinutes / 30;

        estimasiBiaya.value = ((result * fee!) + fee!).toString();
        Get.snackbar(
            "result",
            "result: " +
                result.toString() +
                "| estimated: " +
                estimasiBiaya.value);

        jamMasuk.value = GeneralUtils.parseDt(start);
      }

      estimasiBiaya.value =
          estimasiBiaya.value.substring(0, estimasiBiaya.value.length - 2);
      estimasiBiaya.value = GeneralUtils.formatCurrency(estimasiBiaya.value);

      estimasiBiaya.value = "Rp ${estimasiBiaya.value}";
    } else {
      estimasiBiaya.value = "belum ada";
    }

    if (mounted) setState(() {});
  }

  @override
  void initState() {
    kodeBooking.value = widget.item.kodeBooking!;
    feeParkirListener();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: 1.sh,
          width: 1.sw,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  tb(),
                  SizedBox(height: 100.h),
                  (loading) ? Container() : qr(),
                  SizedBox(height: 10.h),
                  (loading)
                      ? Container()
                      : Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 2.h, horizontal: 5.w),
                          child: Column(
                            children: [
                              infoWaktuBooking(),
                              infoKodeBooking(),
                              infoBiaya(),
                              jamMasukInfo(),
                              jamKeluarInfo(),
                              infoStatusDitempati(),
                            ],
                          ),
                        ),
                ],
              ),
              (loading)
                  ? Container()
                  : (jamMasuk.value != "-")
                      ? Container()
                      : batal(),
            ],
          ),
        ),
      ),
    );
  }

  Widget tb() => TopbarPesanan(title: 'Pesanan', callback: () => Get.back());

  Widget qr() => WidgetQrcode(data: widget.item.kodeBooking!);

  Widget batal() => WidgetAlert(
        content: 'Lanjut batalkan pemesanan tempat parkir?',
        callback: () async {
          loading = true;

          await cancelDeleteBooking(kodeBooking.value);
          await cancelUpdateStatusParkir(kodeBooking.value);
          await cancelUpdateUserList(kodeBooking.value);

          loading = false;
          Get.back();

          Get.back(closeOverlays: true);
        },
        child: Container(
          margin: margin_button,
          width: double.infinity,
          height: 32.h,
          decoration: decoration_batal_pesanan,
          child: Center(
            child:
                Text("Batalkan pemesanan", style: text_style_batalkan_pesanan),
          ),
        ),
      );

  Widget jamMasukInfo() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Jam masuk"),
          Obx(() => Text(jamMasuk.value)),
        ],
      );

  Widget infoStatusDitempati() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Status ditempati"),
          Obx(() => Text(statusDitempati.value)),
        ],
      );

  Widget jamKeluarInfo() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Jam keluar"),
          Obx(() => Text(jamKeluar.value)),
        ],
      );

  Widget infoKodeBooking() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Tempat"),
          Obx(() => Text(kodeBooking.value)),
        ],
      );

  Widget infoBiaya() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Biaya"),
          Obx(() => Text(estimasiBiaya.value)),
        ],
      );

  Widget infoWaktuBooking() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Waktu booking"),
          Text(GeneralUtils.parseDt(DateTime.fromMillisecondsSinceEpoch(
              int.parse(widget.item.waktuBooking!)))),
        ],
      );
}
