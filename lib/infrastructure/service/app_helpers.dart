import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/presentation/theme/app_style.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AppHelpers {
  AppHelpers._();

  static showCheckTopSnackBar(BuildContext context, String text) {
    return showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: text,
        ),
        animationDuration: const Duration(milliseconds: 700),
        reverseAnimationDuration: const Duration(milliseconds: 700),
        displayDuration: const Duration(milliseconds: 700));
  }

  static showCheckTopSnackBarInfo(BuildContext context, String text,
      {VoidCallback? onTap}) {
    return showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.info(
          message: text,
        ),
        animationDuration: const Duration(milliseconds: 700),
        reverseAnimationDuration: const Duration(milliseconds: 700),
        displayDuration: const Duration(milliseconds: 700),
        onTap: onTap);
  }

  static showCheckTopSnackBarDone(BuildContext context, String text) {
    return showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          message: text,
        ),
        animationDuration: const Duration(milliseconds: 700),
        reverseAnimationDuration: const Duration(milliseconds: 700),
        displayDuration: const Duration(milliseconds: 700));
  }

  static showCheckTopSnackBarInfoCustom(BuildContext context, String text,
      {VoidCallback? onTap}) {
    return showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.info(
          message: text,
          icon: const SizedBox.shrink(),
          backgroundColor: Style.mainColor,
          textStyle: GoogleFonts.lato(),
        ),
        animationDuration: const Duration(milliseconds: 700),
        reverseAnimationDuration: const Duration(milliseconds: 700),
        displayDuration: const Duration(milliseconds: 700),
        onTap: onTap);
  }

  static showNoConnectionSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final snackBar = SnackBar(
      backgroundColor: Style.mainColor,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
      content: Text(
        'No internet connection',
        style: GoogleFonts.lato(
          fontSize: 14,
          color: Style.white,
        ),
      ),
      action: SnackBarAction(
        label: 'Close',
        disabledTextColor: Style.black,
        textColor: Style.black,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showCustomModalBottomSheet({
    required BuildContext context,
    required Widget modal,
    double radius = 16,
    bool isDrag = true,
    bool isDismissible = true,
    double paddingTop = 300,
  }) {
    showModalBottomSheet(
      isDismissible: isDismissible,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
        ),
      ),
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height - paddingTop,
      ),
      backgroundColor: Style.transparent,
      context: context,
      builder: (context) => modal,
    );
  }
}
