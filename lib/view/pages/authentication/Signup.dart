import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../constants.dart';
import '../../../view_model/AuthGetX/AuthController.dart';
import '../../components/component.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  static const String id = "sign_up_page";

  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController numController = TextEditingController();
  final TextEditingController nickController = TextEditingController();
  final TextEditingController addrController = TextEditingController();
  final TextEditingController natioController = TextEditingController();

  var controller = Get.put(AuthController());
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(gradient: newVv),
        child: Column(
          children: [
            /// Header
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset('assets/icons/logo.png', height: 100, width: 100),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('login'.tr, style: TextStyle(color: Colors.white, fontSize: 25.5)),
                        Text("welcome".tr, style: TextStyle(color: Colors.white, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            /// Form Section
            Expanded(
              flex: 5,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        buildTextField(nameController, "full_name"),
                        buildTextField(emailController, "email"),
                        buildTextField(passController, "password", isPassword: true),
                        buildTextField(numController, "whatsapp_number"),
                        buildTextField(nickController, "nickname"),
                        buildTextField(addrController, "residence"),
                        buildTextField(natioController, "nationality"),
                        const SizedBox(height: 35),

                        /// Sign Up Button
                        GetBuilder<AuthController>(
                          builder: (_) {
                            return MaterialButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  controller.registerUser(
                                    nameController.text,
                                    emailController.text,
                                    passController.text,
                                    numController.text,
                                    nickController.text,
                                    natioController.text,
                                    addrController.text,
                                  );
                                }
                              },
                              height: 45,
                              minWidth: 240,
                              shape: const StadiumBorder(),
                              color: secondaryColor,
                              child: Text("sign_in".tr, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                            );
                          },
                        ),
                        const SizedBox(height: 30),

                        /// Already Have an Account?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [


                            Text("already_have_account".tr, style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold)),
                            SizedBox(width: 5,),

                            InkWell(
                              child: Text('sign_in'.tr, style: TextStyle(fontWeight: FontWeight.bold, color: secondaryColor)),
                              onTap: () {
                                navigatorAndRemove(context, SignIn());
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        /// Social Login Buttons
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     buildSocialButton(FontAwesomeIcons.facebook, "facebook", Colors.blue),
                        //     buildSocialButton(FontAwesomeIcons.google, "google", Colors.red),
                        //   ],
                        // ),
                      ],
                    ),
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
  Widget buildTextField(TextEditingController controller, String hintKey, {bool isPassword = false}) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          obscureText: isPassword ? !_passwordVisible : false,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            border: InputBorder.none,
            hintText: hintKey.tr,
            hintStyle: TextStyle(color: Colors.grey),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            )
                : null,
          ),
        ),
        Divider(thickness: 0.5, height: 10),
      ],
    );
  }

  /// Reusable Social Login Button
  Widget buildSocialButton(IconData icon, String labelKey, Color color) {
    return MaterialButton(
      onPressed: () {},
      height: 45,
      minWidth: 140,
      shape: const StadiumBorder(),
      color: color,
      textColor: Colors.white,
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Text(labelKey.tr, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
