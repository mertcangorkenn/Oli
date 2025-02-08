import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/presentation/components/checkbox_form_field_with_error_message.dart';
import 'package:listing/presentation/components/custom_app_bar.dart';
import 'package:listing/presentation/components/custom_button.dart';
import 'package:listing/presentation/theme/app_style.dart';

@RoutePage()
class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final key = GlobalKey<FormState>();
  String agreeError = "";
  bool agreeTerms = false;
  bool isChanged = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(label: 'deletemyaccount'.tr()),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'sendyourfeedback'.tr(),
                    textAlign: TextAlign.left,
                    style:
                        GoogleFonts.lato(fontSize: 14, color: Style.hintColor),
                  ),
                  TextFormField(
                    maxLines: 6,
                    decoration: InputDecoration(
                        hintStyle:
                            GoogleFonts.lato(fontSize: 14, color: Style.black),
                        hintText: 'tellyouclosingaccount'.tr(),
                        enabledBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Style.bgGrey)),
                        focusedBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Style.bgGrey)),
                        errorBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Style.bgGrey)),
                        disabledBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Style.bgGrey)),
                        focusedErrorBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Style.bgGrey))),
                  ),
                ],
              ),
            ),
            10.verticalSpace,
            Container(
              height: size.height * 0.08,
              width: size.width,
              decoration: BoxDecoration(
                  color: Style.white,
                  border: Border.all(width: 1, color: Style.bgGrey)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: CheckBoxFormFieldWithErrorMessage(
                  labelText: 'iconfirmtransactionscompleted'.tr(),
                  isChecked: agreeTerms,
                  onChanged: (bool? value) {
                    setState(() {
                      isChanged = true;
                      agreeTerms = value!;
                      if (agreeTerms) {
                        agreeError = '';
                      } else {
                        agreeError = 'fieldRequiredError'.tr();
                      }
                    });
                  },
                  error: agreeError,
                ),
              ),
            ),
            10.verticalSpace,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'deleteaccounttext'.tr(),
                textAlign: TextAlign.left,
                style: GoogleFonts.lato(color: Style.grey, fontSize: 14),
              ),
            ),
            20.verticalSpace,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                title: 'deletemyaccount'.tr(),
                onPressed: () {},
                background: Style.bred,
              ),
            )
          ],
        ),
      ),
    );
  }
}
