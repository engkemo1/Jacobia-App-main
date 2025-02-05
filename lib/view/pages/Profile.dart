import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jacobia/constants.dart';
import 'package:jacobia/core/localization/app_localization.dart';
import 'package:jacobia/view/components/component.dart';
import '../../Edit Information.dart';
import '../../view_model/AuthGetX/AuthController.dart';
import '../../view_model/database/local/cache_helper.dart';

class ProfileView extends StatelessWidget {
  final AuthController controller = AuthController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(gradient: newVv),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),

              /// Profile Picture
              CircleAvatar(
                radius: 60,
                backgroundImage: CacheHelper.get(key: 'imageUrl') == null
                    ? const AssetImage('assets/icons/logo.png')
                    : NetworkImage(CacheHelper.get(key: 'imageUrl')) as ImageProvider,
              ),

              /// Name
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 10),
                child: Text(
                  CacheHelper.get(key: 'name') ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
                ),
              ),

              /// Email
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.black26),
                child: Text(
                  CacheHelper.get(key: 'email') ?? '',
                  style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.07),

              /// Options Box
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.black54),
                margin: const EdgeInsets.symmetric(horizontal: 15),
                height: MediaQuery.of(context).size.height * 0.4,
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.07),

                    buildListTile(
                      text: "profile".tr,
                      icon: Icons.arrow_forward_ios_sharp,
                      onTap: () => navigatorScreen(context, EditInfo()),
                    ),

                    buildLanguageDropdown(),

                    buildListTile(
                      text: "logout".tr,
                      icon: Icons.logout,
                      iconColor: Colors.red,
                      onTap: () => controller.signout(),
                    ),

                    const Spacer(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Reusable Function for ListTile
  Widget buildListTile({required String text, required IconData icon, Color iconColor = Colors.white, required VoidCallback onTap}) {
    return ListTile(
        leading: Text(text, style: const TextStyle(fontSize: 19, color: Colors.white)),
      trailing: Icon(icon, color: iconColor),
      onTap: onTap,
    );
  }

  /// Language Selector Dropdown
  Widget buildLanguageDropdown() {
    return ListTile(
      leading: Text("language".tr, style: const TextStyle(fontSize: 19, color: Colors.white)),
      trailing: DropdownButton<String>(
        isExpanded: false,
        elevation: 0,
        dropdownColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        icon: const Icon(Icons.language, color: Colors.white),
        underline: const SizedBox(),
        value: Get.locale?.languageCode ?? 'en',
        onChanged: (String? languageCode) {
          if (languageCode != null) {
            Get.updateLocale(Locale(languageCode));
            AppLocalization.saveLanguage(languageCode);
            // ✅ Updates language instantly
          }
        },
        items: const [
          DropdownMenuItem(value: "en", child: Text("English ", style: TextStyle(color: Colors.white))),
          DropdownMenuItem(value: "ar", child: Text(" العربية", style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}
