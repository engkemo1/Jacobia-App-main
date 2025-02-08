import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final String uid = CacheHelper.get(key: 'uid') ?? '';
    final String name = CacheHelper.get(key: 'name') ?? '';
    final String email = CacheHelper.get(key: 'email') ?? '';
    final String imageUrl = CacheHelper.get(key: 'imageUrl') ?? '';

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,

          child: Stack(
            children: [
              /// **Background with Blur Effect**
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor.withOpacity(0.7), Colors.blueGrey.shade900],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              /// **Main Content**
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    /// **Profile Picture with Glow Effect**
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.5),
                            blurRadius: 25,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        backgroundImage: imageUrl.isEmpty
                            ? const AssetImage('assets/icons/logo.png')
                            : NetworkImage(imageUrl) as ImageProvider,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// **User Name**
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// **UID with Copy Button**
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            uid,
                            style: TextStyle(fontSize: 14, color: Colors.white70),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: uid));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Copied to clipboard")),
                              );
                            },
                            child: Icon(Icons.copy, size: 18, color: Colors.white),
                          ),
                        ],
                      ),
                    ),

                    /// **Email Display**
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white10,
                      ),
                      child: Text(email, style: TextStyle(fontSize: 15, color: Colors.white70)),
                    ),

                    const SizedBox(height: 40),

                    /// **Options Card with Glassmorphism Effect**
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          buildListTile(
                            text: "profile".tr,
                            icon: Icons.person,
                            onTap: () => navigatorScreen(context, EditInfo()),
                          ),
                          Divider(color: Colors.white24),
                          buildLanguageDropdown(),
                          Divider(color: Colors.white24),
                          buildListTile(
                            text: "logout".tr,
                            icon: Icons.logout,
                            iconColor: Colors.red,
                            onTap: () => controller.signout(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// **List Tile with Neon Glow**
  Widget buildListTile({required String text, required IconData icon, Color iconColor = Colors.white, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
              ),
              child: Icon(icon, color: iconColor),
            ),
          ],
        ),
      ),
    );
  }

  /// **Language Dropdown with Modern Design**
  Widget buildLanguageDropdown() {
    return ListTile(
      leading: Text("language".tr, style: TextStyle(fontSize: 18, color: Colors.white)),
      trailing: DropdownButton<String>(
        dropdownColor: Colors.black87,
        icon: Icon(Icons.language, color: Colors.white),
        underline: SizedBox(),
        value: Get.locale?.languageCode ?? 'en',
        onChanged: (String? languageCode) {
          if (languageCode != null) {
            Get.updateLocale(Locale(languageCode));
            AppLocalization.saveLanguage(languageCode);
          }
        },
        items: [
          DropdownMenuItem(value: "en", child: Text("English", style: TextStyle(color: Colors.white))),
          DropdownMenuItem(value: "ar", child: Text("العربية", style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}
