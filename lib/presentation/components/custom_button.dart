import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/presentation/theme/app_style.dart';

import 'animation_button_effect.dart';

class CustomButton extends StatelessWidget {
  final Icon? icon;
  final String title;
  final bool isLoading;
  final Function()? onPressed;
  final Color background;
  final Color borderColor;
  final Color textColor;
  final double weight;
  final double height;
  final double radius;

  const CustomButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.background = Style.mainColor,
    this.textColor = Style.white,
    this.weight = double.infinity,
    this.radius = 8,
    this.height = 50,
    this.icon,
    this.borderColor = Style.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationButtonEffect(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          side: BorderSide(
              color:
                  borderColor == Style.transparent ? background : borderColor,
              width: 2.r),
          elevation: 0,
          shadowColor: Style.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.r),
          ),
          minimumSize: Size(weight, height),
          backgroundColor: background,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                width: 20.r,
                height: 20.r,
                child: CircularProgressIndicator(
                  color: Style.mainColor,
                  strokeWidth: 2.r,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon == null
                      ? const SizedBox()
                      : Row(
                          children: [
                            icon!,
                            10.horizontalSpace,
                          ],
                        ),
                  Text(
                    title,
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -14 * 0.01,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
