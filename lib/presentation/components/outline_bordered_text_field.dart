import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/presentation/theme/app_style.dart';

class OutlinedBorderTextField extends StatelessWidget {
  final String? label;
  final VoidCallback? rowButton;
  final String? rowButtonText;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? obscure;
  final TextEditingController? textController;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final String? Function(String?)? validation;
  final TextInputType? inputType;
  final String? initialText;
  final String? descriptionText;
  final bool readOnly;
  final bool isError;
  final bool isSuccess;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final int? minLines;
  final int? maxLines;

  const OutlinedBorderTextField({
    super.key,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.obscure,
    this.validation,
    this.onChanged,
    this.textController,
    this.inputType,
    this.initialText,
    this.descriptionText,
    this.readOnly = false,
    this.isError = false,
    this.isSuccess = false,
    this.textCapitalization,
    this.textInputAction,
    this.hint,
    this.rowButton,
    this.rowButtonText,
    this.label,
    this.minLines,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label!,
                style: GoogleFonts.lato(
                  fontSize: 12,
                  color: Style.grey,
                ),
              ),
            ],
          ),
        TextFormField(
          onTap: onTap,
          onChanged: onChanged,
          obscureText: !(obscure ?? true),
          obscuringCharacter: "•",
          controller: textController,
          validator: validation,
          minLines: minLines,
          maxLines: maxLines,
          style: GoogleFonts.lato(
            fontSize: 15.sp,
            color: Style.black,
          ),
          cursorWidth: 1,
          cursorColor: Style.black,
          keyboardType: inputType,
          initialValue: initialText,
          readOnly: readOnly,
          textCapitalization: TextCapitalization.none,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            suffixIconConstraints:
                BoxConstraints(maxHeight: 40.h, maxWidth: 40.h),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            hintText: hint,
            hintStyle: GoogleFonts.lato(
              fontSize: 16,
              color: Style.hintColor,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            filled: false,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Style.black.withOpacity(0.2),
              ),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Style.red,
              ),
            ),
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Style.black.withOpacity(0.2),
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Style.black.withOpacity(0.2),
              ),
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Style.black.withOpacity(0.2),
              ),
            ),
          ),
        ),
        if (descriptionText != null)
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              5.verticalSpace,
              Text(
                descriptionText!,
                style: GoogleFonts.lato(
                  fontSize: 12,
                  color: isError
                      ? Style.red
                      : isSuccess
                          ? Style.grey
                          : Style.grey,
                ),
              ),
            ],
          )
      ],
    );
  }
}
