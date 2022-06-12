import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../utils/constant_themes.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  bool visiblePassword = true;
  bool confirmVisiblePassword = true;

  Future register(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Register gagal", e.message!);
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
            children: [
              logo(),
              SizedBox(height: 5.h),
              fieldEmail(),
              SizedBox(height: 5.h),
              fieldPassword(),
              SizedBox(height: 10.h),
              confirm(),
              SizedBox(height: 10.h),
              buttonRegister(),
            ],
          ),
        ),
      ),
    );
  }

  Widget logo() => Container(
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

  Widget confirm() => TextFormField(
        controller: confirmPasswordController,
        obscureText: confirmVisiblePassword,
        decoration: InputDecoration(
          hintText: 'Konfirmasi password',
          suffixIcon: InkWell(
            onTap: () => setState(() => confirmVisiblePassword = !confirmVisiblePassword),
            child:
                Icon(confirmVisiblePassword ? Icons.visibility : Icons.visibility_off),
          ),
        ),
      );

  Widget buttonRegister() => InkWell(
        onTap: () {
          if (passwordController.text != confirmPasswordController.text) {
            // print error
            Get.snackbar("Register gagal", "password tidak sama");
          } else {
            register(emailController.text, passwordController.text);
          }
        },
        child: Container(
          decoration: decoration_button_active,
          width: double.infinity,
          height: 35.h,
          child: Center(
            child: Text("Register", style: text_active_white),
          ),
        ),
      );
}
