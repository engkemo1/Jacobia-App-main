import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jacobia/constants.dart';
import 'package:jacobia/core/localization/app_localization.dart';
import 'package:jacobia/main.dart';
import 'package:jacobia/view/components/component.dart';
import 'package:jacobia/view/pages/MainScreen.dart';
import 'package:jacobia/view/pages/authentication/Signup.dart';
import 'package:jacobia/view_model/AuthGetX/AuthController.dart';

class SignIn extends StatefulWidget {
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final AuthController controller = Get.put(AuthController());

  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(gradient: newVv),
        child: Column(
          children: [
            /// Language Dropdown


            /// Logo & Welcome Text
            Container(
              height: 210,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [


                  Image.asset(
                    'assets/icons/logo.png',
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "login".tr,
                        style: const TextStyle(color: Colors.white, fontSize: 25.5),
                        textAlign: TextAlign.end,
                      ),
                      const SizedBox(height: 7.5),
                      Text(
                       "welcome_back".tr,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// Form Fields
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      DropdownButton<String>(
                        isExpanded: true,
                        elevation: 0,
                        padding: EdgeInsets
                        .symmetric(horizontal: 10),
                        icon: Icon(Icons.language,color: primaryColor,),
                        underline: SizedBox(),
                        value: Get.locale?.languageCode ?? 'en',
                        onChanged: (String? languageCode) {
                          if (languageCode != null) {
                            Get.updateLocale(Locale(languageCode)); // ✅ Updates language instantly
                          }
                        },
                        items: const [
                          DropdownMenuItem(value: "en", child: Text("English")),
                          DropdownMenuItem(value: "ar", child: Text("العربية")),
                        ],
                      ),
                      const SizedBox(height: 100),

                      /// Email & Password Fields
                      _buildTextField(
                        controller: emailController,
                        hintText: 'email'.tr,
                        icon: Icons.email_outlined,
                        validator: validateEmail,
                      ),
                      _buildTextField(
                        controller: passController,
                        hintText: "password".tr,
                        icon: Icons.lock_rounded,
                        isPassword: true,
                      ),
                      const SizedBox(height: 35),

                      /// Login Button
                      GetBuilder<AuthController>(
                        builder: (_) {
                          return _buildButton(
                            text: "login".tr,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                controller.loginUser(emailController.text, passController.text);
                              }
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 25),

                      /// Register Navigation
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text(
                            'no_account'.tr,
                            style: const TextStyle(color: Colors.black),
                          ),                          SizedBox(width: 5,),


                          InkWell(
                            onTap: () => navigatorAndRemove(context, SignUp()),
                            child: Text(
                              "create_account".tr,
                              style: const TextStyle(color: secondaryColor, fontWeight: FontWeight.bold),
                            ),
                          ),

                        ],
                      ),
                      const SizedBox(height: 25),

                      /// Social Login Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildSocialButton(FontAwesomeIcons.facebook, 'facebook'.tr, Colors.blue,()async{
                              User? user = await controller.signInWithFacebook();
                              print(user);

                              if (user != null) {
                                Get.offAll(MainScreen());


                            }
                          }),
                          _buildSocialButton(FontAwesomeIcons.google, 'google'.tr, Colors.red,()async{

                            User? user = await controller.signInWithGoogle();
                            print(user);
                            if (user != null) {
                              // Navigate to the home page after successful login
                              Get.offAll(MainScreen());          }
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Reusable TextField Widget
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? !_passwordVisible : false,
        validator: validator,

        style: const TextStyle(fontSize: 15),
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10),
          prefixIcon: Icon(icon, size: 24),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          )
              : null,
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }

  /// Reusable Button Widget
  Widget _buildButton({required String text, required VoidCallback onPressed}) {
    return MaterialButton(
      onPressed: onPressed,
      height: 45,
      minWidth: 240,
      child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      textColor: Colors.white,
      color: secondaryColor,
      shape: const StadiumBorder(),
    );
  }

  /// Reusable Social Button Widget
  _buildSocialButton(IconData icon, String text, Color color,void Function()? onPressed) {
    return MaterialButton(
      onPressed: onPressed,
      height: 45,
      minWidth: 140,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
      textColor: Colors.white,
      color: color,
      shape: const StadiumBorder(),
    );
  }
}
