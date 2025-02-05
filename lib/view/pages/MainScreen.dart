import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../view_model/Cubit/BottomNavBarCubit/BottomNavBarCubit.dart';
import '../../view_model/Cubit/BottomNavBarCubit/BottomNavBarState.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => BottomNavBarCubit(),
      child: BlocConsumer<BottomNavBarCubit, MainState>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, Object? state) {
          var cubit = BottomNavBarCubit.get(context);
          return Scaffold(
            body: cubit.screenList[cubit.index],
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.index,
              items: [
                buildBottomNavigationBarItem(
                    icon: FontAwesomeIcons.trophy, labelKey: "competitions"),
                buildBottomNavigationBarItem(
                    icon: FontAwesomeIcons.accusoft, labelKey: "results"),
                buildBottomNavigationBarItem(
                    icon: Icons.person, labelKey: "profile"),
                buildBottomNavigationBarItem(
                    icon: FontAwesomeIcons.wallet, labelKey: "wallet"),
              ],
              onTap: cubit.change,
            ),
          );
        },
      ),
    );
  }

  /// Reusable Function for BottomNavigationBarItem
  BottomNavigationBarItem buildBottomNavigationBarItem(
      {required IconData icon, required String labelKey}) {
    return BottomNavigationBarItem(
      icon: Icon(icon, color: secondaryColor),
      activeIcon: Text(labelKey.tr,
          style: TextStyle(fontSize: 12, color: primaryColor, fontWeight: FontWeight.bold)),
      label: "",
    );
  }
}
