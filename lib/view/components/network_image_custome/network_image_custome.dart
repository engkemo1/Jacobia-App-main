import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

networkImageCustom({
  String? url,
  double? width = double.infinity,
  double? height = 30,
  BoxFit fit = BoxFit.cover,
  double? borderRadius = 8,
}) {
  return Container(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    width: width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius!),
    ),
    child: Image.network(
        errorBuilder: (context, err, s) => Image.asset(
              'assets/images/placeholder.jpg',
              fit: BoxFit.cover,
            ),
        url!,
        fit: fit),
  );
}
