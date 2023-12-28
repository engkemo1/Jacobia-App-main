import 'package:flutter/material.dart';
import 'package:jacobia/constants.dart';


class iconswidget extends StatelessWidget {
  late String title;
  late Widget child;
  late double delayanimation;
  late Color color;

  iconswidget({required this.title,required this.child,required this.color,required this.delayanimation});


  @override
  Widget build(BuildContext context) {
    var we = MediaQuery.of(context).size.width;
    var he  = MediaQuery.of(context).size.height;

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color:  Colors.black12,
                    shape: BoxShape.rectangle// 0xFF17334E
                  ),
                  child:child
              ),

          ],
        ),
        SizedBox(
          height:  he * 0.01,
        ),
       Text(title,style: const TextStyle(color: Colors.grey),
            ),
      ],
    );
  }
}