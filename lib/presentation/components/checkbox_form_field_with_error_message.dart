import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/presentation/theme/app_style.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

// ignore: must_be_immutable
class CheckBoxFormFieldWithErrorMessage extends StatefulWidget {
  final String labelText;
  final bool isChecked;
  String error;
  final void Function(bool?) onChanged;

  CheckBoxFormFieldWithErrorMessage({
    super.key,
    required this.labelText,
    required this.isChecked,
    required this.onChanged,
    required this.error,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CheckBoxFormFieldWithErrorMessageState createState() =>
      _CheckBoxFormFieldWithErrorMessageState();
}

class _CheckBoxFormFieldWithErrorMessageState
    extends State<CheckBoxFormFieldWithErrorMessage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundCheckBox(
              onTap: (value) {
                setState(() {
                  widget.onChanged(value);
                });
              },
              isRound: true,
              isChecked: widget.isChecked,
              size: 25,
              checkedColor: Style.bred,
              borderColor: Style.bgGrey,
            ),
            10.horizontalSpace,
            Expanded(
              child: Text(
                widget.labelText,
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Style.black,
                ),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              (widget.error.isNotEmpty) ? ' * ${widget.error}' : '',
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.lato(
                fontSize: 12,
                color: Style.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
