import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/presentation/theme/app_style.dart';

class CustomMenuItem extends StatelessWidget {
  final IconData? icon;

  final Color? iconColor;
  final Widget? prefix;
  final String label;
  final Color? labelColor;
  final String? description;
  final VoidCallback onTap;
  final Map<String, bool> showBorders;
  final Widget? other;
  final Widget? suffix;

  const CustomMenuItem({
    super.key,
    required this.label,
    required this.onTap,
    required this.showBorders,
    this.icon,
    this.other,
    this.iconColor,
    this.suffix,
    this.description,
    this.prefix,
    this.labelColor = Style.black,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: size.height * 0.07,
        width: size.width,
        decoration: BoxDecoration(
          color: Style.white,
          border: Border(
            top: showBorders['top'] == true
                ? BorderSide(width: 1, color: Style.black.withOpacity(0.2))
                : BorderSide.none,
            bottom: showBorders['bottom'] == true
                ? BorderSide(width: 1, color: Style.black.withOpacity(0.2))
                : BorderSide.none,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (prefix != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: prefix,
                    ),
                    10.horizontalSpace,
                  ],
                ),
              if (icon != null)
                Row(
                  children: [
                    Icon(
                      icon,
                      color: iconColor ?? Style.hintColor,
                      size: 24.r,
                    ),
                    10.horizontalSpace,
                  ],
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: labelColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (description != null)
                      Text(
                        description!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: Style.hintColor,
                        ),
                      ),
                  ],
                ),
              ),
              10.horizontalSpace,
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: other,
                    ),
                    10.horizontalSpace,
                    suffix ??
                        Icon(
                          Remix.arrow_right_s_line,
                          color: Style.hintColor,
                          size: 24.r,
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
