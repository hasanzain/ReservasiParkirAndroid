import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:parking_reservation/utils/constant_themes.dart';
import 'package:parking_reservation/views/daftar_pesanan_page.dart';

class TopbarDashboard extends StatefulWidget {
  TopbarDashboard({Key? key}) : super(key: key);

  @override
  State<TopbarDashboard> createState() => _TopbarDashboardState();
}

class _TopbarDashboardState extends State<TopbarDashboard> {
  DatabaseReference userRef = FirebaseDatabase.instance.ref("user_booking_tbl");
  FirebaseAuth auth = FirebaseAuth.instance;

  DatabaseReference bookingParkirRef =
      FirebaseDatabase.instance.ref("booking_parkir_tbl");

  var hasBooked = false.obs;

  Future bookingParkirListener() async {
    bookingParkirRef.onValue.listen((event) {
      final data = event.snapshot.value;

      Map? map = data as Map?;

      hasBooked.value = false;

      for (var item in map!.values) {
        if (item["id_user"] == auth.currentUser!.uid) {
          hasBooked.value = true;
        }
      }
    });
  }

  // Future userListener() async {
  //   userRef
  //       .child(auth.currentUser!.uid)
  //       .child("list_booking")
  //       .onValue
  //       .listen((event) {
  //     final data = event.snapshot.exists;
  //     if (data)
  //       hasBooked.value = true;
  //     else
  //       hasBooked.value = false;
  //   });
  // }

  @override
  void initState() {
    // userListener();
    bookingParkirListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        container(),
        SizedBox(height: 5.h),
        containerNotif(),
      ],
    );
  }

  Widget containerNotif() => Obx(() => Container(
        margin: margin_container_notif,
        padding: padding_container_notif,
        decoration: (hasBooked.value)
            ? decoration_available_container_notif
            : decoration_unavailable_container_notif,
        width: double.infinity,
        height: 32.h,
        child: Center(
          child: Row(
            mainAxisAlignment: (hasBooked.value)
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: [notif(), (hasBooked.value) ? lihat() : Container()],
          ),
        ),
      ));

  Widget lihat() => InkWell(
        onTap: () => Get.to(() => DaftarpesananPage()),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
          child: Text("Lihat", style: ts_value_notif),
        ),
      );

  Widget notif() => Obx(() => (hasBooked.value)
      ? Text("Anda memiliki pesanan aktif", style: ts_key_notif)
      : Text("Anda tidak memiliki pesanan", style: ts_key_notif));

  Widget container() => Container(
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10.r),
              bottomRight: Radius.circular(10.r),
            )),
        width: double.infinity,
        height: 80.h,
        padding: small_padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            profileLogo(),
            SizedBox(width: 10.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                greet(),
                nama(),
              ],
            ),
          ],
        ),
      );

  Widget greet() =>
      Text("Selamat datang", style: text_greet_style_topbar_dashboard);

  Widget nama() =>
      Text(auth.currentUser!.email!, style: text_name_style_topbar_dashboard);

  Widget profileLogo() => const CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(Icons.person, color: Colors.blue),
      );
}
