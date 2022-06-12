import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:parking_reservation/models/parking_status_model.dart';
import 'package:parking_reservation/models/status_parking_model.dart';

// import 'package:parking_reservation/models/status_parking_model.dart';
import 'package:parking_reservation/utils/constant_themes.dart';
import 'package:parking_reservation/views/login_page.dart';
import 'package:parking_reservation/widgets/parking_status_item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:parking_reservation/widgets/top_bar_dashboard.dart';
import 'package:parking_reservation/widgets/widget_alert.dart';
import 'package:random_string/random_string.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<ItemStatusParkingModel> daftarStatusParkir = [];

  DatabaseReference bookingParkirRef =
      FirebaseDatabase.instance.ref("booking_parkir_tbl");
  DatabaseReference statusParkirRef =
      FirebaseDatabase.instance.ref("parking_status_tbl");

  // initialize firebase auth
  FirebaseAuth auth = FirebaseAuth.instance;

  var hasBooked = false.obs;

  // Future checkUserBookingTbl() async {
  //   DatabaseReference userBookingReference =
  //       FirebaseDatabase.instance.ref("user_booking_tbl");
  //
  //   final snapshot =
  //       await userBookingReference.child(auth.currentUser!.uid).get();
  //   if (snapshot.exists) {
  //     final booking = snapshot.child("list_booking");
  //     if (booking.exists) {
  //       hasBooked.value = true;
  //       print("has booked true");
  //     } else
  //       hasBooked.value = false;
  //   } else {
  //     Map value = {
  //       "email_user": auth.currentUser!.email,
  //       "id_user": auth.currentUser!.uid,
  //     };
  //     userBookingReference.child(auth.currentUser!.uid).set(value);
  //
  //     // print("data created.");
  //   }
  // }

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

  databaseListener() async {
    statusParkirRef.orderByValue().onValue.listen(
      (event) {
        final data = event.snapshot.value;

        Map? map = data as Map?;
        daftarStatusParkir = [];

        for (var item in map!.entries) {
          ItemStatusParkingModel itemStatusParkingModel =
              ItemStatusParkingModel(
            idTempat: item.key,
            lokasiTempat: item.value['lokasi'],
            statusTersedia: item.value['status_tersedia'],
          );

          daftarStatusParkir.add(itemStatusParkingModel);
        }

        setState(() {});
      },
    );
  }

  bookingParkir(String idTempat) async {
    String idUser = auth.currentUser!.uid;

    var ts_masuk = DateTime.now().millisecondsSinceEpoch;

    await bookingParkirRef.child(idTempat).set({
      "id_user": idUser,
      "jam_masuk": "0",
      "jam_keluar": "0",
      "kode_booking": idTempat,
      "waktu_booking": ts_masuk.toString(),
      "status_ditempat": "belum",
    });
  }

  updateUserBookingTbl(String idTempat) async {
    String idUser = auth.currentUser!.uid;
    DatabaseReference userBookingReference =
        FirebaseDatabase.instance.ref("user_booking_tbl");

    // Map value = {"kode_booking": kodeBooking};

    await userBookingReference
        .child(idUser)
        .child("list_booking")
        .set(idTempat);
  }

  updateStatusParkirTbl(String idTempat) async {
    if (daftarStatusParkir.isNotEmpty) {
      DatabaseReference reference =
          FirebaseDatabase.instance.ref("parking_status_tbl");

      await reference.update({"$idTempat/status_tersedia": "tidak_tersedia"});
    }
  }

  logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAll(LoginPage());
  }

  @override
  void initState() {
    // checkUserBookingTbl();
    bookingParkirListener();
    databaseListener();
    // userListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: 1.sh,
          width: 1.sw,
          // padding: small_padding,
          child: Center(
            child: Column(
              children: [
                TopbarDashboard(),
                SizedBox(height: 10.h),
                Expanded(child: listStatusParkir()),
                SizedBox(height: 10.h),
                buttonLogout(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonLogout() => WidgetAlert(
        content: 'Keluar dari aplikasi?',
        callback: () => logout(),
        child: Container(
          margin: margin_button,
          decoration: decoration_button_active,
          width: double.infinity,
          height: 35.h,
          child: Center(
            child: Text("Logout", style: text_active_white),
          ),
        ),
      );

  Widget listStatusParkir() => ListView.builder(
        shrinkWrap: true,
        itemCount: daftarStatusParkir.length,
        itemBuilder: (context, index) => StatusParkingItem(
          parkingStatusModel: daftarStatusParkir[index],
          callbackBooking: (value) async {
            await databaseListener();

            if (hasBooked.value == false) {
              await bookingParkir(value);
              await updateStatusParkirTbl(value);
              await updateUserBookingTbl(value);

              Get.back();
            } else {
              Get.back();

              Get.snackbar(
                "Error",
                "Anda tidak bisa booking karena masih ada 1 booking aktif",
                snackPosition: SnackPosition.TOP,
              );
            }
          },
        ),
      );
}
