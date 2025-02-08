import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Style {
  Style._();
  static const Color transparent = Color(0x00FFFFFF);
  static const Color mainColor = Color(0xFFFD4F3F);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF232B2F);
  static const Color grey = Color(0xFF898989);
  static const Color bgGrey = Color.fromARGB(255, 210, 211, 215);
  static const Color backgroundColor = Color(0xFFE9E9EA);
  static const Color hintColor = Color.fromARGB(255, 147, 147, 147);
  static const Color red = Color(0xFFFF3D00);
  static const Color bred = Color.fromARGB(255, 142, 33, 0);

  /// dark theme based colors
  static const Color mainBackDark = Color(0xFF1E272E);
  static const Color dragElementDark = Color(0xFFE5E5E5);
}

class AppTextStyle {
  AppTextStyle._();

  static TextStyle get textStyle => GoogleFonts.lato(
        fontSize: 16.sp,
        color: Style.black,
      );
}

class AppStyle {
  AppStyle._();

  static BoxDecoration get containerDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(width: 1, color: Style.bgGrey),
      );
}
