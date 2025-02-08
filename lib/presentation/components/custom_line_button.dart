import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/presentation/theme/app_style.dart';

import 'animation_button_effect.dart';

class CustomLineButton extends StatelessWidget {
  final Icon? icon;
  final SvgPicture? svg;
  final String title;
  final bool isLoading;
  final Function()? onPressed;
  final Color background;
  final Color borderColor;
  final Color textColor;
  final double weight;
  final double height;
  final double radius;
  final FontWeight? fontWeight;

  const CustomLineButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.background = Style.transparent,
    this.textColor = Style.mainColor,
    this.weight = double.infinity,
    this.height = 50,
    this.radius = 8,
    this.icon,
    this.borderColor = Style.mainColor,
    this.svg,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationButtonEffect(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          side: BorderSide(
              color:
                  borderColor == Style.transparent ? background : borderColor,
              width: 1.r),
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
                  color: textColor,
                  strokeWidth: 2.r,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  svg == null
                      ? const SizedBox()
                      : Row(
                          children: [
                            svg!,
                            10.horizontalSpace,
                          ],
                        ),
                  Text(
                    title,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: textColor,
                      fontWeight: fontWeight,
                      letterSpacing: -14 * 0.01,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
