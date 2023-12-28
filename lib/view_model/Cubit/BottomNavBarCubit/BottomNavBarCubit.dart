

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../view/pages/Profile.dart';
import '../../../view/pages/Compettition/Compettition.dart';
import '../../../view/pages/HomeScreen.dart';
import '../../../view/pages/wallet.dart';
import 'BottomNavBarState.dart';


class BottomNavBarCubit extends Cubit<MainState>{
  BottomNavBarCubit():super(MainInitialState());

static BottomNavBarCubit get(context)=>BlocProvider.of(context);
  List<Widget> screenList=[Competition(),HomeScreen(),ProfileView(),Wallet()];
  int index=0;
  change(int i){
    index=i;
    emit(ChangeNavState());
  }

}