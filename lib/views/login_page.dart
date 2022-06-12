import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:parking_reservation/utils/constant_themes.dart';
import 'package:parking_reservation/views/register_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool visiblePassword = true;

  Future login(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        // Get.showSnackbar(GetSnackBar(message: "User tidak ditemukan"));
        Get.snackbar('Login gagal', "User tidak ditemukan");
      } else if (e.code == "wrong-password") {
        // Get.showSnackbar(GetSnackBar(message: "password salah"));
        Get.snackbar("Login gagal", "Password salah");
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: 1.sh,
          width: 1.sw,
          color: Colors.white,
          padding: small_padding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              logo(),
              SizedBox(height: 10.h),
              fieldEmail(),
              SizedBox(height: 10.h),
              fieldPassword(),
              SizedBox(height: 20.h),
              buttonLogin(),
              SizedBox(height: 20.h),
              navToRegister(),
            ],
          ),
        ),
      ),
    );
  }

  Widget logo() => SizedBox(
      width: 250.w,
      height: 150.h,
      child: Image.asset("asset/images/parking.png"));

  Widget fieldEmail() => TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(hintText: 'Email'),
      );

  Widget fieldPassword() => TextFormField(
        controller: passwordController,
        obscureText: visiblePassword,
        decoration: InputDecoration(
          hintText: 'Password',
          suffixIcon: InkWell(
            onTap: () => setState(() => visiblePassword = !visiblePassword),
            child:
                Icon(visiblePassword ? Icons.visibility : Icons.visibility_off),
          ),
        ),
      );

  Widget buttonLogin() => InkWell(
        onTap: () => login(emailController.text, passwordController.text),
        child: Container(
          decoration: decoration_button_active,
          width: double.infinity,
          height: 35.h,
          child: Center(
            child: Text("Login", style: text_active_white),
          ),
        ),
      );

  Widget navToRegister() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Belum punya akun? "),
          InkWell(
            onTap: () => Get.to(RegisterPage()),
            child: Text("Silahkan register",
                style: TextStyle(
                    color: primary_color, fontWeight: FontWeight.w600)),
          ),
        ],
      );
}
