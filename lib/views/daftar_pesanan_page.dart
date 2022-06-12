import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:parking_reservation/models/item_booking_model.dart';
import 'package:parking_reservation/utils/constant_themes.dart';
import 'package:parking_reservation/views/pesanan_page.dart';
import 'package:parking_reservation/widgets/pesanan_parkir_item.dart';
import 'package:parking_reservation/widgets/topbar_pesanan.dart';

class DaftarpesananPage extends StatefulWidget {
  DaftarpesananPage({Key? key}) : super(key: key);

  @override
  State<DaftarpesananPage> createState() => _DaftarpesananPageState();
}

class _DaftarpesananPageState extends State<DaftarpesananPage> {
  List<ItemBookingModel> daftarPesanan = [];

  // References
  DatabaseReference bookingParkirRef =
      FirebaseDatabase.instance.ref("booking_parkir_tbl");

  // authentication
  FirebaseAuth auth = FirebaseAuth.instance;

  var empty = false.obs;
  var loading = false.obs;

  Future getDaftarPesanan() async {
    loading.value = true;
    await bookingParkirRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        final data = event.snapshot.value;

        Map? map = data as Map?;
        daftarPesanan = [];

        for (var item in map!.values) {
          if (item["id_user"] == auth.currentUser!.uid) {
            ItemBookingModel itemBookingModel = ItemBookingModel(
              idUser: item["id_user"],
              jamKeluar: item["jam_keluar"],
              jamMasuk: item["jam_masuk"],
              kodeBooking: item["kode_booking"],
              waktuBooking: item["waktu_booking"],
              statusDitempati: item["status_ditempati"],
              // kodeTempat: item["kode_tempat"],
            );

            daftarPesanan.add(itemBookingModel);
          }
        }

        empty.value = false;
      } else {
        empty.value = true;
      }

      loading.value = false;
    });
  }

  @override
  void initState() {
    empty.value = true;
    getDaftarPesanan();

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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              tb(),
              SizedBox(height: 15.h),
              Obx(
                () => (loading.value)
                    ? Center(child: CircularProgressIndicator())
                    : (empty.value)
                        ? Container(
                            child: Center(
                                child: Text("Pesanan kosong",
                                    style: ts_key_notif)))
                        : list(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget tb() =>
      TopbarPesanan(title: 'Daftar pesanan', callback: () => Get.back());

  Widget list() => Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: daftarPesanan.length,
          itemBuilder: (context, index) => GestureDetector(
              onTap: () async {
                Get.to(() => PesananPage(item: daftarPesanan[index]))
                    ?.then((value) => getDaftarPesanan());
              },
              child: PesananParkirItem(item: daftarPesanan[index])),
        ),
      );
}
